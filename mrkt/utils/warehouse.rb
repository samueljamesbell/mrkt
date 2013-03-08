require 'csv'
require_relative 'string_patch'

class Warehouse
  include Singleton
  extend SingleForwardable

  attr_reader :price_regression, :dividend_regression, :average_dividend

  def initialize
    @graphite = Graphite.new :host => '127.0.0.1', :port => 2003

    @transaction_prices = []
    @transaction_times = []
    @dividends = []

    @price_regression = 0
    @dividend_regression = 0
    @average_dividend = 0
  end

  def log_transaction price
    time = Time.now
    @transaction_prices << price
    @transaction_times << time

    graphite_log "mrkt.transactions.prices", price

    # Perform other calculations here
    Thread.new { calculate_price_regression time }
    Thread.new { calculate_dividend_regression }
    Thread.new { calculate_average_dividend }
  end

  def log_dividend amount
    @dividends << amount
  end

  def log_trader_performance trader
    graphite_log "mrkt.traders.#{trader.optimiser.to_s.snake_case}.#{trader.object_id}.performance", trader.performance
  end

  def log_optimiser_performance optimiser
    graphite_log "mrkt.optimisers.#{optimiser.class.to_s.snake_case}.performance", optimiser.performance
  end

  def transactions
    result = {}
    @transaction_prices.size.times {|i| result[zeroed_transaction_times[i]] = @transaction_prices[i]}

    result
  end

  def zeroed_transaction_times
    start_time = @transaction_times[0].to_i
    @transaction_times.map {|t| t.to_i - start_time}
  end

  def dividends
    @dividends
  end

  def calculate_price_regression time
    prices = transactions
    if !prices.empty?
      x_vector = prices.keys.to_vector(:scale)
      y_vector = prices.values.to_vector(:scale)
      regression = Statsample::Regression.simple(x_vector, y_vector)
      @price_regression = regression.y(time + 10) #replace 10 with investment horizon?
    end
  end

  def calculate_dividend_regression
    if !@dividends.empty?
      x_vector = @dividends.to_vector(:scale)
      y_vector = (0..@dividends.size-1).to_vector(:scale)
      regression = Statsample::Regression.simple(x_vector, y_vector)
      @dividend_regression = regression.y(@dividends.size)
    end
  end

  def calculate_average_dividend
    @average_dividend = @dividends.inject(:+) / @dividends.size unless @dividends.empty?
  end

  private

  def graphite_log key, value
    @graphite.push_to_graphite {|g| g.puts "#{key} #{value} #{@graphite.time_now}"}
  end

  def_delegators :instance, *Warehouse.instance_methods(false)

end
