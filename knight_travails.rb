# frozen_string_literal: true

# The game board to play on
class Board
  attr_reader :coords

  def initialize
    rankandfile = (1..8).to_a
    @coords = []
    rankandfile.repeated_permutation(2) { |perm| board.push(perm) }
  end
end
