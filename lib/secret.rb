# frozen_string_literal: true

class Secret
  COLORS = %w[R G B Y O P].freeze
  LENGTH = 4

  attr_reader :pegs

  def initialize(pegs)
    @pegs = pegs
  end

  def self.random
    new(Array.new(LENGTH) { COLORS.sample })
  end

  def feedback(guess)
    guess_pegs = guess.pegs

    exact = 0
    color_matches = 0

    secret_count = Hash.new(0)
    guess_count  = Hash.new(0)

    pegs.each_with_index do |color, i|
      if guess_pegs[i] == color
        exact += 1
      else
        secret_count[color] += 1
        guess_count[guess_pegs[i]] += 1
      end
    end

    guess_count.each do |color, qty|
      color_matches += [qty, secret_count[color]].min
    end

    { black: exact, white: color_matches }
  end
end
