class Offer
  attr_reader :trader, :price, :quantity, :timestamp
  attr_accessor :remaining_quantity

  def initialize(trader, price, quantity)
    @trader = trader
    @price = price
    @quantity = quantity
    @remaining_quantity = quantity
    @timestamp = Time.now
    @active = true
  end

  def transfer_assets_from(counterparty)
    assets_to_transfer = counterparty.assets.sample(@remaining_quantity)
    @trader.assets = @trader.assets + assets_to_transfer
    assets_to_transfer.each {|a| counterparty.assets.delete a}
  end

  def update_budgets(offer, price)

    @trader.budget -= offer.remaining_quantity * price
    offer.trader.budget += @remaining_quantity * price
  end

  def active?
    @active == true
  end

  def deactivate!
    Exchange.remove self
    @active = false
  end

  def to_s
    "{#{trader}: #{quantity} x $#{price}}"
  end
end
