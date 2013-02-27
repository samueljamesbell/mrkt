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

    algorithm = CONFIG['algorithms'][snake_case(self.class.to_s)]

    @population = algorithm['number_of_traders'].times.map do
      strategy = algorithm['strategy'].clone
      Trader.new(strategy.each {|k, v| strategy[k] = rand if v == 'rand'}, self.class)
    end
  end

  def optimise
    # No action by default
  end

  private
  
  # Taken from Merb support library - http://rubygems.org/gems/extlib
  def snake_case(string)
    return downcase if string.match(/\A[A-Z]+\z/)
    string.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').gsub(/([a-z])([A-Z])/, '\1_\2').downcase
  end

  Dir[File.dirname(__FILE__) + '/optimisers/*.rb'].each {|file| require file}
end
