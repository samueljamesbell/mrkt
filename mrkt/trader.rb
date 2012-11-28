require 'bid'
require 'ask'
require 'equity'

class Trader
  attr_reader :price
  attr_accessor :budget, :assets, :strategy

  DEFAULT_STRATEGY = {:risk_aversion => 0, :noise => 0, :price_regression => 0, :average_dividend => 0, :exchange_price => 1}

  def initialize exchange, start_price, strategy = {}
    @exchange = exchange
    @budget = 10000
    @assets = []
    @strategy = DEFAULT_STRATEGY.merge strategy

    @price = start_price

    100.times { assets << Equity.new(0.1, 0.02) }

    @dividend_history = []

    @running = false
  end

  def run
    @running = true

    while @running
      v = value
      if v > @price
        q = quantity :bid
        offer = Bid.new self, utility(:bid, v, q), q
      elsif v < @price
        q = quantity :ask
        offer = Ask.new self, utility(:ask, v, q), q
      end

      @exchange.accept offer
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

    sum = @strategy.each do |k, v|
      sum += (self.send(k) * v) unless k == :risk_aversion
      weights += v
    end

    return sum / weights
  end

  def utility offer_type, value, quantity
    (value * quantity) - risk(offer_type, quantity)
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

    return risk * @strategy[:risk_aversion]
  end

  # Valuation calculations
  
  def noise
    rand(@price) + @price / 2
  end

  def price_regression
    #exchange.warehouse.transactions
    1
  end

  def average_dividend
    @exchange.warehouse.dividends.inject(:+) / @exchange.warehouse.dividends.size
  end

  def exchange_price
    @price
  end

end
