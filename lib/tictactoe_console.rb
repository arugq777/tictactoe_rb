require "./lib/tictactoe"
class TicTacToeConsole < TicTacToe
  def play
    coin_toss
    until game_over 
      @current_player = @players[@turn_count % 2]
      space = pick_space(@current_player)
      @turn_count += 1
      puts "\nTurn #{@turn_count}: Player #{@current_player.number} (#{@current_player.marker}) takes space #{space}"
      @board.show
    end

    if @board.has_winner?
      puts "Player #{@current_player.number} (#{@board.winner[0]}) finishes the #{@board.winner[1]} and wins!"
    else
      puts "No one wins. Nuclear weapons shall be launched!\n(I think that's how it works, anyway...)"
    end
  end
end