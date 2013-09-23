class Tile
  attr_accessor :has_bomb
  
  def explore
  end
  
  def neighbors
  end
  
  def initialize
  end
end

class Board
  attr_reader :size
  
  def initialize(size=9, bombs=10)
    @tiles = Array.new(size) {Array.new(size) {Tile.new}}
    @size = size
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
  
end

