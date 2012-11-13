class Visualiser < javax.swing.JFrame
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
  RECTANGLE_HEIGHT = 30

  def initialize exchange
    super 'CDA Queue Visualisation'

    @exchange = exchange
    @running = false

    setDefaultCloseOperation JFrame::EXIT_ON_CLOSE
    setExtendedState Frame::MAXIMIZED_BOTH
    setVisible true

    Thread.new { run }
  end

  def run 
    @running = true

    while @running
      repaint
      sleep 1
    end
  end

  def stop
    @running = false
  end

  def paint g
    @g = g
    @dimensions = getSize

    @g.setRenderingHint RenderingHints::KEY_ANTIALIASING, RenderingHints::VALUE_ANTIALIAS_ON
    @g.clearRect 0, 0, @dimensions.width, @dimensions.height

    drawAxes
    drawLabels '<<< Bids  |  Asks >>>', 'Price'

    @g.drawString 'a', rand(500), rand(500)

    puts @exchange.bids
    display_bids @exchange.bids.to_array.sort
  end

  private

  def display_bids bids
    x = PADDING
    y = PADDING
    bids.each {|bid| drawRectangle x, y, bid.quantity, bid.price.to_s}
    y += PADDING + RECTANGLE_HEIGHT
  end

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

  def drawRectangle x, y, width, label
    rectangle = RoundRectangle2D::Double.new x, y, width, RECTANGLE_HEIGHT, 5, 5

    @g.setStroke STROKE
    @g.setPaint DARK_BLUE
    @g.draw rectangle

    @g.setPaint GradientPaint.new x, y, LIGHT_BLUE, x, y + RECTANGLE_HEIGHT, MID_BLUE
    @g.fill rectangle

    fontMetrics = @g.getFontMetrics
    label_width = fontMetrics.stringWidth label
    label_height = fontMetrics.getHeight

    @g.setPaint Color::white
    @g.drawString label, ((width - label_width) / 2) + x, ((RECTANGLE_HEIGHT - label_height) / 2) + y + label_height
  end

end
