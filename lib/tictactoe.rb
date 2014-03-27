require './lib/board'
require './lib/player'

Node = Struct.new(:move, :score, :player)

class TicTacToe
  attr_accessor :players, :current_player, :board, :turn_count, #:move_history
                :choice
  def initialize
    @turn_count = 0
    @players = []
    @board = Board.new
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
    space = nil
    if player.is_human?
      space = manually_pick_space
    # else #if player.is_dumb_cpu?
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
      # puts "@board.marked_lines #{@board.marked_lines}"
      return space
    # end
  end

  # def find_obvious_move
    # if @turn_count == 0
    #   return 1
    # elsif @turn_count == 1
    #   if @board.possible_moves.include?(5)
    #     return 5
    #   else
    #     return 1
    #   end
    # elsif someone_is_about_to_win?
    #   return @board.space_to_complete_line
    # else
    #   return nil
    # end
  # end

  def someone_is_about_to_win?
    @players.each do |p|
      return true if p.is_about_to_win?(@board)
    end
    return false
  end

  def alternate(player)
    # puts "in #alternate #{player}"
    return [:X,:O].find {|marker| marker != player}
  end

  def find_best_move(player, board)
    scores = []
    board.possible_moves.each do |move|
      board_cp = board.copy
      board_cp.mark_space(move, player)
      score = 0
      if player == :X
        score = min_move(board_cp, alternate(player))
      else
        score = max_move(board_cp, alternate(player))
      end
      scores << Node.new(move,score,player)
    end
    best_move = nil
    if player == :X
      best_score = -1
        scores.each do |node|
          if node.score > best_score
            best_move = node.move
          end
        end
    else
      best_score = 1
        scores.each do |node|
          if node.score < best_score
            best_move = node.move
          end
        end
    end
    return best_move
  end

  def min_move(board, player)
    if board.has_winner? || board.is_full?
      s = score(board, :X)
      #puts "min score #{s}"
      return s
    end
    best_score = 1
    board.possible_moves.each do |move|
      board_cp = board.copy
      board_cp.mark_space(move, player)
      score = max_move(board_cp, alternate(player))
      if score < best_score
        best_score = score
      end
    end
    return best_score
  end

  def max_move(board, player)
    if board.has_winner? || board.is_full?
      s = score(board, :X)
      #puts "max score #{s}"
      return s
    end
    best_score = -1
    board.possible_moves.each do |move|
      board_cp = board.copy
      board_cp.mark_space(move, player)
      score = min_move(board_cp, alternate(player))
      if score > best_score
        best_score = score
      end
    end
    return best_score
  end

  def score(board, player)
    if board.has_winner?
      if board.winner[0] == player
        return 1
      else
        return -1
      end
    else
      return 0
    end
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
