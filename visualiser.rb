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

  def initialize config
    super 'CDA Queue Visualisation'

    @running = false

    setDefaultCloseOperation JFrame::EXIT_ON_CLOSE
    setSize 550, Toolkit.getDefaultToolkit.getScreenSize.height
    setVisible true if config['visualiser']
  end

  def run exchange
    @exchange = exchange
    @running = true

    Thread.new {
      while @running
        repaint
        sleep 0.2
      end
    }
  end

  def stop
    @running = false
  end

  def paint g
    @g = g
    @dimensions = getSize
    @font_metrics = @g.getFontMetrics

    @g.setRenderingHint RenderingHints::KEY_ANTIALIASING, RenderingHints::VALUE_ANTIALIAS_ON
    @g.clearRect 0, 0, @dimensions.width, @dimensions.height

    draw_axes
    draw_labels '<<< Bids  |  Asks >>>', 'Price'

    display_offers @exchange.bids.to_array.sort, @exchange.asks.to_array.sort
  end

  private

  def display_offers bids, asks
    center = @dimensions.width / 2
    x = center - 10
    y = PADDING


    bids.each do |bid|
      label_width = @font_metrics.stringWidth bid.price.to_s
      width = bid.remaining_quantity >= label_width + 4 ? bid.remaining_quantity : label_width + 4
      draw_rectangle x - width, y, width, bid.price.to_s
      y += RECTANGLE_HEIGHT + 20
    end

    x = center + 10
    y = PADDING

    asks.each do |ask|
      draw_rectangle x, y, ask.remaining_quantity, ask.price.to_s
      y += RECTANGLE_HEIGHT + 20
    end
  end

  def draw_axes
    @g.setStroke AXIS_STROKE
    @g.setPaint Color::lightGray
    @g.drawLine PADDING, PADDING, PADDING, @dimensions.height - PADDING
    @g.drawLine PADDING, @dimensions.height - PADDING, @dimensions.width - PADDING, @dimensions.height - PADDING
  end

  def draw_labels x_label, y_label
    x_label_width = @font_metrics.stringWidth x_label

    @g.setPaint Color::black
    @g.drawString x_label, (@dimensions.width / 2) - (x_label_width / 2), @dimensions.height - PADDING + 25
    @g.drawString y_label, PADDING - 35, @dimensions.height / 2
  end

  def draw_rectangle x, y, width, label
    label_width = @font_metrics.stringWidth label
    label_height = @font_metrics.getHeight

    width = width >= label_width + 4 ? width : label_width + 4

    rectangle = RoundRectangle2D::Double.new x, y, width, RECTANGLE_HEIGHT, 5, 5

    @g.setStroke STROKE
    @g.setPaint DARK_BLUE
    @g.draw rectangle

    @g.setPaint GradientPaint.new x, y, MID_BLUE, x, y + RECTANGLE_HEIGHT, DARK_BLUE
    @g.fill rectangle

    @g.setPaint Color::white
    @g.drawString label, ((width - label_width) / 2) + x, ((RECTANGLE_HEIGHT - label_height) / 2) + y + label_height
  end

end
