class Simulation
  def self.run config
    exchange = Exchange.new config
    evolution = Evolution.new exchange
    # zero = Zero.new exchange
    # reinforcement = Reinforcement.new exchange

    config['simulation_runs'].times do
      exchange.run
      evolution.optimise
      # zero.optimise
      # reinforcement.optimise
    end
  end
end
