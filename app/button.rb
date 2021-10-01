class Button
  attr_reader :x, :y, :h, :w, :on_click, :mouse_over_sprite_path, :visible, :sprite_path, :collision_box

  def initialize(x:, y:, h: 50, w: 200, on_click: nil, visible: nil, sprite_path: nil, mouse_over_sprite_path: nil, collision_box: nil)
    @x = x
    @y = y
    @h = h
    @w = w
    @on_click = on_click
    @mouse_over_sprite_path = mouse_over_sprite_path
    @visible = visible
    @sprite_path = sprite_path
    @collision_box = collision_box || CollisionBox.new(x: x, y: y, h: h, w: w)
  end

  def click(args)
    return if on_click.nil?

    on_click.call(args.state)
  end

  def render(args)
    return unless sprite_path
    return unless visible?(args)

    sprite = mouse_over_sprite_path if mouse_over?(args)
    sprite ||= sprite_path

    Sprite::Static.render(
      x: x,
      y: y,
      w: w,
      h: h,
      path: sprite
    )
  end

  def visible?(args)
    return true if visible.nil?

    visible.call(args.state)
  end

  def mouse_over?(args)
    args.inputs.mouse.position.intersect_rect?(collision_box.rect)
  end
end
