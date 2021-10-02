module Buttons
  class FinishRound < Button
    def click(args)
      args.gtk.queue_sound('sounds/sfx_won.ogg')

      args.state.game.finish_round
    end

    def visible?(args)
      args.state.game.round.state == :ongoing
    end
  end
end
