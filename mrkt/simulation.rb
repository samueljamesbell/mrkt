class Simulation
  attr_reader :warehouse

  def initialize config
    @config = config
    @warehouse = Warehouse.new
  end

  def self.run
    exchange = Exchange.new @config, @warehouse
    evolution = Evolution.new exchange
    # zero = Zero.new exchange
    # reinforcement = Reinforcement.new exchange

    @config['simulation_runs'].times do
      exchange.run
      evolution.optimise
      # zero.optimise
      # reinforcement.optimise
    end
  end
end
