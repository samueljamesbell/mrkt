require 'csv'

class Warehouse
    def initialize
        @prices = []
        @transaction_times = []
        @dividends = []
    end

    def log_transaction price
        @prices << price
        @transaction_times << Time.now
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
