class Player
  attr_accessor :name, :number, :marker, :is_human
  
  def initialize(number)
    @number   = number
    @marker   = pick_letter
    @name     = "Player #{@number} (#{@marker})" #pick_name
    @is_human = determine_sentience
  end

  # def pick_name
  #   print "Enter name: "
  #   n = gets.chomp
  #   while n.empty?
  #     print "Name was blank. default to 'Player #{@number}'? Y/N:"
  #     yn = gets[0].chomp.upcase
  #     if yn == 'Y' || yn.empty?
  #       n = "Player " + @number.to_s
  #     else
  #       print "Fine, pick another name: "
  #       n = gets.chomp
  #     end
  #   end
  #   return n
  # end

  def pick_letter
    if @number == 1
      return :X
    else
      return :O
    end
  end

  def determine_sentience
    print "Is #{@name} human? Y/N: "
    yn = gets[0].chomp.upcase
    if yn == 'Y'
      puts "#{@name}'s humanity is noted for future reference."
      @is_human = true
    elsif yn == 'N'
      puts "#{@name} is a cold, heartless machine."
      @is_human = false
    else
      puts "Invalid response. Defaulting to Not Human."
      @is_human = false
    end
  end

  def is_human?
    return @is_human
  end

  def is_about_to_win?(board)
    board.lines.each_value do |line|
      return true if line.count(@marker) == 2
    end
    return false
  end
end
