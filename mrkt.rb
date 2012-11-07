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
require 'warehouse'
require 'exchange'
require 'trader'
require 'bid'
require 'ask'
require 'equity'
require 'zic_Trader'
require 'simple_Trader'

puts "Initialising an exchange with 3 ZIC traders"
exchange = Exchange.new ZicTrader, 3

puts "Running simulation with 4 periods of 30 seconds each"
exchange.run(4, 30)

puts "Exporting transaction prices to CSV"
exchange.warehouse.transactions_to_csv

exchange.traders.each {|trader| puts "#{trader.budget}, #{trader.assets.size}"}

puts "Dividends: #{exchange.warehouse.dividends}"

puts "Generating Google Chart"
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

