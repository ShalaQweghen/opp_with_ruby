class Mastermind
  attr_reader :player, :board, :computer, :human

  def initialize
	start
	@player = Player.new(pick_name)
	@board = Board.new
	@computer = AI.new
	@counter = 1
	@human = true
	@prefer = nil
	pick_role
	decide
	pick_mode
  end

  def start
	puts "WELCOME TO THE MASTER MIND!".center(60)
	puts "\n============================================================="
	puts "Master Mind is a game in which you choose to be either"
	puts "the coder or the guesser. If you choose to be the coder,"
	puts "you will make a color code and the computer will try to"
	puts "crack it by the feedbacks you will give to it."
	puts "If you choose to be the guesser, the computer will make"
	puts "a color code and you will try to crack it by the feedbacks it"
	puts "will give to you. Good luck and have fun!"
	puts "============================================================="
  end

  def pick_name
	puts "\nPlease state your name:"
	name = gets.chomp
  end

  def pick_role
	puts "\nWould you, #{@player.name}, like to be the guesser or the coder?"
	puts "Type either 'C' for Coder or 'G' for Guesser."
	@prefer = gets.chomp.downcase
	unless ["g", "c"].include?(@prefer)
	  puts "\nInvalid input!"
	  pick_role
	end
  end

  def decide
	@human = false if @prefer == "c"
  end

  def pick_mode
	@human ? guesser_mode : coder_mode
  end

  def guesser_mode
	puts "\nGo ahead and make your first guess, #{@player.name}.\n"
	until over?
	  if lose?
		loss
		break
	  end
	  puts "\nPick your sequence of 4 colors, each color separated by a comma."
	  puts "Type 'R' for Red, 'G' for Green, 'B' for Blue," 
	  puts "'Y' for Yellow, 'P' for Purple, 'V' for Violet."
	  puts "For example: R, B, G, Y:"
	  pick = gets.chomp.upcase.chars.delete_if { |n| [" ", ","].include?(n) }
	  unless pick.all? {|n| ["R", "G", "B", "Y", "P", "V"].include?(n)}
		puts "\nInvalid pick. Please try again.".center(60) 
		next
	  end
	  @player.pick(pick)
	  human_proceed
	  human_victory if human_win?
	end
  end

  def coder_mode
	puts "\nWhat is your 4-color sequence for code?"
	puts "Pick your sequence of 4 colors, each color separated by a comma."
	puts "Type 'R' for Red, 'G' for Green, 'B' for Blue," 
	puts "'Y' for Yellow, 'P' for Purple, 'V' for Violet."
	puts "For example: R, B, G, Y:"
	code = gets.chomp.upcase.chars.delete_if { |n| [" ", ","].include?(n) }
	@player.code(code)
	until over?
	  if lose?
		loss
		break
	  end
	  puts "\nHere comes the computer's guess!"
	  puts
	  puts @computer.guesses.join(",").center(60)
	  puts "\nPlease give your feedback about the computer's guess."
	  puts "Type 'B' for a correct color in a correct position."
	  puts "Type 'W' for a correct color in an incorrect position."
	  puts "Type '?' for an incorrect guess."
	  puts "For example: B, ?, W, B"
	  feedback = gets.chomp.upcase.chars.delete_if { |n| [" ", ","].include?(n) }
	  @player.give_hint(feedback)
	  computer_proceed
	  computer_victory if computer_win?
	end
  end
 
  def computer_hint
	@computer.give_hint(@player.convert)
  end

  def human_hint
	guesses = @computer.guesses
	hints = @player.hints
	w = hints.select {|n| n == "W"}
	if w.size == 2
	  guesses[hints.rindex("W")], guesses[hints.index("W")] = guesses[hints.index("W")], guesses[hints.rindex("W")]
	elsif w.size > 2
	  hints.each do |n|
		guesses[hints.rindex("W")], guesses[hints.index("W")] = guesses[hints.index("W")], guesses[hints.rindex("W")] if n == "W"
	  end
	elsif w.size == 1
	  guesses[hints.index("?")] = guesses[hints.index("W")] if hints.include?("?")
	  hints[hints.index("?")], hints[hints.index("W")] = "W", "?"
	end
	hints.each_with_index { |n, i| guesses[i] = rand(6) if n == "?" }
  end

  def board_change
	@board.k_line = @computer.hints
  end

  def human_proceed
	unless human_win?
	  @counter += 1
	  computer_hint
	  board_change
	  @board.set(@player.choice)
	  @board.whole
	  puts
	  puts @board.all
	end
  end

  def computer_proceed
	@counter += 1
	unless computer_win?
	  human_hint
	  @computer.convert(@computer.guesses)
	end
  end

  def human_win?
	true if @player.converted_pick == @computer.code
  end

  def computer_win?
	true if @computer.guesses == @player.human_code
  end

  def lose?
	true if @counter > 12
  end
  
  def over?
	human_win? || computer_win?
  end

  def human_victory
  	puts
	puts "CONGRATULATIONS!!!".center(60) 
	puts "YOU HAVE CRACKED THE CODE IN #{@counter} TURNS!!!".center(60)
  end

  def computer_victory
	puts
	puts @computer.guesses.join(",").center(60)
	puts
	puts "COMPUTER HAS CRACKED YOUR CODE IN #{@counter} TURNS!!!".center(60)
  end

  def loss
	puts "Unfortunately, the code hasn't been able to be cracked!"
  end
