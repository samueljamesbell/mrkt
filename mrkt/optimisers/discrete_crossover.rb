require 'mrkt/optimisers/genetic_optimiser'

class DiscreteCrossover < GeneticOptimiser 

  def crossover mother, father, *weights
    child = {}

    random_keys = mother.keys.shuffle[0..(mother.keys.size/2)-1]
    random_keys.each {|k| child[k] = mother[k]}
    (father.keys - random_keys).each {|k| child[k] = father[k]}

    return child
  end

  def mutate strategy
    r = java.util.Random.new
    strategy.each {|k, v| strategy[k] += r.nextGaussian}
    max = strategy.values.max
    strategy.each {|k, v| strategy[k] /= max}
  
    return strategy
  end

end
