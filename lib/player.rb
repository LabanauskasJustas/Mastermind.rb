# frozen_string_literal: true

require_relative 'secret'

class Player
  def guess
    puts 'Enter your guess (e.g., RGBY):'
    Secret.new(read_colors)
  end

  def choose_secret
    puts 'Choose your secret code:'
    Secret.new(read_colors)
  end

  private

  def read_colors
    loop do
      print '> '
      input = gets.chomp.upcase.chars
      return input if input.length == Secret::LENGTH && input.all? { |c| Secret::COLORS.include?(c) }

      puts "Invalid. Use #{Secret::COLORS.join(', ')} and #{Secret::LENGTH} characters."
    end
  end
end