end

class Board
  attr_accessor :c_line, :k_line, :all

  def initialize
	@c_line = []
	@k_line = []
	@all = []
	@line = []
  end

  def set(array)
	@line = []
	@line << "#{k_line[0]} #{k_line[1]} | #{array[0]} #{array[1]} #{array[2]} #{array[3]} | #{k_line[2]} #{k_line[3]}"
  end

  def whole
	@all << @line
  end
end

class Player
  attr_reader :choice, :human_code, :hints, :name, :converted_pick

  def initialize(name)
	@name = name
	@choice = []
	@human_code = []
	@hints = []
  end

  def pick(array)
	@choice = []
	@choice = array
  end

  def convert
	@converted_pick = @choice.map do |n|
	  case n
	  when 'R' then 0
	  when 'G' then 1
	  when 'B' then 2
	  when 'Y' then 3
	  when 'P' then 4
	  when 'V' then 5
	  end
	end
  end

  def code(array)
	@human_code = array
  end

  def give_hint(array)
	@hints = array
  end
end

class AI
  attr_reader :code, :hints, :guesses

  def initialize
	@code = [] << rand(6) << rand(6) << rand(6) << rand(6)
	@hints = ["?", "?", "?", "?"]
	@guesses = [] << rand(6) << rand(6) << rand(6) << rand(6)
	convert(@guesses)
  end

  def convert(array)
	array.map! do |n|
	  case n
	  when 0 then 'R'
	  when 1 then 'G'
	  when 2 then 'B'
	  when 3 then 'Y'
	  when 4 then 'P'
	  when 5 then 'V'
	  else n
	  end
	end
  end

  def give_hint(guess)
	@hints = ["?", "?", "?", "?"]
	case @code[0]
	when guess[0] then @hints[0] = "B"
	when guess[1] then @hints[1] = "W"
	when guess[2] then @hints[2] = "W"
	when guess[3] then @hints[3] = "W"
	end
	case @code[1]
	when guess[1] then @hints[1] = "B"
	when guess[0] then @hints[0] = "W"
	when guess[2] then @hints[2] = "W"
	when guess[3] then @hints[3] = "W"
	end
	case @code[2]
	when guess[2] then @hints[2] = "B"
	when guess[0] then @hints[0] = "W"
	when guess[1] then @hints[1] = "W"
	when guess[3] then @hints[3] = "W"
	end
	case @code[3]
	when guess[3] then @hints[3] = "B"
	when guess[0] then @hints[0] = "W"
	when guess[1] then @hints[1] = "W"
	when guess[2] then @hints[2] = "W"
	end
  end
end

game = Mastermind.new