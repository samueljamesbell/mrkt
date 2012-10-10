class Offer
    attr_reader :trader, :price, :quantity, :timestamp
    attr_accessor :remaining_quantity

    def initialize(trader, price, quantity)
        @trader = trader
        @price = price
        @quantity = quantity
        @remaining_quantity = quantity
        @timestamp = Time.now
    end

    def complete(price)
        @remaining_quantity = 0
        @trader.budget -= price * quantity
        @trader.asset += quantity
    end

    def to_s
        "{#{trader}: #{quantity} x $#{price}}"
    end
end
