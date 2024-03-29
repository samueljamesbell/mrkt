require 'mrkt/optimiser'

class TripleCrossover < Optimiser

  def optimise
    parents = best(50).combination(3).to_a.shuffle[0..(@population.size / 4)-1]
    strategies = parents.map {|p| mutate(crossover(p[0].strategy, p[1].strategy, p[2].strategy))}
    strategies.each {|s| spawn_trader s}
    worst(25).each {|t| kill t}
  end

  def crossover a, b, c
    result = a.clone
    result.map {|k, v| result[k] = (v + b[k] + c[k]) / 3}

    result
  end

  def mutate strategy
    r = java.util.Random.new
    strategy.each {|k, v| strategy[k] += r.nextGaussian}
    max = strategy.values.max
    strategy.each {|k, v| strategy[k] /= max}
  
    return strategy
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
