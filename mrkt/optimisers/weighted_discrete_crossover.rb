require 'mrkt/optimisers/genetic_optimiser'

class WeightedDiscreteCrossover < GeneticOptimiser 

  def crossover mother, father, mother_performance = 1, father_performance = 1
    performance_sum = mother_performance + father_performance
    mother_weight = mother_performance / performance_sum

    child = {}

    random_keys = mother.keys.shuffle[0..(mother.keys.size * mother_weight)-1]
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
