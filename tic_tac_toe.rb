class Game
  attr_reader :turns, :board, :players

  def initialize (player1, player2)
    @board = Board.new
	@players = Player.new(player1, player2)
	@turns = 0
	@toss = rand(2)
	opponents
	@board.set
	turn
  end

  def proceed
	board = @board.board
	board[@players.hor-1][@players.ver-1] = letter
	@board.set
	win? ? victory : turn
  end

  def over?
	win?
  end

  private

  def opponents
	puts "#{@players.player_1} vs #{@players.player_2}"
  end

  def current_player
	if @turns.odd?
	  @toss.zero? ? @players.player_1 : @players.player_2
	else
	  @toss.zero? ? @players.player_2 : @players.player_1
	end
  end

  def letter
	if @toss.zero?
	  @turns.odd? ? "X" : "O"
	else
	  @turns.odd? ? "O" : "X"
	end
  end

  def turn
	if @turns.zero?
	  puts @toss.zero? ? "It's #{@players.player_1}'s turn." : "Its's #{@players.player_2}'s turn."
	  @turns += 1
	else
	  @turns += 1
	  puts  "\nIt's #{current_player}'s turn."
	end
  end

  def win?
	board = @board.board
	if board[0].all? { |n| n == "X" } || board[0].all? { |n| n == "O" } 
	  true
	elsif board[1].all? { |n| n == "X" } || board[1].all? { |n| n == "O" }
	  true
	elsif board[2].all? { |n| n == "X" } || board[2].all? { |n| n == "O" }
	  true
	elsif [board[0][0], board[1][1], board[2][2]].all? { |n| n == "X" } || [board[0][0], board[1][1], board[2][2]].all? { |n| n == "O" } 
	  true
	elsif [board[0][2], board[1][1], board[2][0]].all? { |n| n == "X" } || [board[0][2], board[1][1], board[2][0]].all? { |n| n == "O" }
	  true
	elsif [board[0][0], board[1][0], board[2][0]].all? { |n| n == "X" } || [board[0][0], board[1][0], board[2][0]].all? { |n| n == "O" }
	  true
	elsif [board[0][2], board[1][2], board[2][2]].all? { |n| n == "X" } || [board[0][2], board[1][2], board[2][2]].all? { |n| n == "O" }
	  true
	elsif [board[0][1], board[1][1], board[2][1]].all? { |n| n == "X" } || [board[0][1], board[1][1], board[2][1]].all? { |n| n == "O" }
	  true
	end
  end


  def victory
	puts "#{current_player} has won!"
	return
  end
end

class Player
  attr_reader :player_1, :player_2, :hor, :ver

  def initialize (player1, player2)
	@player_1 = player1
	@player_2 = player2
	@hor = nil
	@ver = nil
  end

  def play (hor, ver)
	@hor = hor
	@ver = ver
  end
end

class Board
  attr_accessor :board

  def initialize
	@board = [[" ", " ", " "], [" ", " ", " "], [" ", " ", " "]]
  end

  def set
	puts "    1   2   3"
	puts "1 | " + @board[0][0] + " | " + @board[0][1] + " | " + @board[0][2] + " |"
	puts "  +---+---+---+"
	puts "2 | " + @board[1][0] + " | " + @board[1][1] + " | " + @board[1][2] + " |" 
	puts "  +---+---+---+"
	puts "3 | " + @board[2][0] + " | " + @board[2][1] + " | " + @board[2][2] + " |" 
	puts "----------------"
  end

  def occupied? (hor, ver)
	true unless @board[hor-1][ver-1] == " "
  end
end


puts
puts "WELCOME TO TIC TAC TOE!".center(60)
puts "\nChoose your names..."
puts "\nPlayer 1:"
player1 = gets.chomp
puts "\nPlayer 2:"
player2 = gets.chomp
puts
game = Game.new(player1, player2)
until game.over?
  if game.turns > 9
	puts "Game Over!!! It's a tie!\n"
	break
  end
  puts "Pick your row (1-3):"
  line = gets.chomp.to_i
  while line > 3 || line.zero?
	puts "Your row should be a number between 1 and 3. Please pick again:"
	line = gets.chomp.to_i
  end
  puts "Pick your column (1-3):"
  column = gets.chomp.to_i
  while column > 3 || column.zero?
	puts "Your column should be a number between 1 and 3. Please pick again:"
	column = gets.chomp.to_i
  end
  if game.board.occupied?(line, column)
	puts "That spot is already full! Please pick again!"
	next
  else
	game.players.play(line, column)
	game.proceed
  end
end