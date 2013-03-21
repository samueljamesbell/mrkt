require 'csv'
require_relative 'string_patch'
require_relative 'simple_singleton'

class Warehouse
  extend SimpleSingleton

  attr_reader :price_regression, :dividend_regression, :average_dividend

  def initialize
    @graphite = Graphite.new :host => '127.0.0.1', :port => 2003

    @round = 0

    @transactions = Hash.new { |h, k| h[k] = [] }
    @dividends = []

    @transaction_history = Array.new(CONFIG['simulation_runs']) { [] }
    @dividend_history = Array.new(CONFIG['simulation_runs']) { [] }
    @trader_history = Array.new(CONFIG['simulation_runs']) { Hash.new{ |h, k| h[k] = [] } }
    @optimiser_history = Array.new(CONFIG['simulation_runs']) { {} }

    @price_regression = 0
    @dividend_regression = 0
    @average_dividend = 0
  end

  def export
    puts "Exporting warehoused data to CSV"

    transactions_to_csv
    dividends_to_csv
    optimisers_to_csv
    traders_to_csv
  end

  def reset
    @transactions.clear
    @dividends.clear

    @round += 1
  end

  def log_transaction price
    @transactions[Time.now] << price
    @transaction_history[@round] << price

    graphite_log "mrkt.transactions.prices", price

    # Perform other calculations here
    Thread.new { calculate_price_regression }
    Thread.new { calculate_dividend_regression }
    Thread.new { calculate_average_dividend }
  end

  def log_dividend amount
    @dividends << amount
    @dividend_history[@round] << amount
  end

  def log_trader_performance trader
    @trader_history[@round][trader] << trader.performance
    graphite_log "mrkt.traders.#{trader.optimiser.to_s.snake_case}.#{trader.object_id}.performance", trader.performance
  end

  def log_optimiser_performance optimiser
    optimiser_name = optimiser.class.to_s.snake_case

    @optimiser_history[@round][optimiser_name] = optimiser.performance
    graphite_log "mrkt.optimisers.#{optimiser_name}.performance", optimiser.performance
  end

  def transactions_to_csv
    open_csv :transactions do |csv|
      csv << ['round', 'transactions']
      @transaction_history.each_with_index { |transactions, round| csv << [round, transactions.map { |t| t.round(2) }].flatten }
    end
  end

  def dividends_to_csv
    open_csv :dividends do |csv|
      csv << ['round', (1..CONFIG['number_of_periods']).to_a].flatten
      @dividend_history.each_with_index { |dividends, round| csv << [round, dividends].flatten }
    end
  end

  def traders_to_csv
    open_csv :traders do |csv|
      csv << ['round', 'optimiser', 'trader', 'performance']
      @trader_history.each_with_index do |traders, round|
        traders.each { |trader, performance| csv << [round + 1, trader.optimiser.to_s.snake_case, trader.object_id, performance].flatten }
      end
    end
  end

  def optimisers_to_csv
    open_csv :optimisers do |csv|
      csv << ['round', @optimiser_history[0].keys].flatten
      @optimiser_history.each_with_index { |performance, round| csv << [round, performance.values].flatten }
    end
  end

  def calculate_price_regression
    unless @transactions.empty?
      keys = @transaction.keys.inject([]) do |array, key|
        @transactions[key].each_index { |i| array << key.to_f + (i / 1000) }
      end

      x_vector = keys.to_vector(:scale)
      y_vector = @transactions.values.flatten.to_vector(:scale)

      regression = Statsample::Regression.simple(x_vector, y_vector)
      @price_regression = regression.y(Time.now + 10) #replace 10 with investment horizon?
    end
  end

  def calculate_dividend_regression
    unless @dividends.empty?
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

  def open_csv log_type
    yield CSV.open("data/#{log_type.to_s}-#{Time.now.to_i}.csv", 'w')
  end

end
