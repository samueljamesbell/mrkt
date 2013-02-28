require 'mrkt/optimisers/genetic_optimiser'

class MeanCrossover < GeneticOptimiser 

  def crossover mother, father
    result = mother.clone
    result.map {|k, v| mother[k] = (v + father[k]) / 2}

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
