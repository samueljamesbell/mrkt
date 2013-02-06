class Optimiser
  def initialize exchange
    @exchange = exchange
    @population = []

    algorithm = @exchange.config['algorithms'][self.class.to_s.downcase]

    @population = algorithm['number_of_traders'].times.map do
      strategy = algorithm['strategy'].each {|k, v| v = rand if v == 'rand'}
      Trader.new(@exchange, strategy, self.class)
    end
  end

  def optimise
    # No action by default
  end
end
