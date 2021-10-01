class CollisionBox
  attr_reader :x, :y, :h, :w

  def initialize(x:, y:, h:, w:)
    @x = x
    @y = y
    @h = h
    @w = w
  end
end
