require 'mrkt/trader'

class Optimiser

  class << self
    attr_accessor :subclasses, :optimisers
  end

  @subclasses = Set.new
  @optimisers = []

  def Optimiser.inherited(subclass)
    Optimiser.subclasses << subclass
  end

  def Optimiser.abstract
    Optimiser.subclasses.delete self
  end

  def Optimiser.init
    Optimiser.optimisers = Optimiser.subclasses.map {|subclass| subclass.new}
  end

  def Optimiser.optimise
    Optimiser.optimisers.each {|optimiser| optimiser.optimise}
  end

  def initialize
    @population = []

    algorithm = CONFIG['algorithms'][self.class.to_s.downcase]

    @population = algorithm['number_of_traders'].times.map do
      strategy = algorithm['strategy'].clone
      Trader.new(strategy.each {|k, v| strategy[k] = rand if v == 'rand'}, self.class)
    end
  end

  def optimise
    # No action by default
  end

  Dir[File.dirname(__FILE__) + '/optimisers/*.rb'].each {|file| require file}
end
