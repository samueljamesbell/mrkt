java_import 'java.util.PriorityQueue'

class Exchange
    def initialize
        @bids = PriorityQueue.new
        @asks = PriorityQueue.new

        @traders = []
    end

    def register(trader)
        @traders << trader
    end

    def accept(offer)
        if offer.instance_of? Bid
            @bids.add offer
        elsif offer.instance_of? Ask
            @asks.add(offer)
        end

        clear

        puts "BIDS"
        puts @bids
        puts "ASKS"
        puts @asks
    end

    def clear
        ask = @asks.peek
        bid = @bids.peek
        unless bid.nil? || ask.nil?
        if bid >= ask
            @bids.remove bid
            @asks.remove ask

            if bid.timestamp <= ask.timestamp
                price = bid.price
            else
                price = ask.price
            end

            ask.complete price
            bid.complete price

            broadcast price
        end
        end
    end

    def broadcast(price)
        @traders.each {|trader| trader.inform price}
    end

end
