class Board
  attr_reader :lines, :space, :winner, :possible_moves
  @@line_names = [:top_row, :middle_row, :bottom_row, 
                  :left_column, :right_column, :middle_column,
                  :diagonal_slash, :diagonal_backslash ]

  def initialize
    @board, @winner = [], []
    @space = setup_spaces
    @possible_moves = setup_spaces
    @marked_lines = setup_marked_lines
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

  def setup_lines
    l = {}

    l[:top_row]    = [0,1,2]
    l[:middle_row] = [3,4,5] 
    l[:bottom_row] = [6,7,8]

    l[:left_column]   = [0,3,6]
    l[:middle_column] = [1,4,7]
    l[:right_column]  = [2,5,8]

    l[:diagonal_slash]     = [6,4,2]
    l[:diagonal_backslash] = [0,4,8]

    return l
  end

  def show
    format_rows
    format_board
    @board.each {|row| puts row }
  end

  def mark_space(number, marker)
    @space[number] = marker 
    update_lines(number, marker)
    update_possible_moves(number + 1)
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
    marked = @space.select {|m| m.is_a?(Symbol) }
    if marked.count == @space.length
      return true
    end
  end

  def has_winner?(players)
    players.each do |p|
      @marked_lines.each do |line_name, line|
        if line.count(p.marker) == 3
          @winner = [p.number, line_name] 
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
end
