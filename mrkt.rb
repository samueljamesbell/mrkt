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

exchange = Exchange.new
trader = Trader.new exchange

exchange.accept Bid.new trader, 100, 1
exchange.accept Bid.new trader, 200, 1
exchange.accept Ask.new trader, 100, 3
exchange.accept Bid.new trader, 300, 1

urlString = "http://threetoone.files.wordpress.com/2012/09/mistory_venisonshot_04-177.jpg?w=682"

frame = JFrame.new
label = JLabel.new(ImageIcon.new(ImageIO.read(URL.new(urlString))))
frame.getContentPane.add(label, BorderLayout::CENTER)
frame.pack
frame.setVisible true
