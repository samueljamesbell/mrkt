class Offer
    attr_reader :trader, :price, :quantity, :timestamp

    def initialize(trader, price, quantity)
        @trader = trader
        @price = price
        @quantity = quantity
        @timestamp = Time.now
    end

    def complete(price)
        @trader.budget -= price * quantity
        @trader.asset += quantity
    end
end
