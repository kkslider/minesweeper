require 'debugger'
class Tile
  attr_accessor :has_bomb, :board, :coord, :nearby_bombs, :revealed, :flagged
  
  def explore
    # debugger
    return :lose if self.has_bomb
    @nearby_bombs = self.count_neighbor_bombs
    @revealed = true unless @flagged
    if @nearby_bombs == 0
      self.neighbors.each {|neighbor| neighbor.explore unless (neighbor.revealed || neighbor.flagged) }
    end
    return nil
  end   
  
  def count_neighbor_bombs
    self.neighbors.inject(0) { |sum, tile| tile.has_bomb ? (sum + 1) : sum  }
  end
  
  
  def neighbors
    moves = [
      [-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]
    ]
    neighbors = moves.map do |move|
      x, y = @coord[0] + move[0], @coord[1] + move[1]
      next unless (x >= 0 && x < @board.size) && (y >= 0 && y < @board.size)
      next_door_tile = @board.tiles[x][y] 
    end
    neighbors.select { |t| !t.nil? }      
  end
  
  def initialize(board)
    @board = board
    @revealed = false
    @flagged = false
  end
end

class Board
  attr_reader :size, :tiles
  
  def initialize(size=9, bombs=10)
    @tiles = Array.new(size) {Array.new(size) {Tile.new(self)}}
    @size = size
    set_tile_coord
    place_bombs(bombs)
  end
  
  def place_bombs(bombs)
    bombs_placed = 0
    until bombs_placed == bombs
      x = (0...size).to_a.sample
      y = (0...size).to_a.sample
      unless @tiles[x][y].has_bomb
        @tiles[x][y].has_bomb = true
        bombs_placed += 1
      end
    end
    return nil     
  end
  
  def set_tile_coord
    tiles.each_with_index do |row, x_coord|
      row.each_with_index do |col, y_coord|
        tiles[x_coord][y_coord].coord = [x_coord, y_coord]
      end
    end
  end
  
  def print_full_board
    @tiles.each_with_index do |row, x_coord|
      row.each_with_index do |col, y_coord|
        tile = @tiles[x_coord][y_coord]
        if tile.has_bomb
          print " X "
        else
          num_bombs = tile.count_neighbor_bombs
          if num_bombs == 0
            print " _ "
          else
            print " #{num_bombs} "
          end
        end
      end
      puts
    end
    return nil
  end

  def print_user
    @tiles.each_with_index do |row, x_coord|
      row.each_with_index do |col, y_coord|
        tile = @tiles[x_coord][y_coord]
        if tile.revealed
          if tile.nearby_bombs == 0
            print " _ "
          else
            print " #{tile.nearby_bombs} "
          end
        else
          print " * "
        end
      end
      puts
    end
    return nil
  end
  
end
