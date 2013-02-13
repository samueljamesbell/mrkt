require_relative 'utils/warehouse'
require_relative 'utils/visualiser'
require_relative 'exchange'
require_relative 'optimisers/evolution'
require_relative 'optimisers/zero'

class Simulation
  def initialize
    @visualiser = Visualiser.new
    @exchange = Exchange.new
  end

  def run
    evolution = Evolution.new @exchange
    zero = Zero.new @exchange
    # reinforcement = Reinforcement.new exchange

    CONFIG['simulation_runs'].times do |i| puts "Running simulation #{i}"
      @visualiser.run @exchange

      @exchange.run
      evolution.optimise
      zero.optimise
      # reinforcement.optimise
      
      puts @exchange.traders.sort_by! {|t| t.performance}
      @visualiser.stop
      @exchange.reset
    end
  end
end
