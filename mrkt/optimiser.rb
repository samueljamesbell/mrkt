require 'mrkt/trader'

class Optimiser

  class << self
    attr_accessor :subclasses, :optimisers
  end

  @subclasses = Set.new
  @optimisers = []

  def self.inherited(subclass)
    self.subclasses << subclass
  end

  def self.init
    self.optimisers = self.subclasses.map {|subclass| subclass.new}
  end

  def self.optimise
    self.optimisers.each {|optimiser| optimiser.optimise}
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
