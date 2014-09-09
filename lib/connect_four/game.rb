module ConnectFour
	class Game
		attr_accessor :grid
		def initialize
			@grid = Hash.new("_")
		end

		def start
			puts "Welcome to Connect Four!"
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
			col = select_column - 1
			row = nil
			5.downto(0) do |r|
				if @grid[[r,col]] == "_"
					row = r
					break
				end
			end
			if row.nil?
				return "All rows are occupied, please select another column"
			else
				loc = [row,col]
			end
			loc
		end
	end
end