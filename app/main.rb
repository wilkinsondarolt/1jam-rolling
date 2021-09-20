require 'app/dice.rb'

STARTING_CREDITS = 200

def start_game(args)
  args.state.credits ||= STARTING_CREDITS
  args.state.dices ||= build_dices
  args.state.round_state = :idle

  start_round(args)
end

def start_round(args)
  args.state.round_state = :ongoing
  args.state.round_score = 0
  args.state.credits -= 50
end

def tick(args)
  start_game(args) if args.state.dices.nil?

  draw_guidelines(args)
  draw_round_score(args)
  draw_credits(args)
  draw_dices(args)
  handle_mouse_input(args)

  show_game_finished_message(args) if args.state.round_state != :ongoing

  check_round_completion(args)
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

def draw_round_score(args)
  args.outputs.labels << {
    x: args.grid.w / 2,
    y: (args.grid.h / 2) + 10,
    alignment_enum: 1,
    text: args.state.round_score
  }
end

def draw_credits(args)
  args.outputs.labels << {
    x: args.grid.w / 2,
    y: args.grid.h - 10,
    alignment_enum: 1,
    text: "Créditos: #{args.state.credits}"
  }
end

def handle_mouse_input(args)
  return unless args.inputs.mouse.click

  if args.state.round_state == :ongoing
    clicked_dice = args.state.dices.find do |dice|
      args.inputs.mouse.click.intersect_rect?(dice.collision_box)
    end

    return unless clicked_dice

    args.state.round_score += clicked_dice.roll
  else
    start_round(args)
  end
end

def draw_dices(args)
  args.state.dices.each { |dice| dice.render(args) }
end

MAX_SCORE = 21

def check_round_completion(args)
  return unless args.state.round_state == :ongoing

  args.state.round_state = :lost if args.state.round_score >= MAX_SCORE
  args.state.round_state = :won if args.state.round_score == MAX_SCORE

  args.state.credits += round_payout(args) if args.state.round_state != :ongoing
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
    text: "Blackjack! Você ganhou #{round_payout(args)} créditos!"
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

def round_payout(args)
  case args.state.round_score
  when 0..17
    0
  when 18
    50
  when 19
    100
  when 20
    150
  when 21
    200
  else
    0
  end
end
