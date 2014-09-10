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
			print "Select a column (1-7) to drop a disc into: "
			selection = gets.chomp
			selection.to_i
		end

		def drop_location
			loop do
			col = select_column - 1
			row = nil
				5.downto(0) do |r|
					if @grid[[r,col]] == "_"
						row = r
						break
					end
				end
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
	end
end