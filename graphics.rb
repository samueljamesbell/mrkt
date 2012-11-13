require 'java'


# 5bc0de 2f96b4 1f6377

class GraphicsTest < javax.swing.JApplet
  include_package 'javax.swing'
  include_package 'java.awt'
  include_package 'java.awt.event'
  include_package 'java.awt.geom'
  
  @@light_blue = Color.new 0x5bc0de
  @@mid_blue = Color.new 0x2f96b4
  @@dark_blue = Color.new 0x1f6377

  @@axis = BasicStroke.new 2
  @@stroke = BasicStroke.new 1.5

  @@padding = 40

  def self.main
    frame = JFrame.new 'CDA Queue Visualisation'
    frame.setDefaultCloseOperation JFrame::EXIT_ON_CLOSE
    applet = GraphicsTest.new
    frame.getContentPane.add "Center", applet
    applet.init
    frame.pack
    frame.setExtendedState Frame::MAXIMIZED_BOTH
    frame.setVisible true
  end

  def paint(g)
    @g = g
    @dimensions = getSize

    @g.setRenderingHint RenderingHints::KEY_ANTIALIASING, RenderingHints::VALUE_ANTIALIAS_ON     


    drawAxes
    drawLabels 'Hello', 'Price'

    light_to_dark = GradientPaint.new 10, 10, @@light_blue, 10, 40, @@mid_blue

    rectangle = RoundRectangle2D::Double.new 10, 10, 200, 40, 8, 8

    @g.setStroke @@stroke
    @g.setPaint @@dark_blue
    @g.draw(rectangle)
    @g.setPaint light_to_dark
    @g.fill(rectangle)
  end

  private

  def drawAxes
    @g.setStroke @@axis
    @g.setPaint Color::lightGray
    @g.drawLine @@padding, @@padding, @@padding, @dimensions.height - @@padding
    @g.drawLine @@padding, @dimensions.height - @@padding, @dimensions.width - @@padding, @dimensions.height - @@padding
  end

  def drawLabels x_label, y_label
    @g.setPaint Color::black
    @g.drawString x_label, @dimensions.width / 2, @dimensions.height - @@padding + 25
    @g.drawString y_label, @@padding - 35, @dimensions.height / 2
  end

end

GraphicsTest.main
