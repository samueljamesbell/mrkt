require_relative 'bid'
require_relative 'ask'
require_relative 'equity'

class Trader
  attr_reader :price, :optimiser
  attr_accessor :budget, :assets, :strategy

  DEFAULT_STRATEGY = {'risk_aversion' => 0}

  def initialize strategy, optimiser
    @strategy = DEFAULT_STRATEGY.merge strategy
    @optimiser = optimiser

    @budget = CONFIG['initial_budget']
    @assets = []
    CONFIG['initial_assets'].times { assets << Equity.new }

    @price = CONFIG['starting_price']
    @running = false

    Exchange.register self
  end

  def run
    @running = true

    while @running
      v = value

      if v > @price
        make_offer :bid, v
      elsif v < @price
        make_offer :ask, v
      end
    end
  end

  def stop
    @running = false
  end

  def inform(price)
    @price = price
  end

  def accept_dividend(amount)
    @budget += amount * @assets.size
  end

  def reset
    @budget = CONFIG['initial_budget']
    @assets = []
    CONFIG['initial_assets'].times { assets << Equity.new }
    
    @price = CONFIG['starting_price']
  end

  def performance
    @budget + assets.size * @price
  end

  def to_s
    "#{@optimiser}: #{performance.round(2)}"
  end

  private

  def make_offer offer_type, value
    quantity = quantity(offer_type)
    price = utility(:bid, value, quantity) / quantity

    offer_class = Kernel.const_get(offer_type.to_s.capitalize)
    offer = offer_class.new(self, price, quantity)

    unless price <= 0 || quantity <= 0
      @latest_offer.deactivate! unless @latest_offer.nil?
      Exchange.accept offer
      @latest_offer = offer
    end
  end

  def value
    weights = 0
    sum = 0

    @strategy.each do |k, v|
      sum += (self.send(k) * v) unless k == 'risk_aversion' || v == 0
      weights += v
    end
    
    return sum / weights
  end

  def utility offer_type, value, quantity
    u = (value * quantity) - risk(offer_type, quantity)
    return u
  end

  def quantity offer_type
    v = value
    q = 0

    while utility(offer_type, v, q) < utility(offer_type, v, q + 1) && utility(offer_type, v, q + 1) * q <= @budget
      q = q + 1
    end

    return q
  end

  def risk offer_type, quantity
    if offer_type == :bid
      risk = Exchange.equity_risk * quantity
    elsif offer_type == :ask
      risk = Exchange.cash_risk * (@budget + (quantity * @price))
    end
    
    return risk * @strategy['risk_aversion']
  end

  # Valuation components

  def exchange_price
    @price
  end

  def price_regression
    Warehouse.price_regression
  end

  def dividend_regression
    Warehouse.dividend_regression
  end

  def average_dividend
    Warehouse.average_dividend
  end

  def noise
    sleep rand(CONFIG['starting_price'] * @strategy['noise'])

    rand(CONFIG['starting_price']) + CONFIG['starting_price'] / 2
  end

end
