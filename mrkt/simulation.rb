class Simulation
  attr_reader :warehouse

  def initialize config
    @config = config
    @warehouse = Warehouse.new
    @visualiser = Visualiser.new @config
    @exchange = Exchange.new @config, @warehouse
  end

  def self.run
    evolution = Evolution.new @exchange
    # zero = Zero.new exchange
    # reinforcement = Reinforcement.new exchange

    @config['simulation_runs'].times do
      @visualiser.run exchange

      @exchange.run
      evolution.optimise
      # zero.optimise
      # reinforcement.optimise

      @visualiser.stop
      @exchange.reset
    end
  end
end
