class Trader
    attr_reader :price
    attr_accessor :budget, :asset

    def initialize(exchange)
        exchange.register(self)
        @budget = 100
        @asset = 100
    end

    def inform(price)
        @price = price
    end

    def to_s
        "#{self.object_id}"
    end
end
