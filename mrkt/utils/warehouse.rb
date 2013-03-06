require 'csv'
require_relative 'string_patch'

class Warehouse
  include Singleton
  extend SingleForwardable

  attr_reader :price_regression, :dividend_regression, :average_dividend

  def initialize
    @graphite = Graphite.new :host => '127.0.0.1', :port => 2003
    @prices = []
    @transaction_times = []
    @dividends = []

    @price_regression = 0
    @dividend_regression = 0
    @average_dividend = 0
  end

  def log_transaction price
    @prices << price
    t = Time.now
    @transaction_times << t

    @graphite.push_to_graphite do |graphite|
      graphite.puts "mrkt.transactions.prices #{price} #{@graphite.time_now}"
    end

    Thread.new { calculate_price_regression t }
    Thread.new { calculate_dividend_regression }
    Thread.new { calculate_average_dividend }
    #perform other calculations here
  end

  def transactions
    result = {}
    @prices.size.times {|i| result[zeroed_transaction_times[i]] = @prices[i]}

    result
  end

  def zeroed_transaction_times
    start_time = @transaction_times[0].to_i
    @transaction_times.map {|t| t.to_i - start_time}
  end

  def transactions_for_chart
    [zeroed_transaction_times, @prices]
  end

  def transactions_to_csv
    CSV.open("data/#{Time.now}.csv", "w") do |csv|
      transactions.each {|t| csv << t}
    end
  end

  def log_dividend amount
    @dividends << amount
  end

  def dividends
    @dividends
  end

  def dividends_for_chart
    @dividends
  end

  def log_trader_performance trader, performance
    @graphite.push_to_graphite do |graphite|
      graphite.puts "mrkt.traders.#{trader.class.to_s.snake_case}.#{trader.object_id}.performance #{performance} #{@graphite.time_now}"
    end
  end

  def log_optimiser_performance optimiser, performance
    @graphite.push_to_graphite do |graphite|
      graphite.puts "mrkt.optimisers.#{optimiser.class.to_s.snake_case}.performance #{performance} #{@graphite.time_now}"
    end
  end

  def calculate_price_regression time
    prices = @transactions
    if !prices.empty?
      x_vector = prices.keys.to_vector(:scale)
      y_vector = prices.values.to_vector(:scale)
      regression = Statsample::Regression.simple(x_vector, y_vector)
      @price_regression = regression.y(time + 10) #replace 10 with investment horizon?
    end
  end

  def calculate_dividend_regression
    dividends = @dividends
    if !dividends.empty?
      x_vector = dividends.to_vector(:scale)
      y_vector = (0..dividends.size-1).to_vector(:scale)
      regression = Statsample::Regression.simple(x_vector, y_vector)
      @dividend_regression = regression.y(dividends.size)
    end
  end

  def calculate_average_dividend
    @average_dividend = @dividends.inject(:+) / @dividends.size unless @dividends.empty?
  end
  
  def_delegators :instance, *Warehouse.instance_methods(false)

end
