# frozen_string_literal: true

class GameRules
  COLORS = {
    1 => 'Empty',
    2 => 'Red',
    3 => 'Blue',
    4 => 'Yellow',
    5 => 'Orange',
    6 => 'Green',
    7 => 'Purple'
  }.freeze
  require 'set'

  def guess_to_color(nums, hsh) # converts the player's guesses from integers to colors
    guess = []
    nums.each { |n| guess.push(hsh[n]) }
    guess
  end

  def guess_v_actual(guess, actual) # x = correct position o = correct color, wrong position, - = incorrect
    hint = []
    a = actual
    g = guess
    throwaway_a = []
    throwaway_g = []
    a.each_with_index do |v, i| # checks color in same position
      if v == g[i]

        hint << 'x'
      elsif v != g[i]
        throwaway_a << v
        throwaway_g << g[i]
      end
    end
    throwaway_g.each do |j| # checks color in different position
      if throwaway_a.include?(j)
        hint << 'o'
        throwaway_a.delete(j)
      end
    end
    hint << '-' while hint.length < 4
    hint
  end
end

class Game < GameRules
  def game_start
    puts "\nWelcome to Mastermind! Would you like to decypher the code, or would you like to test the computer's powers of deduction?"
    puts "\nTo guess the computer's code, type 'codebreaker'."
    puts "\nTo create your own code, type 'codemaster'."
    decision = gets.chomp
    stop = false
    while stop == false
      if decision == 'codebreaker'
        puts "\nCode Breaker it is! You have 12 attempts to guess the code that the computer chose."
        puts "\nx = correct guess and correct position.\no = correct guess but incorrect position."
        stop = true
        player_breaker
      elsif decision == 'codemaster'
        puts "\nAhh the Code Master. The computer will have 12 tries to guess your code. Choose carefully."
        stop = true
        player_master
      else
        puts "\nSorry, I didn't get that. Please type 'codebreaker' or 'codemaster'"
        decision = gets.chomp
      end
    end
  end

  def new_game
    puts "Play again? type 'y' for yes"
    x = gets.chomp
    x == 'y' ? game_start : (puts "Thanks for playing, see ya later!")
  end

  def next_guess
    proceed = ''
    until proceed == 'next'
      puts "\nThat ain't it. Type 'next' to see the computer's next attempt."
      proceed = gets.chomp.downcase
    end
  end
      

  def random_code(hsh, n) # random code to decypher
    hidden_code = []
    n.times do
      hidden_code << hsh[hsh.keys.sample]
    end
    hidden_code
  end

  def round_play(nums)
    if nums == %w[x x x x]
      true
    elsif false
    end
  end

  def computer_logic(g, arr, c)
    next_guess = []
    arr[-1].each do |i|
      if i == 'x' || i == 'o'
        next_guess << g.sample
      else
        next_guess << random_code(c, (4 - next_guess.length))
      end 
      return next_guess.shuffle
    end
  end

  def display_guess(guess)
    guess.each_slice(2) do |a, b|
      puts "#{a}, #{b}"
    end
  end
end

class Player < Game
  def initialize(name)
    @name = name
  end

  def player_guess # checks for valid input
    puts "\nType 4 numbers that correspond with their matching colors."
    puts "Press 'c' to see the colour options."
    nums = gets.chomp

    if nums == 'c'
      pp COLORS
      puts "\nType the numbers that match their colors."
      nums = gets.chomp
    end

    nums = nums.split('').map(&:to_i)

    while nums.any? { |x| x < 1 || x > 7 }
      puts "\nInvalid input, please try again."
      nums = gets.chomp.split('').map(&:to_i)
    end

    until nums.length == 4
      puts "\nInvalid input, please try again."
      nums = gets.chomp.split('').map(&:to_i)
    end

    nums
  end

  def player_breaker
    puts "\nThe computer has chosen its 4-color code! You have 12 attempts."
    cypher = random_code(COLORS, 4)
    attempts = 12
    gss = guess_to_color(player_guess, COLORS)
    guesses = []
    win = false

    while win == false
      guesses << gss
      guesses << guess_v_actual(gss, cypher)
      if attempts == 0
        puts "You're out of guesses. YOU LOSE! the correct code was #{cypher}."
        win == true
        new_game
    elsif gss == cypher
        puts "\nYou did it in #{13 - attempts} guesses. YOU WIN!"
        win = true
        new_game
      else
        attempts -= 1
        display_guess(guesses)
        puts "\nSorry, that's incorrect. you have #{attempts} remaining guesses. YOU LOSE!"
        gss = guess_to_color(player_guess, COLORS)
      end
   end
  end

  def player_master
    cypher = guess_to_color(player_guess, COLORS)
    puts "Your hidden code is #{cypher.join(', ')}, the computer is ready to start guessing!"
    computer_play(cypher)
    new_game
  end

  def computer_play(code)
    guesses = []
    cypher = code
    attempts = 12
    guess = random_code(COLORS, 4)
    win = false

      while win == false
        guesses << guess
        guesses << guess_v_actual(guess, cypher)
        display_guess(guesses)
        puts "\nThe Computer guesses: #{guess}"

        if attempts == 0
          puts "\nNice strategy. The computer is out of guesses, YOU WIN!"
          win = true
        elsif round_play(guess)
          puts "\nDon't feel bad. It's hard to beat a computer. YOU LOSE!"
          win = true
        else
          attempts -= 1
          puts "The computer has #{13 - attempts} remaining guesses."
          next_guess
          guess = computer_logic(guess, guesses, COLORS)
        end
      end

    new_game
  end

end


p = Player.new('Me')
p.game_start

# Existing methods and uses

# Class: GameRules
  # COLORS Constant
  # guess_to_color - converts the player selection from numbers to colors
  # guess_v_actual - compares player guess to code

# Class: Game
  # game_start - starts the program and gives the player option of breaker or master
  # new_game - gives the option of a new game once win/lose
  # next_guess - moves the game forward
  # random_code - generates code to decipher
  # display_guess - prints guesses + hints in a readable fashion
  # player_guess - checks player input for mistakes

# Class: Player
  # player_guess - Ensures valid input from player
  # player_breaker - Plays game as player trying to decipher
  # round_play - will put methods together and return correct or incorrect
  # player_breaker the player attempts to crack the code
