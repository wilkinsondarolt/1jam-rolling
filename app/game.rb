class Game
  attr_reader :credits, :round, :rounds

  STARTING_CREDITS = 200

  def initialize
    @credits = 0
    @rounds = 0
    @round = Round.new
  end

  def start
    @credits = STARTING_CREDITS
  end

  def start_round
    @rounds += 1
    @credits -= bet
    round.start
  end

  def finish_round
    round.finish

    @credits += payout
  end

  def bet
    50
  end

  def payout
    (bet * round.payout_rate).to_i
  end

  def finished?
    return false if round.finished?

    credits < bet
  end
end
