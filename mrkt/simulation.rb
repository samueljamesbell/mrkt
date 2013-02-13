require_relative 'utils/warehouse'
require_relative 'utils/visualiser'
require_relative 'exchange'
require_relative 'optimisers/evolution'
require_relative 'optimisers/zero'

class Simulation
  def initialize
    @visualiser = Visualiser.new
  end

  def run
    evolution = Evolution.new
    zero = Zero.new
    # reinforcement = Reinforcement.new exchange

    CONFIG['simulation_runs'].times do |i| puts "Running simulation #{i}"
      @visualiser.run

      Exchange.run
      evolution.optimise
      zero.optimise
      # reinforcement.optimise
      
      puts Exchange.traders.sort_by! {|t| t.performance}
      @visualiser.stop
      Exchange.reset
    end
  end
end
