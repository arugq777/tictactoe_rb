module Minimax
  MAX_VALUE =  1
  MIN_VALUE = -1
  Node = Struct.new(:move, :score)

  def alternate(player)
    return [:X,:O].find {|marker| marker != player}
  end

  def find_best_move(player, board)
    scores = compile_scores(player, board)
    best_score = player == @players[0].marker ? MIN_VALUE : MAX_VALUE
    best_move = get_best_move(scores, best_score)
    return best_move
  end

  def compile_scores(player, board)
    scores = []
    board.possible_moves.each do |move|
      board_cp = board.copy
      board_cp.mark_space(move,player)
      score = 0
      if player == @players[0].marker
        score = min_move(board_cp, alternate(player))
      else
        score = max_move(board_cp, alternate(player))
      end
      scores << Node.new(move, score)
    end
    return scores
  end

  def get_best_move(scores, best)
    best_move = nil
    if best == MAX_VALUE
      scores.each do |node|
        best_move = node.move if node.score < best
      end
    else
      scores.each do |node|
        best_move = node.move if node.score > best
      end
    end
    return best_move
  end

  def min_move(board, player)
    if board.has_winner? || board.is_full?
      return score(board)
    end
    best_score = MAX_VALUE
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
      return score(board)
    end
    best_score = MIN_VALUE
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

  def score(board)
    if board.has_winner?
      if board.winner[0] == @players[0].marker
        return MAX_VALUE
      else
        return MIN_VALUE
      end
    else
      return 0
    end
  end
end