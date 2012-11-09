require 'trader'
require 'bid'
require 'ask'

class SimpleTrader < Trader
    def run
        @running = true

        while @running
            calculated_value = something
            if calculated_value > @price
                offer = Bid.new self, price, quantity
            elsif calculated_value < @price
                offer = Ask.new self, price, quantity
            end

            @exchange.accept offer
        end
    end
end

