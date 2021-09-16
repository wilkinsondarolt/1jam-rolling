require 'app/dice.rb'

def tick(args)
  draw_guidelines(args)

  x = 60
  [4, 6, 8, 10, 12, 20].each do |faces|
    args.outputs.borders << {
      x: x,
      y: 30,
      h: 100,
      w: 100
    }

    args.outputs.labels << {
      x: x + 50,
      y: 90,
      alignment_enum: 1,
      text: "d#{faces}"
    }

    x += 210
  end
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
