require 'app/buttons/button.rb'
require 'app/buttons/finish_round.rb'
require 'app/buttons/roll_dice.rb'
require 'app/dice.rb'
require 'app/game.rb'
require 'app/round.rb'
require 'app/collision_box.rb'
require 'app/sprite/static.rb'

def start_game(args)
  play_gameplay_music(args)

  args.state.buttons ||= build_buttons(args)
  args.state.game = Game.new

  args.state.game.start
end

def tick(args)
  start_game(args) if args.state.game.nil?

  draw_hud(args)
  draw_buttons(args)
  handle_mouse_input(args)

  check_round_completion(args)

  return if args.state.game.round.state == :ongoing

  if args.state.game.finished?
    show_game_finished_message(args)
  else
    show_round_finished_message(args)
  end
end

def build_buttons(args)
  buttons = []
  buttons << Buttons::FinishRound.new(
    x: 160,
    y: 135,
    h: 130,
    w: 135
  )

  y = 330
  [[4, 6, 8], [10, 12, 20]].each do |dices|
    x = 600
    dices.each do |dice|
      buttons << Buttons::RollDice.new(
        x: x,
        y: y,
        h: 230,
        w: 180,
        dice: dice
      )
      x += 180
    end
    y -= 230
  end

  buttons
end

def draw_hud(args)
  args.outputs.sprites << [
    Sprite::Static.render(
      x: 0,
      y: 0,
      w: args.grid.w,
      h: args.grid.h,
      path: 'sprites/background.png'
    ),
    Sprite::Static.render(
      x: 110,
      y: 280,
      w: 480,
      h: 350,
      path: 'sprites/overlay.png'
    ),
    Sprite::Static.render(
      x: 130,
      y: 80,
      w: 450,
      h: 220,
      path: 'sprites/stop.png'
    )
  ]

  args.outputs.labels << [
    {
      x: 225,
      y: 543,
      text: "Creditos: #{format_number(args.state.game.credits, 5)}",
      r: 4,
      g: 196,
      b: 217,
      size_enum: 4,
      font: 'fonts/LiquidCrystal-Normal.otf'
    },
    {
      x: 260,
      y: 464,
      text: "Pagamento: #{format_number(args.state.game.payout, 5)}",
      r: 4,
      g: 196,
      b: 217,
      size_enum: 4,
      font: 'fonts/LiquidCrystal-Normal.otf'
    },
    {
      x: 290,
      y: 388,
      text: "Aposta: #{format_number(args.state.game.bet, 5)}",
      r: 4,
      g: 196,
      b: 217,
      size_enum: 4,
      font: 'fonts/LiquidCrystal-Normal.otf'
    },
    {
      x: 410,
      y: 190,
      alignment_enum: 1,
      text: format_number(args.state.game.round.score, 2),
      r: 4,
      g: 196,
      b: 217,
      size_enum: 10,
      font: 'fonts/LiquidCrystal-Normal.otf'
    }
  ]
end

def handle_mouse_input(args)
  return unless args.inputs.mouse.click

  play_sound(args, 'sounds/sfx_click.ogg')

  if args.state.game.round.state == :ongoing
    args.state.buttons.each do |button|
      clicked = args.inputs.mouse.click.intersect_rect?(button.collision_box.rect)

      next unless clicked

      button.click(args)
    end
  elsif args.state.game.finished?
    args.state.game.start
  else
    args.state.game.start_round
  end
end

def draw_buttons(args)
  args.outputs.sprites << args.state.buttons.map { |button| button.render(args) }
end

def check_round_completion(args)
  return unless args.state.game.round.auto_finish?

  args.state.game.finish_round

  sound_file = case args.state.game.round.state
               when :blackjack
                 'sfx_won'
               when :lost
                 'sfx_lost'
               end

  play_sound(args, "sounds/#{sound_file}.ogg")
end

def show_game_finished_message(args)
  args.outputs.labels << [
    {
      x: args.grid.w / 2,
      y: (args.grid.h / 2) - 30,
      alignment_enum: 1,
      text: 'Voce esta sem creditos, que pena!',
      r: 4,
      g: 196,
      b: 217,
      size_enum: 4,
      font: 'fonts/LiquidCrystal-Normal.otf'
    },
    {
      x: args.grid.w / 2,
      y: (args.grid.h / 2) - 80,
      alignment_enum: 1,
      text: 'Clique para iniciar um novo jogo.',
      r: 4,
      g: 196,
      b: 217,
      size_enum: 4,
      font: 'fonts/LiquidCrystal-Normal.otf'
    }
  ]
end

def show_round_finished_message(args)
  show_finished_message(args) if args.state.game.round.state == :finished
  show_blackjack_message(args) if args.state.game.round.state == :blackjack
  show_lost_message(args) if args.state.game.round.state == :lost

  args.outputs.labels << {
    x: 420,
    y: 240,
    alignment_enum: 1,
    text: 'Clique para jogar',
    r: 4,
    g: 196,
    b: 217,
    size_enum: 5,
    font: 'fonts/LiquidCrystal-Normal.otf'
  }
end

def show_finished_message(args)
  args.outputs.labels << {
    x: args.grid.w / 2,
    y: 40,
    alignment_enum: 1,
    text: "Voce ganhou #{args.state.game.payout} creditos!",
    r: 4,
    g: 196,
    b: 217,
    size_enum: 4,
    font: 'fonts/LiquidCrystal-Normal.otf'
  }
end

def show_blackjack_message(args)
  args.outputs.labels << {
    x: args.grid.w / 2,
    y: 40,
    alignment_enum: 1,
    text: "Blackjack! Voce ganhou #{args.state.game.payout} creditos!",
    r: 4,
    g: 196,
    b: 217,
    size_enum: 4,
    font: 'fonts/LiquidCrystal-Normal.otf'
  }
end

def show_lost_message(args)
  args.outputs.labels << {
    x: args.grid.w / 2,
    y: 40,
    alignment_enum: 1,
    text: 'Oops, passou de 21. Voce perdeu.',
    r: 4,
    g: 196,
    b: 217,
    size_enum: 4,
    font: 'fonts/LiquidCrystal-Normal.otf'
  }
end

def format_number(value, size)
  value.to_s.rjust(size, '0')
end

def play_gameplay_music(args)
  args.audio[:music] ||= {
    input: 'sounds/music_gameplay.ogg',
    x: 0.0,
    y: 0.0,
    z: 0.0,
    paused: false,
    looping: true
  }
end

def play_sound(args, sound_file)
  args.gtk.queue_sound(sound_file)
end
