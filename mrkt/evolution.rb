class Evolution
  def initialize exchange
    @exchange = exchange
    @exchange.config['algorithms']['evolution']['number_of_traders'].times do
      strategy = exchange.config['algorithms']['evolution']['strategy'].each {|k, v| v = rand}
      trader = Trader.new strategy
      @exchange.register trader
      @population << trader
    end
  end

  def optimise
    parents = best(50).combination(2).shuffle[0..(@population.size / 4)-1]
    strategies = parents.map {|p| Trader.new(mutate(crossover(p[0], p[1])))}
    strategies.each {|s| spawn_trader s}
    worst(25).each {|t| kill t}
  end

  def best percentage
    @population.sort{|x, y| y.fitness <=> x.fitness}[0..(@population.size / (100 / percentage))-1]
  end

  def worst percentage
    @population.sort{|x, y| x.fitness <=> y.fitness}[0..(@population.size / (100 / percentage))-1]
  end

  def spawn_trader strategy
    trader = Trader.new strategy
    @exchange.register trader
    @population << trader
  end

  def kill trader
    @exchange.deregister trader
    @population.delete trader
  end
end
