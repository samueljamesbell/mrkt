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
require 'Exchange'
require 'Trader'
require 'Bid'
require 'Ask'
require 'Equity'
require 'ZIC'

exchange = Exchange.new

traders = []
3.times {traders << ZIC.new(exchange)}
threads = []
traders.each {|t| threads << Thread.new { t.run }}

threads.each {|t| t.join}

start_time = exchange.clearance_times[0].to_i
simple_clearance_times = exchange.clearance_times.map {|t| t.to_i - start_time}

urlString = Gchart.line_xy(:size => '540x540',
                           :title => 'Price over time',
                           :axis_with_labels => ['x', 'y'],
                           :data => [simple_clearance_times, exchange.prices])

puts urlString

frame = JFrame.new
label = JLabel.new(ImageIcon.new(ImageIO.read(URL.new(urlString))))
frame.getContentPane.add(label, BorderLayout::CENTER)
frame.pack
frame.setVisible true
