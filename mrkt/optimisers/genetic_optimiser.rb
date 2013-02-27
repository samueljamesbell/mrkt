require 'mrkt/optimiser'

class GeneticOptimiser < Optimiser
  abstract

  def optimise
    parents = best(50).combination(2).to_a.shuffle[0..(@population.size / 4)-1]
    strategies = parents.map {|p| mutate(crossover(p[0].strategy, p[1].strategy))}
    strategies.each {|s| spawn_trader s}
    worst(25).each {|t| kill t}
  end

  def best percentage
    @population.sort{|x, y| y.performance <=> x.performance}[0..(@population.size / (100 / percentage))-1]
  end

  def worst percentage
    @population.sort{|x, y| x.performance <=> y.performance}[0..(@population.size / (100 / percentage))-1]
  end

  def spawn_trader strategy
    trader = Trader.new strategy, self.class
    @population << trader
  end

  def kill trader
    Exchange.deregister trader
    @population.delete trader
  end

end
