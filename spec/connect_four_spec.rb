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

		describe "#switch_player" do
			context "when current player is Player 1" do
				it "switches current player to Player 2" do
					game.current_player = "Player 1"
					game.switch_player
					expect(game.current_player).to eq "Player 2"
					expect(game.current_disc).to eq "O"
				end

				context "when current player is Player 2" do
					it "switches current player to Player 1" do
						game.current_player = "Player 2"
						game.switch_player
						expect(game.current_player).to eq "Player 1"
						expect(game.current_disc).to eq "X"
					end
				end
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
				it "sets drop location to row 5" do
					game.grid[[5,0]] = "X"
					expect(game).to receive(:select_column).and_return(1)
					expect(game.drop_location).to eq [4,0]
				end
			end

			context "when rows 5 and 6 are occupied" do
				it "sets drop location to row 4" do
					game.grid[[4,0]] = "X"
					game.grid[[5,0]] = "X"
					expect(game).to receive(:select_column).and_return(1)
					expect(game.drop_location).to eq [3,0]
				end
			end

			context "when rows 4, 5 and 6 are occupied" do
				it "sets drop location to row 3" do
					game.grid[[3,0]] = "X"
					game.grid[[4,0]] = "X"
					game.grid[[5,0]] = "X"
					expect(game).to receive(:select_column).and_return(1)
					expect(game.drop_location).to eq [2,0]
				end
			end

			context "when rows 3, 4, 5 and 6 are occupied" do
				it "sets drop location to row 2" do
					game.grid[[2,0]] = "X"
					game.grid[[3,0]] = "X"
					game.grid[[4,0]] = "X"
					game.grid[[5,0]] = "X"
					expect(game).to receive(:select_column).and_return(1)
					expect(game.drop_location).to eq [1,0]
				end
			end

			context "when rows 2, 3, 4, 5 and 6 are occupied" do
				it "sets drop location to row 1" do
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
				it "notifies player that all rows are occupied" do
					game.grid[[0,0]] = "X"
					game.grid[[1,0]] = "X"
					game.grid[[2,0]] = "X"
					game.grid[[3,0]] = "X"
					game.grid[[4,0]] = "X"
					game.grid[[5,0]] = "X"
					allow(game).to receive(:select_column) do 
						@counter ||= 0
						response = if @counter > 3
							2
						else
							1
						end
						@counter += 1
						response
					end
					expect(game.drop_location).to eq [5,1]
				end
			end
		end

		describe "#set_disc" do
			context "during Player 1's turn" do
				it "places an X in the game grid at the drop location specified" do
					game.current_player = "Player 1"
					game.set_disc([1,2])
					expect(game.grid[[1,2]]).to eq "X"
				end
			end

			context "during Player 2's turn" do
				it "places an O in the game grid at the drop location specified" do
					game.current_player = "Player 2"
					game.set_disc([1,2])
					expect(game.grid[[1,2]]).to eq "O"
				end
			end
		end

		describe "#game_over?" do
			context "when horizontal connect four occurs" do
				it "returns true for player 1" do
					game.current_player = "Player 1"
					game.set_disc([5,0])
					game.set_disc([5,1])
					game.set_disc([5,2])
					game.set_disc([5,3])
					expect(game.game_over?).to eq true
				end

				it "returns true for player 2" do
					game.current_player = "Player 2"
					game.set_disc([1,2])
					game.set_disc([1,3])
					game.set_disc([1,4])
					game.set_disc([1,5])
					expect(game.game_over?).to eq true
				end
			end

			context "when vertical connect four occurs" do
				it "returns true for player 1" do
					game.current_player = "Player 1"
					game.set_disc([5,0])
					game.set_disc([4,0])
					game.set_disc([3,0])
					game.set_disc([2,0])
					expect(game.game_over?).to eq true
				end

				it "returns true for player 2" do
					game.current_player = "Player 2"
					game.set_disc([2,2])
					game.set_disc([3,2])
					game.set_disc([4,2])
					game.set_disc([5,2])
					expect(game.game_over?).to eq true
				end
			end
		end
	end
end





