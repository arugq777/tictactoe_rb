require "./lib/tictactoe"

class Player
  def determine_sentience
    if @number == 1
      return false
    else
      return true
    end
  end
end

class TicTacToeWeb < TicTacToe
  attr_accessor :output
  def initialize
    super
    @output = []
  end

  def coin_toss
    @players.shuffle!
    @output << "A virtual coin has been tossed; #{@players.first.name} goes first."
  end

  def pick_space(chosen_space)
    if @current_player.marker == :X
      space = automatically_pick_space
    else
      space = chosen_space
    end
    @board.mark_space(space, @current_player.marker)
    return space
  end

  def play(chosen_space)
    @output = []
    @current_player = @players[@turn_count % 2]
    space = pick_space(chosen_space)
    @turn_count += 1

    @output << "\nTurn #{@turn_count}: Player #{@current_player.number} (#{@current_player.marker}) takes space #{space}"

    if game_over
      if @board.has_winner?
        @output << "Player #{@current_player.number} (#{@board.winner[0]}) finishes the #{@board.winner[1]} and wins!"
      else
        @output << "No one wins. Nuclear weapons shall be launched!\n(I think that's how it works, anyway...)"
      end
    end
    
    return space
  end

end