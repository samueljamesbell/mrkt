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

    def complete(price, counterparty)
        @remaining_quantity = 0
        @trader.budget -= price * @quantity

        assets_to_transfer = counterparty.assets.sample(@quantity)
        @trader.assets = @trader.assets + assets_to_transfer
        assets_to_transfer.each {|a| counterparty.assets.delete a}
    end

    def to_s
        "{#{trader}: #{quantity} x $#{price}}"
    end
end
