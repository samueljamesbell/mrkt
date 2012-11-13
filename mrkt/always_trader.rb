require 'trader'
require 'bid'
require 'ask'

class AlwaysTrader < Trader
  def run
    @running = true

    while @running
      offer = Bid.new self, rand(100), rand(100)

      @exchange.accept offer

      sleep 3
    end

  end
end


