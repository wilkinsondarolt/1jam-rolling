class Button
  attr_reader :x, :y, :h, :w, :text, :on_click, :visible

  def initialize(x:, y:, h: 50, w: 200, text:, on_click: nil, visible: nil)
    @x = x
    @y = y
    @h = h
    @w = w
    @text = text
    @on_click = on_click
    @visible = visible
  end

  def click(args)
    return if on_click.nil?

    on_click.call(args.state)
  end

  def collision_box
    {
      x: x,
      y: y,
      h: h,
      w: w
    }
  end

  def render(args)
    return unless visible?(args)

    args.outputs.borders << collision_box
    args.outputs.labels << {
      x: x + (w / 2),
      y: y + (h / 2) + 10,
      alignment_enum: 1,
      text: text
    }
  end

  def visible?(args)
    return true if visible.nil?

    visible.call(args.state)
  end
end
