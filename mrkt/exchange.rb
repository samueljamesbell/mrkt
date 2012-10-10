java_import 'java.util.PriorityQueue'

class Exchange
    attr_reader :prices, :clearance_times

    def initialize
        @bids = PriorityQueue.new
        @asks = PriorityQueue.new

        @traders = []

        @prices = []
        @clearance_times = []
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

        puts "BIDS: #{@bids}"
        puts "ASKS: #{@asks}"
        puts
    end

    def clear
        bid = @bids.peek
        ask = @asks.peek

        while !bid.nil? && !ask.nil?  && bid.price >= ask.price && (bid.remaining_quantity != 0 || ask.remaining_quantity != 0)
            price = ask.timestamp < bid.timestamp ? ask.price : bid.price

            if bid.remaining_quantity == ask.remaining_quantity
                bid.complete price
                ask.complete price

                @bids.remove bid
                @asks.remove ask
            elsif bid.remaining_quantity > ask.remaining_quantity
                bid.remaining_quantity -= ask.remaining_quantity
                ask.complete price

                @asks.remove ask
                ask = @asks.peek
            else
                ask.remaining_quantity -= bid.remaining_quantity
                bid.complete price

                @bids.remove bid
                bid = @bids.peek
            end

            broadcast price
        end
    end

    def broadcast(price)
        @traders.each {|trader| trader.inform price}
        @prices << price
        @clearance_times << Time.now
    end

end
