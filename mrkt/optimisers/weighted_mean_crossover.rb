require 'mrkt/optimisers/genetic_optimiser'

class WeightedMeanCrossover < GeneticOptimiser 

  def crossover mother, father, mother_performance = 1, father_performance = 1
    performance_sum = mother_performance + father_performance
    mother_weight = mother_performance / performance_sum
    father_weight = father_performance / performance_sum

    result = mother.clone
    result.map {|k, v| mother[k] = (v * mother_weight) + (father[k] * father_weight)}

    result
  end

  def mutate strategy
    r = java.util.Random.new
    strategy.each {|k, v| strategy[k] += r.nextGaussian}
    max = strategy.values.max
    strategy.each {|k, v| strategy[k] /= max}
  
    return strategy
  end

end
