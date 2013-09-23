require 'debugger'
class Tile
  attr_accessor :has_bomb, :board, :coord
  
  def explore
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
  
end

