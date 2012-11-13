require 'java'

module GraphicsTest
  include_package 'javax.swing'
  include_package 'java.awt'

  frame = JFrame.new("ShapesDemo2D");
  frame.setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE)
  #applet = ShapesDemo2D.new
  #frame.getContentPane.add "Center", applet
  #applet.init
  frame.pack
  #frame.setSize(Dimension.new(550,100));
  frame.setVisible(true);
end
