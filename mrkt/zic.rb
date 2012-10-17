require 'Trader'
require 'Bid'
require 'Ask'

class ZIC < Trader

    def run
        100.times do
            if rand(2) == 0
                offer = Bid.new self, rand(200), rand(200)
            else
                offer = Ask.new self, rand(200), rand(200)
            end

            @exchange.accept offer

            sleep rand(5)
        end
    end

end
