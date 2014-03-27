class Board
  attr_reader :lines, :marked_lines, :space, :winner, :possible_moves, :possible_wins
  @@line_names = [:top_row, :middle_row, :bottom_row, 
                  :left_column, :right_column, :middle_column,
                  :diagonal_slash, :diagonal_backslash ]

  def initialize params={}
    @space = params[:space].nil? ? setup_spaces : params[:space]
    @possible_moves = params[:possible_moves].nil? ? setup_spaces : params[:possible_moves]
    @marked_lines = params[:marked_lines].nil? ? setup_marked_lines : params[:marked_lines]
    @board = []
    @winner = []
    @possible_wins = []
    @markers = [:X, :O]
    @lines = setup_lines
  end

  def setup_spaces
    spaces = []
    (1..9).each do |n|
      spaces << n
    end
    return spaces
  end

  def setup_marked_lines
    ml = {}
    @@line_names.each do |line|
      ml[line] = []
    end
    return ml
  end

  def dup_marked_lines
    dup = {}
    @@line_names.each do |line|
      dup[line] = @marked_lines[line].dup
    end
    dup
  end

  def setup_lines
    l = {}

    l[:top_row]    = [1,2,3]
    l[:middle_row] = [4,5,6] 
    l[:bottom_row] = [7,8,9]

    l[:left_column]   = [1,4,7]
    l[:middle_column] = [2,5,8]
    l[:right_column]  = [3,6,9]

    l[:diagonal_slash]     = [7,5,3]
    l[:diagonal_backslash] = [1,5,9]

    return l
  end

  def find_possible_wins
    @possible_wins = []
    @marked_lines.each do |line_name, line|
      @markers.each do |marker| 
        if line.count == 2 && line.count(marker) == 2
          @possible_wins << line_name
        end
      end
    end
    @possible_wins
  end

  def space_to_complete_line
    find_possible_wins
    @possible_wins.each do |line_name|
      @lines[line_name].each do |space|
        return space if @possible_moves.include?(space)
      end
    end
  end

  def show
    format_rows
    format_board
    @board.each {|row| puts row }
  end

  def mark_space(number, marker)
    @space[number-1] = marker 
    update_lines(number, marker)
    update_possible_moves(number)
  end

  def update_lines(number, marker)
    @@line_names.each do |name|
      @marked_lines[name] << marker if @lines[name].include?(number)
    end
  end

  def update_possible_moves(number)
    @possible_moves.delete(number)
  end

  def space_free?(number)
    @possible_moves.include?(number)
  end

  def is_full?
    # marked = @space.select {|m| m.is_a?(Symbol) }
    # marked.count == @space.length ? true : false
    @possible_moves.empty?
  end

  def has_winner?
    @markers.each do |marker|
      @marked_lines.each do |line_name, line|
        if line.count(marker) == 3
          @winner = [marker, line_name] 
          return true
        end
      end
    end
    return false
  end

  def format_rows
    @board = []
    (0..2).each do |i|
      @board << "  #{@space[0+(i*3)]} || #{@space[1+(i*3)]} || #{@space[2+(i*3)]}  \n"
    end
  end

  def format_board
    v_border = "    ||   ||    \n"
    h_border = "===============\n"
    (0..2).each do |i|
      @board[i]  = v_border + @board[i] + v_border
      @board[i] += h_border unless i == 2
    end
    return @board
  end

  def copy
    copy = Board.new(
      space: @space.dup,
      possible_moves: @possible_moves.dup,
      marked_lines: dup_marked_lines
      )
    return copy
  end
end
