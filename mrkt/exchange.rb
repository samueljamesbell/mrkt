require_relative 'utils/simple_singleton'

java_import 'java.util.PriorityQueue'

class Exchange
  extend SimpleSingleton

  attr_reader :traders, :bids, :asks, :equity_risk, :cash_risk

  def initialize
    puts "Exchange initialised"
    puts "Starting price: #{CONFIG['starting_price']}"
    puts "Number of periods: #{CONFIG['number_of_periods']}"
    puts "Period length: #{CONFIG['period_length']} seconds"

    @equity_risk = CONFIG['equity_risk']
    @cash_risk = CONFIG['cash_risk']

    @bids = PriorityQueue.new
    @asks = PriorityQueue.new

    @traders = []

    @dividends = RandomWalk.generate(0..CONFIG['starting_price'], CONFIG['number_of_periods'], 5)
    @semaphore = Mutex.new
  end

  def run
    threads = []
    @traders.each {|trader| threads << Thread.new { trader.run }}

    CONFIG['number_of_periods'].times do
      sleep CONFIG['period_length']

      current_dividend = dividend
      @traders.each {|trader| trader.accept_dividend current_dividend}
    end

    traders.each {|trader| trader.stop}
    threads.each {|thread| thread.join}
  end

  def dividend
    amount = @dividends.delete_at 0
    Warehouse.log_dividend amount

    amount
  end

  def register trader
    @traders << trader
  end

  def deregister trader
    @traders.delete trader
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

  def remove offer
    @semaphore.synchronize do
      if offer.instance_of? Bid
        @bids.remove offer
      elsif offer.instance_of? Ask
        @asks.remove offer
      end
    end
  end

  def clear
    bid = @bids.peek
    ask = @asks.peek

    while bid && ask && bid.price >= ask.price && (bid.remaining_quantity != 0 || ask.remaining_quantity != 0)
      if !bid.active?
        @bids.remove bid
        bid = @bids.peek
      elsif !ask.active?
        @asks.remove ask
        ask = @asks.peek
      else
        price = ask.timestamp < bid.timestamp ? ask.price : bid.price

        bid.transfer_assets_from ask.trader
        bid.update_budgets ask, price

        Warehouse.log_trader_performance bid.trader
        Warehouse.log_trader_performance ask.trader

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

        broadcast price
      end
    end
  end

  def broadcast price
    @traders.each {|trader| trader.inform price}
    Warehouse.log_transaction price
  end

  def reset
    @bids.clear
    @asks.clear
    @traders.each {|trader| trader.reset}
    @dividends = RandomWalk.generate(0..CONFIG['starting_price'], CONFIG['number_of_periods'], 5)
  end

end
