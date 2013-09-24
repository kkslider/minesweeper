# require 'debugger'
require './ms_tile.rb'
require './ms_board.rb'

class Game
  def validate_input(prompt, input_type, &prc)
    # debugger
    done = false
    until done
      puts prompt
      case input_type
      when :String
        input = gets.chomp.rstrip.downcase
      when :Array
        input = gets.chomp.split(/[,\[\]\s]/).reject {|el| el.empty?}.map {|n| n.to_i}
      when :Fixnum
        input = gets.chomp.to_i
      end
      done = prc.call(input)
    end
    return input
  end
    
  def setup
    puts "Welcome to Minesweeper!"
    size = validate_input("How large should the game board be? Integer please.", :Fixnum) { |num| num >= 1 }
  
    bombs = validate_input("How many mines would you like on the board?", :Fixnum) { |num| num < size * size }
    
    board = Board.new(size, bombs)
  end
  
  def play
    board = setup
    
    keep_playing = true
    # loop here
    while keep_playing
      board.print_user
      action = validate_input("Flag or Reveal?", :String) {|x| ["f","r"].include?(x)}
      tile_coord = validate_input("Which tile?", :Array) {|x| x.all? { |coord| coord < board.size && coord >= 0 } }
      tile = board.tiles[tile_coord[0]][tile_coord[1]]
      keep_playing = tile.explore if action == "r"
      
      tile.flagged = true if action == "f"
      keep_playing = !board.game_over? unless !keep_playing
    end
    board.print_user
    
    lost = board.tiles.any? do |row|
      row.any? { |tile| tile.has_bomb && tile.revealed }
    end
    
    
    lost ? (puts "You lose!!!!") : (puts "You win!!!!")
    
  end
end