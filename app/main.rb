require 'app/dice.rb'

def start_game(args)
  args.state.dices ||= build_dices
  args.state.round_state = :ongoing
  args.state.score = 0
end

def tick(args)
  start_game(args) if args.state.dices.nil?

  draw_guidelines(args)
  draw_score(args)
  render(args)
  handle_mouse_input(args)

  show_game_finished_message(args) if args.state.round_state != :ongoing

  finish_round(args) if round_ended?(args)
end

def build_dices
  dices = []
  x = 60
  [4, 6, 8, 10, 12, 20].each do |faces|
    dices << Dice.new(
      x: x,
      y: 30,
      faces_count: faces
    )

    x += 210
  end

  dices
end

def draw_guidelines(args)
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
end

def draw_score(args)
  args.outputs.labels << {
    x: args.grid.w / 2,
    y: (args.grid.h / 2) + 10,
    alignment_enum: 1,
    text: args.state.score
  }
end

def handle_mouse_input(args)
  return unless args.inputs.mouse.click

  if args.state.round_state == :ongoing
    clicked_dice = args.state.dices.find do |dice|
      args.inputs.mouse.click.intersect_rect?(dice.collision_box)
    end

    return unless clicked_dice

    args.state.score += clicked_dice.roll
  else
    start_game(args)
  end
end

def render(args)
  args.state.dices.each { |dice| dice.render(args) }
end

MAX_SCORE = 21

def round_ended?(args)
  args.state.score >= MAX_SCORE
end

def finish_round(args)
  args.state.round_state = :lost if args.state.score >= MAX_SCORE
  args.state.round_state = :won if args.state.score == MAX_SCORE
end

def show_game_finished_message(args)
  show_won_message(args) if args.state.round_state == :won
  show_lost_message(args) if args.state.round_state == :lost

  args.outputs.labels << {
    x: args.grid.w / 2,
    y: (args.grid.h / 2) - 80,
    alignment_enum: 1,
    text: 'Clique para jogar novamente.'
  }
end

def show_won_message(args)
  args.outputs.labels << {
    x: args.grid.w / 2,
    y: (args.grid.h / 2) - 50,
    alignment_enum: 1,
    text: 'Blackjack! Você venceu!'
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
