class Button
  attr_reader :x, :y, :h, :w

  def initialize(x:, y:, h:, w:)
    @x = x
    @y = y
    @h = h
    @w = w
  end

  def collision_box
    {
      x: x,
      y: y,
      h: h,
      w: w
    }
  end

  def click(_args)
  end

  def render(_args)
  end

  def visible?(_args)
    true
  end
end
