# frozen_string_literal: true

require './knight_travails.rb'

# moves the knight and tracks its location
class Knight
  attr_reader :position

  def initiate(coords)
    @position = coords
  end

  def movement(end_point, cur_square= @coords)

  end
end
