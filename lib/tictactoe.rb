require './lib/board'
require './lib/player'
require './lib/minimax'

class TicTacToe
  include Minimax
  attr_accessor :players, :current_player, :board, :turn_count #, :move_history
  def initialize
    @turn_count = 0
    @players = []
    @board = Board.new
    2.times { @players << player_setup }
  end

  def player_setup
    Player.new(@players.count+1)
  end

  def coin_toss
    @players.shuffle!
    puts "A virtual coin has been tossed; #{@players.first.name} goes first."
  end

  def pick_space(player)
    space = nil
    if player.is_human?
      space = manually_pick_space
    # elsif player.is_dumb_cpu?
    #   space = randomly_pick_space
    else
      space = automatically_pick_space
    end
    @board.mark_space(space, player.marker)
    return space
  end

  # def randomly_pick_space
  #   return @board.possible_moves.sample
  # end

  def manually_pick_space
    space = nil
    until @board.space_free?(space)
      space = nil
      print "Pick a space (1-9): "
      space = gets[0].to_i
      puts "Invalid choice. Try again." unless @board.space_free?(space)
    end
    return space
  end

  def automatically_pick_space
    player = @current_player.marker
    # space = find_obvious_move
    # if space != nil
    #   return space
    # else
      space = find_best_move(player, @board)
      return space
    # end
  end

  # def find_obvious_move
  #   if @turn_count == 0
  #     return 1
  #   elsif @turn_count == 1
  #     if @board.possible_moves.include?(5)
  #       return 5
  #     else
  #       return 1
  #     end
  #   # elsif someone_is_about_to_win?
  #   #   return @board.space_to_complete_line
  #   else
  #     return nil
  #   end
  # end

  def someone_is_about_to_win?
    @players.each do |p|
      return true if p.is_about_to_win?(@board)
    end
    return false
  end

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

  def game_over
    return @board.has_winner? || @board.is_full?
  end
end
