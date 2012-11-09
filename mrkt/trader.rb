class Trader
    attr_reader :price
    attr_accessor :budget, :assets

    def initialize(exchange, start_price)
        @exchange = exchange
        @budget = 10000
        @assets = []

        @price = start_price

        100.times { assets << Equity.new }

        @dividend_history = []

        @running = false
    end

    def stop
        @running = false
    end

    def inform(price)
        @price = price
    end

    def accept_dividend(amount)
        @budget += amount * @assets.size
        @dividend_history << amount
    end

    def to_s
        "#{self.object_id}"
    end
end
