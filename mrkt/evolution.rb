class Evolution
  def initialize exchange
    @exchange = exchange
    @population = []

    @exchange.config['algorithms']['evolution']['number_of_traders'].times do
      strategy = exchange.config['algorithms']['evolution']['strategy'].each {|k, v| v = rand}
      @population << Trader.new(@exchange, strategy)
    end
  end

  def optimise
    parents = best(50).combination(2).shuffle[0..(@population.size / 4)-1]
    strategies = parents.map {|p| Trader.new(mutate(crossover(p[0], p[1])))}
    strategies.each {|s| spawn_trader s}
    worst(25).each {|t| kill t}
  end

  def best percentage
    @population.sort{|x, y| y.performance <=> x.performance}[0..(@population.size / (100 / percentage))-1]
  end

  def worst percentage
    @population.sort{|x, y| x.performance <=> y.performance}[0..(@population.size / (100 / percentage))-1]
  end

  def crossover mother, father
    child = {}

    random_keys = mother.keys.shuffle[0..(mother.keys.size/2)-1]
    random_keys.each {|k| child[k] = mother[k]}
    (father.keys - random_keys).each {|k| child[k] = father[k]}

    return child
  end

  def mutate strategy
    r = java.util.Random.new
    sum = 0
    strategy.each {|k, v| strategy[k] += r.nextGaussian; sum += strategy[k]}
    strategy.each {|k, v| strategy[k] /= sum}
  
    return strategy
  end

  def spawn_trader strategy
    trader = Trader.new @exchange, strategy
    @population << trader
  end

  def kill trader
    @exchange.deregister trader
    @population.delete trader
  end
end
