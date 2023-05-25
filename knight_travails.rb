# frozen_string_literal: true

# The game board to play on
class Board
  attr_reader :coords

  def initialize
    @grid = build_board
    p @grid
  end

  def build_board(coords = [0, 0])
    n = Node.new(coords)
    n.files[0] = build_board([coords[0] + 1, coords]) while coords[0] < 8
    n.files[1] = build_board([coords[0] - 1, coords]) while coords[0] > 1
    n.ranks[0] = build_board([coords, coords[1] + 1]) while coords[1] < 8
    n.ranks[1] = build_board([coords, coords[1] - 1]) while coords[1] > 1
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
  attr_reader :square
  attr_writer :ranks, :files

  def initialize(coords)
    @square = coords
    @ranks = [nil, nil]
    @files = [nil, nil]
  end
end

test = Board.new
