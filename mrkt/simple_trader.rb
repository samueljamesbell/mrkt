require 'Trader'
require 'Bid'
require 'Ask'

class SimpleTrader < Trader
    def run
        @running = true

        while @running
            risk_aversion = 0.9
            utility = risk_aversion * @price

            if utility > @price
                offer = Bid.new self, utility, @budget / caculated_value
            elsif utility < @price
                offer = Ask.new self, utility, @assets.size
            end

            @exchange.accept offer
        end
    end
end

