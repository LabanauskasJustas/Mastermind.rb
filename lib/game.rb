# lib/game.rb
require_relative 'secret'
require_relative 'player'
require_relative 'cpu'

class Game
  MAX_TURNS = 12

  def initialize
    @human = Player.new
    @cpu   = CPU.new
    @history = [] # << store guesses + feedback
  end

  def start
    loop do
      begin
        system('clear')
      rescue StandardError
        nil
      end
      print_legend

      puts "\n=== MASTERMIND ==="
      puts '1) You guess the secret'
      puts '2) Computer guesses your secret'
      puts '3) Instructions'
      puts 'R) Restart'
      puts 'Q) Quit'
      print '> '

      choice = gets.chomp.strip.upcase

      case choice
      when '1' then return human_guesses
      when '2' then return computer_guesses
      when '3' then instructions_screen
      when 'R' then next # restart menu
      when 'Q' then exit
      else
        puts 'Invalid input.'
        sleep 1
      end
    end
  end

  def instructions_screen
    begin
      system('clear')
    rescue StandardError
      nil
    end

    puts "=== HOW TO PLAY MASTERMIND ===\n\n"

    puts 'Goal:'
    puts '- Break the secret code of 4 colors within 12 turns.'
    puts '- Colors may repeat.'
    puts
    puts 'Colors:'
    puts '  R = Red'
    puts '  G = Green'
    puts '  B = Blue'
    puts '  Y = Yellow'
    puts '  O = Orange'
    puts '  P = Purple'
    puts
    puts 'Example guess: RGBY'
    puts

    puts 'Feedback System:'
    puts '  Black Peg  = Correct color *in the correct position*'
    puts '  White Peg  = Correct color *in the wrong position*'
    puts
    puts 'Example:'
    puts '  Secret:   R G B Y'
    puts '  Guess:    R B P G'
    puts '  Feedback: 1 black, 2 white'
    puts '    - R is in the correct position (black)'
    puts '    - B and G exist but are in the wrong positions (white)'
    puts

    puts 'Press ENTER to return to the main menu...'
    gets
  end

  def human_guesses
    secret = @cpu.create_secret

    MAX_TURNS.times do |turn|
      puts "\nTurn #{turn + 1}/#{MAX_TURNS}"

      guess = @human.guess
      fb = secret.feedback(guess)

      @history << { guess: guess.pegs.join, fb: fb }

      print_board

      if fb[:black] == Secret::LENGTH
        puts "\n🎉 You WIN!"
        return
      end
    end

    puts "\n❌ You lost! Secret was #{secret.pegs.join}"
  end

  def computer_guesses
    secret = @human.choose_secret

    MAX_TURNS.times do |turn|
      puts "\nTurn #{turn + 1}/#{MAX_TURNS}"

      guess = @cpu.guess
      fb = secret.feedback(guess)

      @history << { guess: guess.pegs.join, fb: fb }

      print_board

      if fb[:black] == Secret::LENGTH
        puts "\n🤖 CPU WINS!"
        return
      end

      @cpu.learn(guess, fb)
    end

    puts "\n🤖 CPU failed! Secret was #{secret.pegs.join}"
  end

  def print_legend
    puts <<~LEGEND
      === COLORS ===
      R = Red
      G = Green
      B = Blue
      Y = Yellow
      O = Orange
      P = Purple
      ----------------
      Example guess: RGBY
    LEGEND
  end

  def print_board
    puts "\n=== BOARD ==="
    puts 'Guess | Black | White'
    puts '----------------------'

    @history.each do |row|
      guess  = row[:guess].ljust(5)
      black  = row[:fb][:black].to_s.ljust(5)
      white  = row[:fb][:white].to_s.ljust(5)

      puts "#{guess} | #{black} | #{white}"
    end

    puts '----------------------'
    puts '(Press Ctrl+C to quit, or return to menu after the round)'
  end
end
