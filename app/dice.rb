class Dice
  attr_reader :faces_count, :enabled

  def initialize(faces_count)
    @faces_count = faces_count
    enable
  end

  def roll
    [*1..faces_count].sample
  end

  def enable
    @enabled = true
  end

  def disable
    @enabled = false
  end

  def render(x, y)
    {
      x: x,
      y: y,
      text: "d#{faces_count}"
    }
  end
end
