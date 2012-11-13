java_import 'java.util.PriorityQueue'

class Exchange
    attr_reader :warehouse, :traders, :bids, :asks

    def initialize trader_class, number_of_traders, start_price
        puts "Initialising an exchange with #{number_of_traders} #{trader_class}s and a start price of #{start_price}"

        @bids = PriorityQueue.new
        @asks = PriorityQueue.new

        @traders = []
        number_of_traders.times {@traders << trader_class.new(self, start_price)}

        @last_dividend = 0

        @semaphore = Mutex.new
        @warehouse = Warehouse.new
    end

    def run number_of_periods, period_length
        puts "Running simulation with #{number_of_periods} periods of #{period_length} seconds each"
        
        visualiser = Visualiser.new self

        threads = []
        @traders.each {|trader| threads << Thread.new { trader.run }}

        number_of_periods.times do
            sleep period_length

            current_dividend = generate_dividend
            @traders.each {|trader| trader.accept_dividend current_dividend}
        end

        traders.each {|trader| trader.stop}
        threads.each {|thread| thread.join}

        visualiser.stop
    end

    def generate_dividend
        amount = rand(10) + 1
        @warehouse.log_dividend amount

        amount
    end

    # deprecated
    def register trader
        @traders << trader
    end

    def accept offer
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

    def broadcast price
        @traders.each {|trader| trader.inform price}
        @warehouse.log_transaction price
    end

end
