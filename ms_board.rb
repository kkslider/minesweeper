require './ms_tile.rb'

class Board
  attr_reader :size, :tiles, :game_lost, :bomb_tiles
  attr_accessor :flags_left
  
  def initialize(size=9, bombs=10)
    @tiles = Array.new(size) {Array.new(size) {Tile.new(self)}}
    @size = size
    @bomb_tiles = []
    @flags_left = bombs
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
        @bomb_tiles << @tiles[x][y]
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
  
  def game_over?
    return true if @bomb_tiles.all? { |tile| tile.flagged }
    return true if @tiles.all? { |row| row.all? { |tile| tile.revealed || tile.has_bomb } }
  end
  
  def print_full
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
          if tile.has_bomb
            print " X "
          elsif tile.nearby_bombs == 0
            print " _ "
          else
            print " #{tile.nearby_bombs} "
          end
        else
          if tile.flagged
            print " F "
          else
            print " * "
          end
        end
      end
      puts
    end
    return nil
  end  
end
