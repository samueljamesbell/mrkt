require 'java'
require 'rubygems'
require 'pp'
require 'bundler/setup'
require 'gchart'

java_import 'javax.imageio.ImageIO'
java_import 'javax.swing.ImageIcon'
java_import 'javax.swing.JFrame'
java_import 'javax.swing.JLabel'

java_import 'java.awt.BorderLayout'
java_import 'java.io.IOException'
java_import 'java.net.URL'

require 'visualiser'

$LOAD_PATH << './mrkt'
require 'warehouse'
require 'exchange'
require 'trader'
require 'bid'
require 'ask'
require 'equity'

config = YAML.load_file 'config.yml'

exchange = Exchange.new 'ZI', config
exchange.run

puts "Exporting transaction prices to CSV"
exchange.warehouse.transactions_to_csv

exchange.traders.each {|trader| puts "TRADER: #{trader.budget}, #{trader.assets.size}"}

puts "Dividends: #{exchange.warehouse.dividends}"

puts "Generating Google Chart"
urlString = Gchart.line_xy(:size => '540x540',
                           :title => 'Price over time',
                           :axis_with_labels => ['x', 'y'],
                           :data => exchange.warehouse.transactions_for_chart)

frame = JFrame.new
label = JLabel.new(ImageIcon.new(ImageIO.read(URL.new(urlString))))
frame.getContentPane.add(label, BorderLayout::CENTER)
frame.pack
frame.setVisible true

