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