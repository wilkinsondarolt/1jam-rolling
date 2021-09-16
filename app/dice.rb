class Dice
  attr_reader :faces_count, :enabled, :x, :y

  def initialize(x:, y:, faces_count:)
    @x = x
    @y = y
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

  def collision_box
    {
      x: x,
      y: y,
      h: 100,
      w: 100
    }
  end

  def render(args)
    args.outputs.borders << {
      x: x,
      y: y,
      h: 100,
      w: 100
    }

    args.outputs.labels << {
      x: x + 50,
      y: y + 60,
      alignment_enum: 1,
      text: "d#{faces_count}"
    }
  end
end
