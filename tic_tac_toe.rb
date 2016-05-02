class Board
	attr_accessor :board

	def initialize
		@board = [[" ", " ", " "], [" ", " ", " "], [" ", " ", " "]]
	end

	def set
		puts "    1   2   3"
		puts "1 | " + @board[0][0] + " | " + @board[0][1] + " | " + @board[0][2] + " |"
		puts "2 | " + @board[1][0] + " | " + @board[1][1] + " | " + @board[1][2] + " |" 
		puts "3 | " + @board[2][0] + " | " + @board[2][1] + " | " + @board[2][2] + " |" 
		puts "----------------"
	end
end


class Player
	attr_reader :board, :turns

	def initialize (player1, player2)
		@player_1 = player1
		@player_2 = player2
		@toss = nil
		@turns = 0
		@board = Board.new
		players
		@board.set
		turn
	end

	def players
		puts "\n#{@player_1} vs #{@player_2}"
	end

	def play(hor, ver)
		board = @board.board
		board[hor-1][ver-1] = letter
		@board.set
		win? ? victory : turn
	end

	def over?
		win?
	end


	def occupied? (hor, ver)
		true unless @board.board[hor-1][ver-1] == " "
	end

	private

	def letter
		if @toss == 0
			@turns.odd? ? "X" : "O"
		else
			@turns.odd? ? "O" : "X"
		end
	end

	def turn
		if @turns == 0
			@toss = rand(2)
			puts @toss == 0 ? "It's #{@player_1}'s turn." : "It's #{@player_2}'s turn."
			@turns += 1
		else
			@turns += 1
			puts  @turns.odd? ? "It's #{@toss == 0 ? @player_1 : @player_2}'s turn." : "It's #{@toss == 0 ? @player_2 : @player_1}'s turn"
		end
	end

	def win?
		board = @board.board
		if board[0].all? {|n| n == "X"} || board[0].all? {|n| n == "O"} 
			true
		elsif board[1].all? {|n| n == "X"} || board[1].all? {|n| n == "O"}
			true
		elsif board[2].all? {|n| n == "X"} || board[2].all? {|n| n == "O"}
			true
		elsif [board[0][0], board[1][1], board[2][2]].all? {|n| n == "X"} || [board[0][0], board[1][1], board[2][2]].all? {|n| n == "O"} 
			true
		elsif [board[0][2], board[1][1], board[2][0]].all? {|n| n == "X"} || [board[0][2], board[1][1], board[2][0]].all? {|n| n == "O"}
			true
		elsif [board[0][0], board[1][0], board[2][0]].all? {|n| n == "X"} || [board[0][0], board[1][0], board[2][0]].all? {|n| n == "O"}
			true
		elsif [board[0][2], board[1][2], board[2][2]].all? {|n| n == "X"} || [board[0][2], board[1][2], board[2][2]].all? {|n| n == "O"}
			true
		elsif [board[0][1], board[1][1], board[2][1]].all? {|n| n == "X"} || [board[0][1], board[1][1], board[2][1]].all? {|n| n == "O"}
			true
		end
	end

	def victory
		puts "\n#{@turns.odd? ? (@toss == 0 ? @player_1 : @player_2) : (@toss == 0 ? @player_2 : @player_1)} has won!"
		return
	end

end

puts
puts "WELCOME TO TIC TAC TOE!".center(60)
puts "\nChoose your names..."
puts "\nPlayer 1:"
player1 = gets.chomp
puts "\nPlayer 2:"
player2 = gets.chomp
game = Player.new(player1, player2)
until game.over?
	if game.turns > 9
		puts "It's a tie!\n"
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
	if game.occupied?(line, column)
		puts "That spot is already full! Please pick again!"
		next
	else
		puts game.play(line, column)
	end
end

