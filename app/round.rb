class Round
  attr_reader :score, :state

  MAX_SCORE = 21

  def initialize
    @score = 0
    @state = :idle
  end

  def start
    @score = 0
    @state = :ongoing
  end

  def finish
    @state = :finished
    @state = :blackjack if score == MAX_SCORE
    @state = :lost if score > MAX_SCORE
  end

  def roll_dice(faces)
    @score += Dice.roll(faces)
  end

  def auto_finish?
    return false if finished?

    score >= MAX_SCORE
  end

  POSSIBLE_PAYOUTS = {
    18 => 50,
    19 => 100,
    20 => 150,
    21 => 200
  }.freeze

  def payout
    POSSIBLE_PAYOUTS[score] || 0
  end

  private

  def finished?
    state != :ongoing
  end
end
