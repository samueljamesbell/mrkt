require_relative 'utils/warehouse'
require_relative 'utils/visualiser'
require_relative 'exchange'
require_relative 'optimiser'

class Simulation

  def self.run
    Optimiser.init

    CONFIG['simulation_runs'].times do |i| puts "Running simulation #{i+1}"
      Exchange.run

      Optimiser.log_performance
      Optimiser.optimise

      puts Exchange.traders.sort_by! {|t| t.performance}

      Exchange.reset
      Warehouse.reset
    end

    Warehouse.export
  end

end
