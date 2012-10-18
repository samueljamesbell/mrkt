java_import 'java.util.PriorityQueue'

class Exchange
    attr_reader :warehouse

    def initialize
        @bids = PriorityQueue.new
        @asks = PriorityQueue.new

        @traders = []

        @semaphore = Mutex.new
        @warehouse = Warehouse.new
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

            bid.transfer_assets_from ask.trader
            bid.update_budgets ask, price

            if bid.remaining_quantity == ask.remaining_quantity
                bid.remaining_quantity = 0
                ask.remaining_quantity = 0
 
                @bids.remove bid
                @asks.remove ask
            elsif bid.remaining_quantity > ask.remaining_quantity
                bid.remaining_quantity -= ask.remaining_quantity
                ask.remaining_quantity = 0

                @asks.remove ask
                ask = @asks.peek
            else
                ask.remaining_quantity -= bid.remaining_quantity
                bid.remaining_quantity = 0

                @bids.remove bid
                bid = @bids.peek
            end

            #puts "CLEARED, $#{price}"
            broadcast price
        end
    end

    def broadcast(price)
        @traders.each {|trader| trader.inform price}
        @warehouse.log_transaction price
    end

end
