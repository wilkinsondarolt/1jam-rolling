class Button
  attr_reader :x, :y, :h, :w, :on_click, :visible, :sprite_path

  def initialize(x:, y:, h: 50, w: 200, on_click: nil, visible: nil, sprite_path: nil)
    @x = x
    @y = y
    @h = h
    @w = w
    @on_click = on_click
    @visible = visible
    @sprite_path = sprite_path
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
    return unless sprite_path
    return unless visible?(args)

    Sprite::Static.render(
      x: x,
      y: y,
      w: w,
      h: h,
      path: sprite_path
    )
  end

  def visible?(args)
    return true if visible.nil?

    visible.call(args.state)
  end
end
