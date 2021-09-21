require 'app/button.rb'
require 'app/dice.rb'
require 'app/game.rb'
require 'app/round.rb'

def start_game(args)
  args.state.buttons ||= build_buttons(args)
  args.state.game = Game.new

  args.state.game.start
end

def tick(args)
  start_game(args) if args.state.game.nil?

  draw_debug_info(args)
  draw_round_score(args)
  draw_credits(args)
  draw_buttons(args)
  draw_current_payout(args)
  handle_mouse_input(args)

  check_round_completion(args)

  return if args.state.game.round.state == :ongoing

  if args.state.game.credits.zero?
    show_game_finished_message(args)
  else
    show_round_finished_message(args)
  end
end

def build_buttons(args)
  buttons = []
  buttons << Button.new(
    x: args.grid.w / 2 - 100,
    y: args.grid.h / 2 - 100,
    text: 'Parar',
    on_click: proc { |state| state.game.finish_round },
    visible: proc { |state| state.game.round.state == :ongoing }
  )

  x = 60
  [4, 6, 8, 10, 12, 20].each do |faces|
    buttons << Button.new(
      x: x,
      y: 30,
      h: 100,
      w: 100,
      text: "d#{faces}",
      on_click: proc { |state| state.game.round.roll_dice(faces) },
      visible: proc { true }
    )

    x += 210
  end

  buttons
end

def draw_debug_info(args)
  args.outputs.debug << {
    x: args.grid.w / 2,
    y: 0,
    x2: args.grid.w / 2,
    y2: args.grid.h
  }

  args.outputs.debug << {
    x: 0,
    y: args.grid.h / 2,
    x2: args.grid.w,
    y2: args.grid.h / 2
  }

  args.outputs.debug << {
    x: 0,
    y: args.grid.h - 50,
    alignment_enum: 0,
    text: "Round Status: #{args.state.game.round.state}"
  }
end

def draw_current_payout(args)
  args.outputs.labels << {
    x: 0,
    y: args.grid.h - 10,
    alignment_enum: 0,
    text: "Pagamento atual: #{args.state.game.round.payout}"
  }
end

def draw_round_score(args)
  args.outputs.labels << {
    x: args.grid.w / 2,
    y: (args.grid.h / 2) + 10,
    alignment_enum: 1,
    text: args.state.game.round.score
  }
end

def draw_credits(args)
  args.outputs.labels << {
    x: args.grid.w,
    y: args.grid.h - 10,
    alignment_enum: 2,
    text: "Créditos: #{args.state.game.credits}"
  }
end

def handle_mouse_input(args)
  return unless args.inputs.mouse.click

  if args.state.game.round.state == :ongoing
    args.state.buttons.each do |button|
      clicked = args.inputs.mouse.click.intersect_rect?(button.collision_box)

      next unless clicked

      button.click(args)
    end
  elsif args.state.game.finished?
    start_game(args)
  else
    args.state.game.start_round
  end
end

def draw_buttons(args)
  args.state.buttons.each { |button| button.render(args) }
end

def check_round_completion(args)
  args.state.game.finish_round if args.state.game.round.auto_finish?
end

def show_game_finished_message(args)
  args.outputs.labels << {
    x: args.grid.w / 2,
    y: (args.grid.h / 2) - 30,
    alignment_enum: 1,
    text: 'Você está sem créditos, que pena!'
  }

  args.outputs.labels << {
    x: args.grid.w / 2,
    y: (args.grid.h / 2) - 80,
    alignment_enum: 1,
    text: 'Clique para iniciar um novo jogo.'
  }
end

def show_round_finished_message(args)
  show_finished_message(args) if args.state.game.round.state == :finished
  show_blackjack_message(args) if args.state.game.round.state == :blackjack
  show_lost_message(args) if args.state.game.round.state == :lost

  args.outputs.labels << {
    x: args.grid.w / 2,
    y: (args.grid.h / 2) - 80,
    alignment_enum: 1,
    text: 'Clique para jogar'
  }
end

def show_finished_message(args)
  args.outputs.labels << {
    x: args.grid.w / 2,
    y: (args.grid.h / 2) - 50,
    alignment_enum: 1,
    text: "Você ganhou #{args.state.game.round.payout} créditos!"
  }
end

def show_blackjack_message(args)
  args.outputs.labels << {
    x: args.grid.w / 2,
    y: (args.grid.h / 2) - 50,
    alignment_enum: 1,
    text: "Blackjack! Você ganhou #{args.state.game.round.payout} créditos!"
  }
end

def show_lost_message(args)
  args.outputs.labels << {
    x: args.grid.w / 2,
    y: (args.grid.h / 2) - 50,
    alignment_enum: 1,
    text: 'Oops, passou de 21. Você perdeu.'
  }
end
