require 'java'
require 'rubygems'
require 'bundler/setup'
require 'gchart'
require 'launchy'

$LOAD_PATH << './mrkt'
require 'Exchange'
require 'Trader'
require 'Bid'
require 'Ask'

exchange = Exchange.new
trader = Trader.new exchange

exchange.accept Bid.new trader, 100, 1
exchange.accept Bid.new trader, 200, 1
exchange.accept Ask.new trader, 100, 3
exchange.accept Bid.new trader, 300, 1

Launchy.open Gchart.line_xy(:size => '540x540',
                        :title => "Clearance prices over time",
                        :data => exchange.prices,
                        :theme => :thirty7signals)
