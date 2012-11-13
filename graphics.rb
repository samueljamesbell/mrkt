require 'java'


# 5bc0de 2f96b4 1f6377

class GraphicsTest < javax.swing.JApplet
  include_package 'javax.swing'
  include_package 'java.awt'
  include_package 'java.awt.event'
  include_package 'java.awt.geom'
  
  LIGHT_BLUE = Color.new 0x5bc0de
  MID_BLUE = Color.new 0x2f96b4
  DARK_BLUE = Color.new 0x1f6377

  AXIS_STROKE = BasicStroke.new 2
  STROKE = BasicStroke.new 1.5

  PADDING = 40

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

    light_to_dark = GradientPaint.new 10, 10, LIGHT_BLUE, 10, 40, MID_BLUE

    rectangle = RoundRectangle2D::Double.new 10, 10, 200, 40, 8, 8

    @g.setStroke STROKE
    @g.setPaint DARK_BLUE
    @g.draw(rectangle)
    @g.setPaint light_to_dark
    @g.fill(rectangle)
  end

  private

  def drawAxes
    @g.setStroke AXIS_STROKE
    @g.setPaint Color::lightGray
    @g.drawLine PADDING, PADDING, PADDING, @dimensions.height - PADDING
    @g.drawLine PADDING, @dimensions.height - PADDING, @dimensions.width - PADDING, @dimensions.height - PADDING
  end

  def drawLabels x_label, y_label
    @g.setPaint Color::black
    @g.drawString x_label, @dimensions.width / 2, @dimensions.height - PADDING + 25
    @g.drawString y_label, PADDING - 35, @dimensions.height / 2
  end

end

GraphicsTest.main
