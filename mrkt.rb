require 'java'
require 'rubygems'
require 'bundler/setup'
require 'gchart'

java_import 'javax.imageio.ImageIO'
java_import 'javax.swing.ImageIcon'
java_import 'javax.swing.JFrame'
java_import 'javax.swing.JLabel'

java_import 'java.awt.BorderLayout'
java_import 'java.io.IOException'
java_import 'java.net.URL'

$LOAD_PATH << './mrkt'
require 'Warehouse'
require 'Exchange'
require 'Trader'
require 'Bid'
require 'Ask'
require 'Equity'
require 'ZIC'

exchange = Exchange.new

traders = []
100.times {traders << ZIC.new(exchange)}
threads = []
traders.each {|trader| threads << Thread.new { trader.run }}

sleep (120)

traders.each {|trader| trader.stop}
threads.each {|thread| thread.join}

exchange.warehouse.transactions_to_csv

traders.each {|trader| puts "#{trader.budget}, #{trader.assets.size}"}

urlString = Gchart.line_xy(:size => '540x540',
                           :title => 'Price over time',
                           :axis_with_labels => ['x', 'y'],
                           :data => exchange.warehouse.transactions_for_chart)

puts urlString

frame = JFrame.new
label = JLabel.new(ImageIcon.new(ImageIO.read(URL.new(urlString))))
frame.getContentPane.add(label, BorderLayout::CENTER)
frame.pack
frame.setVisible true
