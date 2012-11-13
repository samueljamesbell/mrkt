require 'java'

java_import 'javax.swing.JFrame'
java_import 'java.awt.Graphics'

frame = JFrame.new("ShapesDemo2D");
frame.setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE)
#applet = ShapesDemo2D.new
#frame.getContentPane.add "Center", applet
#applet.init
frame.pack
#frame.setSize(Dimension.new(550,100));
frame.setVisible(true);
