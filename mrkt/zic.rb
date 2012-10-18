require 'Trader'
require 'Bid'
require 'Ask'

class ZIC < Trader
    def run
        @running = true

        while @running
            if rand(200) == 0
                if rand(2) == 0
                    begin
                        price = rand(201)
                        quantity = rand(201)
                    end while price * quantity < @budget && @running
                    
                    offer = Bid.new self, price, quantity
                else
                    offer = Ask.new self, rand(200), rand(@assets.size + 1)
                end

                @exchange.accept offer
            end

            sleep rand
        end
    end
end
