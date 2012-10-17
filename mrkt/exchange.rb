java_import 'java.util.PriorityQueue'

class Exchange
    attr_reader :prices, :clearance_times

    def initialize
        @bids = PriorityQueue.new
        @asks = PriorityQueue.new

        @traders = []

        @semaphore = Mutex.new

        @prices = []
        @clearance_times = []
    end

    def register(trader)
        @traders << trader
    end

    def accept(offer)
        @semaphore.synchronize do
            if offer.instance_of? Bid
                @bids.add offer
            elsif offer.instance_of? Ask
                @asks.add(offer)
            end

            clear
        end
    end

    def clear
        bid = @bids.peek
        ask = @asks.peek

        while !bid.nil? && !ask.nil?  && bid.price >= ask.price && (bid.remaining_quantity != 0 || ask.remaining_quantity != 0)
            price = ask.timestamp < bid.timestamp ? ask.price : bid.price

            if bid.remaining_quantity == ask.remaining_quantity
                bid.match ask, price
                ask.match bid, price
 
                @bids.remove bid
                @asks.remove ask
            elsif bid.remaining_quantity > ask.remaining_quantity
                bid.match ask, price

                @asks.remove ask
                ask = @asks.peek
            else
                ask.match bid, price

                @bids.remove bid
                bid = @bids.peek
            end

            #puts "CLEARED, $#{price}"
            broadcast price
        end
    end

    def broadcast(price)
        @traders.each {|trader| trader.inform price}
        @prices << price
        @clearance_times << Time.now
    end

end
