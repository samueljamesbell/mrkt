require_relative 'utils/warehouse'
require_relative 'utils/visualiser'
require_relative 'exchange'
require_relative 'optimisers/evolution'
require_relative 'optimisers/zero'

class Simulation

  def self.run
    evolution = Evolution.new
    zero = Zero.new
    # reinforcement = Reinforcement.new exchange

    CONFIG['simulation_runs'].times do |i| puts "Running simulation #{i}"
      Exchange.run
      evolution.optimise
      zero.optimise
      # reinforcement.optimise
      
      puts Exchange.traders.sort_by! {|t| t.performance}
      Exchange.reset
    end
  end

end
