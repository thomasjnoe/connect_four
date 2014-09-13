module ConnectFour
	class Game
		attr_accessor :grid, :current_player
		def initialize
			@grid = Hash.new("_")
			@current_player = "Player 1"
		end

		def start
			puts "Welcome to Connect Four!"
		end

		def switch_player
			if @current_player == "Player 1"
				@current_player = "Player 2"
			else
				@current_player = "Player 1"
			end
		end

		def current_disc
			return @current_player == "Player 1" ? "X" : "O"
		end

		def display_grid
			(0..5).each do |row|
				print "|"
				(0..6).each do |col|
					print col == 6 ? "#{@grid[[row,col]]}" : "#{@grid[[row,col]]} "
				end
				print "|\n"
			end
			puts " 1 2 3 4 5 6 7"
		end

		def select_column
			print "#{@current_player}, select a column (1-7) to drop a disc into: "
			selection = gets.chomp
			selection.to_i
		end

		def first_unoccupied_row(col)
			5.downto(0) do |r|
				if @grid[[r,col]] == "_"
					return r
				end
			end
			return
		end

		def drop_location
			row = nil
			while row.nil?
				col = select_column - 1
				row = first_unoccupied_row(col)
				if row.nil?
					puts "All rows are occupied, please select another column"
				else
					loc = [row,col]
					return loc
				end
			end
		end

		def set_disc(drop_location)
			@grid[drop_location] = current_disc
		end

		def game_over?
			win_conditions = [ [[5,0],[5,1],[5,2],[5,3]],
												 [[5,1],[5,2],[5,3],[5,4]],
												 [[5,2],[5,3],[5,4],[5,5]],
												 [[5,3],[5,4],[5,5],[5,6]],
												 [[4,0],[4,1],[4,2],[4,3]],
												 [[4,1],[4,2],[4,3],[4,4]],
												 [[4,2],[4,3],[4,4],[4,5]],
												 [[4,3],[4,4],[4,5],[4,6]],
												 [[3,0],[3,1],[3,2],[3,3]],
												 [[3,1],[3,2],[3,3],[3,4]],
												 [[3,2],[3,3],[3,4],[3,5]],
												 [[3,3],[3,4],[3,5],[3,6]],
												 [[2,0],[2,1],[2,2],[2,3]],
												 [[2,1],[2,2],[2,3],[2,4]],
												 [[2,2],[2,3],[2,4],[2,5]],
												 [[2,3],[2,4],[2,5],[2,6]],
												 [[1,0],[1,1],[1,2],[1,3]],
												 [[1,1],[1,2],[1,3],[1,4]],
												 [[1,2],[1,3],[1,4],[1,5]],
												 [[1,3],[1,4],[1,5],[1,6]],
												 [[0,0],[0,1],[0,2],[0,3]],
												 [[0,1],[0,2],[0,3],[0,4]],
												 [[0,2],[0,3],[0,4],[0,5]],
												 [[0,3],[0,4],[0,5],[0,6]] ]
			win_condition_met = false
			win_conditions.each do |condition|
				discs = [@grid[condition[0]], @grid[condition[1]], @grid[condition[2]], @grid[condition[3]]]
				if discs.all? { |disc| disc == current_disc }
					win_condition_met = true
				else
					win_condition_met = false
				end
				return true if win_condition_met
			end
			return false
		end

		def display_win_message
			if game_over?
				"Connect Four! #{@current_player} wins!"
			end
		end

		def check_for_game_over
			if game_over?
				puts display_win_message
				display_grid
			else
				switch_player
			end
		end
	end
end






