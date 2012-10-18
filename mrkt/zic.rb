require 'Trader'
require 'Bid'
require 'Ask'

class ZIC < Trader
    def run
        @running = true

        while @running
            if rand(200) == 0
                if rand(2) == 0
                    offer = Bid.new self, rand(200), rand(200)
                else
                    offer = Ask.new self, rand(200), rand(200)
                end

                @exchange.accept offer
            end

            sleep rand
        end
    end
end
