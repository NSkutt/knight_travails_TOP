# frozen_string_literal: true

# The game board to play on
class Board
  attr_reader :coords

  def initialize
    @grid = {}
    build_board
  end

  def build_board(coords = [1, 1])
    return nil unless (1..8).include?(coords[0]) && (1..8).include?(coords[1])

    n = Node.new(coords)
    @grid[n] = coords
    n.up = @grid.value?([coords[0], coords[1] + 1]) ? @grid.rassoc([coords[0], coords[1] + 1]) : build_board([coords[0], coords[1] + 1])
    n.down = @grid.value?([coords[0], coords[1] - 1]) ? @grid.rassoc([coords[0], coords[1] - 1]) : build_board([coords[0], coords[1] - 1])
    n.left = @grid.value?([coords[0] - 1, coords[1]]) ? @grid.rassoc([coords[0] - 1, coords[1]]) : build_board([coords[0] - 1, coords[1]])
    n.right = @grid.value?([coords[0] + 1, coords[1]]) ? @grid.rassoc([coords[0] + 1, coords[1]]) : build_board([coords[0] + 1, coords[1]])
  end

  def piece_positions(piece, pos)
    @locations[piece] = pos
  end

  def occupied?(coords)
    @locations.key?(coords)
  end
end

# This will form the 'squares' or nodes
class Node
  attr_accessor :up, :down, :left, :right
  attr_reader :square

  def initialize(coords)
    @square = coords
    @up = nil
    @down = nil
    @left = nil
    @right = nil
  end
end

test = Board.new
