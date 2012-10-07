require 'java'
$LOAD_PATH << './mrkt'

require 'Exchange'
require 'Trader'
require 'Bid'

exchange = Exchange.new
trader = Trader.new exchange

bid = Bid.new trader, 100, 1
exchange.accept bid

