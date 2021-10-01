class Game
  attr_reader :credits, :round, :rounds

  STARTING_CREDITS = 200

  def initialize
    start
  end

  def start
    @credits = STARTING_CREDITS
    @round = Round.new
    @rounds = 0
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
    (50 * difficulty_multiplier).to_i
  end

  def payout
    (bet * round.payout_rate).to_i
  end

  def finished?
    return false unless round.finished?

    credits < bet
  end

  private

  ROUNDS_TO_INCREATE_DIFFICULTY = 10
  INCREASE_BET_PERCENTAGE = 1

  def difficulty_multiplier
    difficulty_level = (rounds / ROUNDS_TO_INCREATE_DIFFICULTY).to_i
    additional_difficulty = difficulty_level * INCREASE_BET_PERCENTAGE

    1 + additional_difficulty
  end
end
