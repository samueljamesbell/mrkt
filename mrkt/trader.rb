require 'bid'
require 'ask'
require 'equity'

class Trader
  attr_reader :price
  attr_accessor :budget, :assets, :strategy

  DEFAULT_STRATEGY = {'risk_aversion' => 0}

  def initialize exchange, strategy
    @exchange = exchange
    @budget = @exchange.config['initial_budget']
    @assets = []
    @strategy = DEFAULT_STRATEGY.merge @exchange.config['strategies'][strategy]
    @price = @exchange.config['starting_price']

    @exchange.config['initial_assets'].times { assets << Equity.new }

    @dividend_history = []

    @running = false
  end

  def run
    @running = true

    while @running
      v = value
      if v > @price
        q = quantity :bid
        offer = Bid.new self, utility(:bid, v, q) / q, q
        @latest_offer.deactivate! unless @latest_offer.nil?
        @exchange.accept offer
      elsif v < @price
        q = quantity :ask
        offer = Ask.new self, utility(:ask, v, q) / q, q
        @latest_offer.deactivate! unless @latest_offer.nil?
        @exchange.accept offer
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
    @dividend_history << amount
  end

  def to_s
    "#{self.object_id}"
  end

  private

  def value
    weights = 0
    sum = 0

    @strategy.each do |k, v|
      sum += (self.send(k) * v) unless k == 'risk_aversion'
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

    while utility(offer_type, v, q) < utility(offer_type, v, q + 1) && @price * q <= @budget
      q = q + 1
    end

    return q
  end

  def risk offer_type, quantity
    if offer_type == :bid
      risk = @exchange.equity_risk * quantity
    elsif offer_type == :ask
      risk = @exchange.cash_risk * (@budget + (quantity * @price))
    end
    
    return risk * @strategy['risk_aversion']
  end

  # Valuation calculations

  def noise
    sleep rand(@exchange.config['starting_price'] * @strategy['noise'])

    rand(@exchange.config['starting_price']) + @exchange.config['starting_price'] / 2
  end

  def price_regression
    prices = @exchange.warehouse.transactions
    if !prices.empty?
      x_vector = prices.keys.to_vector(:scale)
      y_vector = prices.values.to_vector(:scale)
      regression = Statsample::Regression.simple(x_vector, y_vector)
      puts @exchange.warehouse.latest_transaction_time
      print regression.y(@exchange.warehouse.latest_transaction_time + 10) #replace 10 with investment horizon?
      abort
    else
      return 0
    end
  end

  def average_dividend
    dividends = @exchange.warehouse.dividends
    if !dividends.empty?
      return dividends.inject(:+) / dividends.size
    else
      return 0
    end
  end

  def exchange_price
    @price
  end

end
