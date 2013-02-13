require 'mrkt/trader'

class Optimiser
  def initialize exchange
    @exchange = exchange
    @population = []

    algorithm = CONFIG['algorithms'][self.class.to_s.downcase]

    @population = algorithm['number_of_traders'].times.map do
      strategy = algorithm['strategy']
      Trader.new(@exchange, strategy.each {|k, v| strategy[k] = rand if v == 'rand'}, self.class)
    end
  end

  def optimise
    # No action by default
  end
end
