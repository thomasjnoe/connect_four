require 'spec_helper'

module ConnectFour
	describe Game do
		let (:game) { Game.new }

		describe "#display_start_message" do
			it "displays a welcome message" do
				expect { game.display_start_message }.to output("Welcome to Connect Four!\n").to_stdout
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
				expect(game.select_column).to eq "1"
			end
		end

		describe "#drop_location" do
			context "when no rows in selected column are occupied" do
				it "sets drop location to row 6" do
					expect(game).to receive(:valid_selection).and_return(0)
					expect(game.drop_location).to eq [0,5]
				end
			end

			context "when row 6 is occupied" do
				it "sets drop location to row 5" do
					game.grid[[0,5]] = "X"
					expect(game).to receive(:valid_selection).and_return(0)
					expect(game.drop_location).to eq [0,4]
				end
			end

			context "when rows 5 and 6 are occupied" do
				it "sets drop location to row 4" do
					game.grid[[0,5]] = "X"
					game.grid[[0,4]] = "X"
					expect(game).to receive(:valid_selection).and_return(0)
					expect(game.drop_location).to eq [0,3]
				end
			end

			context "when rows 4, 5 and 6 are occupied" do
				it "sets drop location to row 3" do
					game.grid[[0,5]] = "X"
					game.grid[[0,4]] = "X"
					game.grid[[0,3]] = "X"
					expect(game).to receive(:valid_selection).and_return(0)
					expect(game.drop_location).to eq [0,2]
				end
			end

			context "when rows 3, 4, 5 and 6 are occupied" do
				it "sets drop location to row 2" do
					game.grid[[0,5]] = "X"
					game.grid[[0,4]] = "X"
					game.grid[[0,3]] = "X"
					game.grid[[0,2]] = "X"
					expect(game).to receive(:valid_selection).and_return(0)
					expect(game.drop_location).to eq [0,1]
				end
			end

			context "when rows 2, 3, 4, 5 and 6 are occupied" do
				it "sets drop location to row 1" do
					game.grid[[0,5]] = "X"
					game.grid[[0,4]] = "X"
					game.grid[[0,3]] = "X"
					game.grid[[0,2]] = "X"
					game.grid[[0,1]] = "X"
					expect(game).to receive(:valid_selection).and_return(0)
					expect(game.drop_location).to eq [0,0]
				end
			end

			context "when all rows are occupied" do
				it "notifies player that all rows are occupied" do
					game.grid[[0,5]] = "X"
					game.grid[[0,4]] = "X"
					game.grid[[0,3]] = "X"
					game.grid[[0,2]] = "X"
					game.grid[[0,1]] = "X"
					game.grid[[0,0]] = "X"
					allow(game).to receive(:valid_selection) do 
						@counter ||= 0
						response = if @counter > 3
							1
						else
							0
						end
						@counter += 1
						response
					end
					expect(game.drop_location).to eq [1,5]
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
			context "when vertical connect four occurs" do
				it "returns true for player 1" do
					game.current_player = "Player 1"
					game.set_disc([5,0])
					game.set_disc([5,1])
					game.set_disc([5,2])
					game.set_disc([5,3])
					expect(game.game_over?).to eq true
					expect(game.display_win_message).to eq "Connect Four! Player 1 wins!"
				end

				it "returns true for player 2" do
					game.current_player = "Player 2"
					game.set_disc([1,2])
					game.set_disc([1,3])
					game.set_disc([1,4])
					game.set_disc([1,5])
					expect(game.game_over?).to eq true
					expect(game.display_win_message).to eq "Connect Four! Player 2 wins!"
				end
			end

			context "when horizontal connect four occurs" do
				it "returns true for player 1" do
					game.current_player = "Player 1"
					game.set_disc([5,0])
					game.set_disc([4,0])
					game.set_disc([3,0])
					game.set_disc([2,0])
					expect(game.game_over?).to eq true
					expect(game.display_win_message).to eq "Connect Four! Player 1 wins!"
				end

				it "returns true for player 2" do
					game.current_player = "Player 2"
					game.set_disc([2,2])
					game.set_disc([3,2])
					game.set_disc([4,2])
					game.set_disc([5,2])
					expect(game.game_over?).to eq true
					expect(game.display_win_message).to eq "Connect Four! Player 2 wins!"
				end
			end

			context "when upward diagonal connect four occurs" do
				it "returns true for player 1" do
					game.current_player = "Player 1"
					game.set_disc([0,3])
					game.set_disc([1,4])
					game.set_disc([2,5])
					game.set_disc([3,6])
					expect(game.game_over?).to eq true
					expect(game.display_win_message).to eq "Connect Four! Player 1 wins!"
				end

				it "returns true for player 2" do
					game.current_player = "Player 2"
					game.set_disc([2,0])
					game.set_disc([3,1])
					game.set_disc([4,2])
					game.set_disc([5,3])
					expect(game.game_over?).to eq true
					expect(game.display_win_message).to eq "Connect Four! Player 2 wins!"
				end
			end

			context "when downward diagonal connect four occurs" do
				it "returns true for player 1" do
					game.current_player = "Player 1"
					game.set_disc([5,0])
					game.set_disc([4,1])
					game.set_disc([3,2])
					game.set_disc([2,3])
					expect(game.game_over?).to eq true
					expect(game.display_win_message).to eq "Connect Four! Player 1 wins!"
				end

				it "returns true for player 2" do
					game.current_player = "Player 2"
					game.set_disc([5,3])
					game.set_disc([4,4])
					game.set_disc([3,5])
					game.set_disc([2,6])
					expect(game.game_over?).to eq true
					expect(game.display_win_message).to eq "Connect Four! Player 2 wins!"
				end
			end

			context "when all locations are occupied and no connect four occurs" do
				it "returns true and ends in a tie" do
					game.current_player = "Player 1"
					game.set_disc([0,5])
					game.set_disc([1,5])
					game.set_disc([2,5])
					game.set_disc([4,5])
					game.set_disc([5,5])
					game.set_disc([6,5])
					game.set_disc([3,4])
					game.set_disc([0,3])
					game.set_disc([1,3])
					game.set_disc([2,3])
					game.set_disc([4,3])
					game.set_disc([5,3])
					game.set_disc([6,3])
					game.set_disc([3,2])
					game.set_disc([0,1])
					game.set_disc([1,1])
					game.set_disc([2,1])
					game.set_disc([4,1])
					game.set_disc([5,1])
					game.set_disc([6,1])
					game.set_disc([3,0])
					game.current_player = "Player 2"
					game.set_disc([3,5])
					game.set_disc([0,4])
					game.set_disc([1,4])
					game.set_disc([2,4])
					game.set_disc([4,4])
					game.set_disc([5,4])
					game.set_disc([6,4])
					game.set_disc([3,3])
					game.set_disc([0,2])
					game.set_disc([1,2])
					game.set_disc([2,2])
					game.set_disc([4,2])
					game.set_disc([5,2])
					game.set_disc([6,2])
					game.set_disc([3,1])
					game.set_disc([0,0])
					game.set_disc([1,0])
					game.set_disc([2,0])
					game.set_disc([4,0])
					game.set_disc([5,0])
					game.set_disc([6,0])
					expect(game.game_over?).to eq true
					expect(game.tie?).to eq true
				end
			end
		end

		describe "#play" do
			after(:each) do
				game.play
			end

			context "when one game played" do
				before(:each) do
					allow(game).to receive(:play_again?).and_return(false)
				end

				context "when Player 1 wins" do
					before(:each) do
						expect(game).to receive(:display_win_message).and_return("Connect Four! Player 1 wins!").and_call_original.once
					end

					it "recognizes a horizontal Connect Four" do
						allow(game).to receive(:valid_selection).and_return(0,0,1,1,2,2,3)
					end

					it "recognizes a vertical Connect Four" do
						allow(game).to receive(:valid_selection).and_return(0,1,0,1,0,1,0)
					end

					it "recognizes a diagonal Connect Four" do
						allow(game).to receive(:valid_selection).and_return(0,1,2,3,1,2,2,3,3,4,3)
					end
				end

				context "when Player 2 wins" do
					before(:each) do
						expect(game).to receive(:display_win_message).and_return("Connect Four! Player 2 wins!").and_call_original.once
					end

					it "recognizes a horizontal Connect Four" do
						allow(game).to receive(:valid_selection).and_return(0,0,1,1,2,2,4,3,4,3)
					end

					it "recognizes a vertical Connect Four" do
						allow(game).to receive(:valid_selection).and_return(0,1,0,1,2,1,0,1)
					end

					it "recognizes a diagonal Connect Four" do
						allow(game).to receive(:valid_selection).and_return(1,0,2,1,2,2,3,3,3,3)
					end
				end

			end
		end
	end
end





