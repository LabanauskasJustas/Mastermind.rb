# frozen_string_literal: true

# lib/cpu.rb
require_relative 'secret'

class CPU
  def initialize
    @known_positions = Array.new(Secret::LENGTH)
    @known_colors = []
  end

  def create_secret
    Secret.random
  end

  def guess
    pegs = Array.new(Secret::LENGTH) do |i|
      @known_positions[i] || Secret::COLORS.sample
    end

    Secret.new(pegs)
  end

  def learn(guess, feedback)
    guess.pegs.each_with_index do |color, idx|
      if feedback[:black].positive? && color == guess.pegs[idx]
        @known_positions[idx] = color
      elsif feedback[:white].positive?
        @known_colors << color unless @known_colors.include?(color)
      end
    end
  end
end
