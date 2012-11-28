class Equity

  attr_accessor :risk, :cash_risk

  def initialize risk, cash_risk
    @@risk = risk
    @@cash_risk = cash_risk
  end

end
