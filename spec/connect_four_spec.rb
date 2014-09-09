require 'spec_helper'

module ConnectFour
	describe Game do
		let (:game) { Game.new }

		describe "#start" do
			it "displays a welcome message" do
				expect { game.start }.to output("Welcome to Connect Four!\n").to_stdout
			end
		end

		describe "#display_grid" do
			it "displays a grid with 6 rows and 7 columns" do
				expect { game.display_grid }.to output(
					"|_ _ _ _ _ _ _|\n|_ _ _ _ _ _ _|\n|_ _ _ _ _ _ _|\n|_ _ _ _ _ _ _|\n|_ _ _ _ _ _ _|\n|_ _ _ _ _ _ _|\n 1 2 3 4 5 6 7\n").to_stdout
			end
		end

		describe "#select_column" do
			it "asks the player to choose a column to drop disc into" do
				expect(game).to receive(:gets).and_return("1")
				expect(game.select_column).to eq 1
			end
		end

		describe "#drop_location" do
			context "when no rows in selected column are occupied" do
				it "sets drop location to row 6" do
					expect(game).to receive(:select_column).and_return(1)
					expect(game.drop_location).to eq [5,0]
				end
			end

			context "when row 6 is occupied" do
				it "sets drop location to row 6" do
					game.grid[[5,0]] = "X"
					expect(game).to receive(:select_column).and_return(1)
					expect(game.drop_location).to eq [4,0]
				end
			end

			context "when rows 5 and 6 are occupied" do
				it "sets drop location to row 6" do
					game.grid[[4,0]] = "X"
					game.grid[[5,0]] = "X"
					expect(game).to receive(:select_column).and_return(1)
					expect(game.drop_location).to eq [3,0]
				end
			end

			context "when rows 4, 5 and 6 are occupied" do
				it "sets drop location to row 6" do
					game.grid[[3,0]] = "X"
					game.grid[[4,0]] = "X"
					game.grid[[5,0]] = "X"
					expect(game).to receive(:select_column).and_return(1)
					expect(game.drop_location).to eq [2,0]
				end
			end

			context "when rows 3, 4, 5 and 6 are occupied" do
				it "sets drop location to row 6" do
					game.grid[[2,0]] = "X"
					game.grid[[3,0]] = "X"
					game.grid[[4,0]] = "X"
					game.grid[[5,0]] = "X"
					expect(game).to receive(:select_column).and_return(1)
					expect(game.drop_location).to eq [1,0]
				end
			end

			context "when rows 2, 3, 4, 5 and 6 are occupied" do
				it "sets drop location to row 6" do
					game.grid[[1,0]] = "X"
					game.grid[[2,0]] = "X"
					game.grid[[3,0]] = "X"
					game.grid[[4,0]] = "X"
					game.grid[[5,0]] = "X"
					expect(game).to receive(:select_column).and_return(1)
					expect(game.drop_location).to eq [0,0]
				end
			end

			context "when all rows are occupied" do
				it "sets drop location to row 6" do
					game.grid[[0,0]] = "X"
					game.grid[[1,0]] = "X"
					game.grid[[2,0]] = "X"
					game.grid[[3,0]] = "X"
					game.grid[[4,0]] = "X"
					game.grid[[5,0]] = "X"
					expect(game).to receive(:select_column).and_return(1)
					expect(game.drop_location).to eq "All rows are occupied, please select another column"
				end
			end
		end
	end
end