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

    def match(offer, price)
                @trader.budget -= offer.remaining_quantity * price # -ve
                offer.trader.budget += @remaining_quantity * price #-ve

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
