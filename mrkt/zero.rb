class Zero
  def initialize exchange
    @exchange = exchange
    @population = @exchange.config['algorithms']['zero']['number_of_traders'].times.map {|t| Trader.new @exchange, @exchange.config['algorithms']['zero']['strategy'], self.class}
  end

  def optimise
    # No optimisation required for zero-intelligence agents
  end
end
