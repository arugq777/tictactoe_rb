require './board'
require './player'

# class Move
#   attr_reader :player, :space, :move_number
#   def initialize(p, s, n)
#     @player, @space, @move_number = p, s, n
#   end
# end

class TicTacToe
  attr_accessor :players, :board, :turn_count #:move_history

  def initialize
    @turn_count = 0
    @players = []
    @board = Board.new
    #@move_history = []
    2.times { @players << player_setup}
  end

  def player_setup
    p = Player.new(@players.count+1)
    return p
  end

  def coin_toss
    @players.shuffle!
    puts "A virtual coin has been tossed; #{@players.first.name} goes first."
  end

  def pick_space(player)
    if player.is_human?
      space = manually_pick_space
    else
      space = randomly_pick_space
    end
    @board.mark_space(space, player.marker)
    return space
  end

  def manually_pick_space
    space = nil
    until @board.space_free?(space)
      space = nil
      print "Pick a space (1-9): "
      space = gets[0].to_i
      puts "Invalid choice. Try again." unless @board.space_free?(space)
    end
    return space - 1
  end

  def randomly_pick_space
    space = @board.possible_moves.sample
    return space - 1
  end

  # def automatically_pick_space( player )
  #   opponent = @players[player.number % 2]
  #   if @turn_count == 0
  #     #take corner
  #     return 0
  #   elsif @turn_count == 1
  #     #take center, otherwise take corner
  #     #(basically, we assume the first player favors the corner)
  #     if @board.possible_moves.include?(5)
  #       return 4
  #     else
  #       return 0
  #     end
  #   else
  #     #return minimax
  #   end
  # end

  def play
    coin_toss
    until game_over 
      player = @players[@turn_count % 2]
      space = pick_space(player)
      @turn_count += 1
      puts "\nTurn #{@turn_count}: Player #{player.number} (#{player.marker}) takes space #{space + 1}"
      #@move_history << Move.new(player, space, turn_count)
      @board.show
    end

    if @board.has_winner?(@players)
      puts "Player #{@board.winner[0]} finishes the #{@board.winner[1]} and wins!"
    else
      puts "No one wins. This game is stupid"
    end
  end

  def game_over
    return @board.has_winner?(@players) || @board.is_full?
  end
end

ttt = TicTacToe.new()
ttt.play
