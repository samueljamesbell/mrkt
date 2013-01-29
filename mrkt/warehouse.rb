require 'csv'

class Warehouse
  attr_reader :latest_transaction_time

  def initialize
    @prices = []
    @transaction_times = []
    @dividends = []
    @latest_transaction_time = 0
  end

  def log_transaction price
    @prices << price
    t = Time.now
    @transaction_times << t
    @latest_transaction_time = t
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
end
