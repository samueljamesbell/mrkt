require 'java'
require 'bundler/setup'

Bundler.require

#java_import 'javax.imageio.ImageIO'
#java_import 'javax.swing.ImageIcon'
#java_import 'javax.swing.JFrame'
#java_import 'javax.swing.JLabel'

#java_import 'java.awt.BorderLayout'
#java_import 'java.io.IOException'
#java_import 'java.net.URL'

require 'mrkt/simulation'

CONFIG = YAML.load_file 'config.yml'
Simulation.run

#puts "Exporting transaction prices to CSV"
#simulation.warehouse.transactions_to_csv

#puts "Dividends: #{simulation.warehouse.dividends}"

#puts "Generating Google Chart"
#urlString = Gchart.line_xy(:size => '540x540',
#                           :title => 'Price over time',
#                           :axis_with_labels => ['x', 'y'],
#                           :data => simulation.warehouse.transactions_for_chart)

#frame = JFrame.new
#label = JLabel.new(ImageIcon.new(ImageIO.read(URL.new(urlString))))
#frame.getContentPane.add(label, BorderLayout::CENTER)
#frame.pack
#frame.setVisible true

