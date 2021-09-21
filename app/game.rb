class Game
  attr_reader :credits, :round

  STARTING_CREDITS = 200

  def initialize
    @credits = 0
    @round = Round.new
  end

  def start
    @credits = STARTING_CREDITS
  end

  def start_round
    @credits -= bet
    round.start
  end

  def finish_round
    round.finish

    @credits += round.payout
  end

  def bet
    50
  end

  def finished?
    credits.zero?
  end
end
