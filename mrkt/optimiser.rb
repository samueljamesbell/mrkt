require 'mrkt/trader'
require 'mrkt/utils/string_patch'

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

  def Optimiser.log_performance
    @optimisers.each {|optimiser| Warehouse.log_optimiser_performance(optimiser)}
  end

  def initialize
    @population = []

    algorithm = CONFIG['algorithms'][self.class.to_s.snake_case]

    @population = algorithm['number_of_traders'].times.map do
      strategy = algorithm['strategy'].clone
      Trader.new(strategy.each {|k, v| strategy[k] = rand if v == 'rand'}, self.class)
    end
  end

  def optimise
    # No action by default
  end

  def performance
    @population.inject(0) {|sum, trader| sum + trader.performance} / @population.size
  end

  Dir[File.dirname(__FILE__) + '/optimisers/*.rb'].each {|file| require file}
end
