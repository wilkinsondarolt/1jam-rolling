module Buttons
  class RollDice < Button
    attr_reader :dice

    def initialize(x:, y:, h:, w:, dice:)
      super(x: x, y: y, h: h, w: w)
      @dice = dice
    end

    def render(args)
      sprite = "sprites/d#{dice}_1.png" if mouse_over?(args)
      sprite ||= "sprites/d#{dice}_2.png"

      Sprite::Static.render(
        x: x,
        y: y,
        w: w,
        h: h,
        path: sprite
      )
    end

    def click(args)
      args.state.game.round.roll_dice(dice)
    end

    def visible?(_args)
      true
    end

    def collision_box
      {
        x: x + 24,
        y: y + 78,
        h: 127,
        w: 130
      }
    end

    private

    def mouse_over?(args)
      args.inputs.mouse.position.intersect_rect?(collision_box.rect)
    end
  end
end
