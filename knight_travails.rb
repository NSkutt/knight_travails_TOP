# frozen_string_literal: true

# The game board to play on
class Board
  attr_reader :coords

  def initialize(places)
    rankandfile = (1..8).to_a
    @coords = []
    @locations = {}
    rankandfile.repeated_permutation(2) { |perm| board.push(perm) }
    places.each { |piece| @locations[piece[0]] = piece[1] }
  end

  def piece_positions(piece, pos)
    @locations[piece] = pos
  end

  def occupied?(coords)
    @locations.key?(coords)
  end
end
