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

    def match(offer, price)
        update_budgets offer, price

        assets_to_transfer = offer.trader.assets.sample(@remaining_quantity)
        @trader.assets = @trader.assets + assets_to_transfer
        assets_to_transfer.each {|a| offer.trader.assets.delete a}

        @remaining_quantity = offer.remaining_quantity
        offer.remaining_quantity = 0
    end

    def to_s
        "{#{trader}: #{quantity} x $#{price}}"
    end
end
