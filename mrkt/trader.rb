class Trader
    attr_reader :price
    attr_accessor :budget, :assets

    def initialize(exchange)
        exchange.register(self)

        @exchange = exchange
        @budget = 10000
        @assets = []
        100.times { assets << Equity.new }

        @running = false
    end

    def stop
        @running = false
    end

    def inform(price)
        @price = price
    end

    def to_s
        "#{self.object_id}"
    end
end
