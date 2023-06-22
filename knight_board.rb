# frozen_string_literal: true

class Board
  attr_reader :coords

  def initialize
    @grid = {}
    build_board
  end

end

# This will form the 'squares' or nodes
class Node
  attr_accessor :x
  attr_reader :square

  def initialize(coords)

  end
end

test = Board.new
