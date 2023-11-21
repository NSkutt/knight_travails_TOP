# frozen_string_literal: true

require './knight_movement.rb'
# Creates the board of interconnected squares
class Board
  attr_accessor :locations
  attr_reader :coords

  def initialize
    @grid = {}
    build_board
    @locations = {}
  end

  def build_board(x_axis = 1, y_axis = 1)
    return nil unless (1..8).include?(x_axis) && (1..8).include?(y_axis)

    square = Node.new([x_axis, y_axis])
    @grid[square] = [x_axis, y_axis]
    connect_squares(square, :up, [x_axis, y_axis + 1])
    connect_squares(square, :u_r, [x_axis + 1, y_axis + 1])
    connect_squares(square, :right, [x_axis + 1, y_axis])
    connect_squares(square, :d_r, [x_axis + 1, y_axis - 1])
    connect_squares(square, :down, [x_axis, y_axis - 1])
    connect_squares(square, :d_l, [x_axis - 1, y_axis - 1])
    connect_squares(square, :left, [x_axis - 1, y_axis])
    connect_squares(square, :u_l, [x_axis - 1, y_axis + 1])
    square.object_id
  end

  def connect_squares(node, direction, coords)
    node.connections[direction] =
      if @grid.value?(coords)
        @grid.rassoc(coords).first.object_id
      else
        build_board(coords[0], coords[1])
      end
  end

  def places(piece, coords)
    @locations[piece] = coords
  end

  def make_knight(start_node, end_node)
    start_node.each do |coord|
      raise 'Invalid Coordinates!' unless (1..8).include?(coord)
    end
    end_node.each do |coord|
      raise 'Invalid Coordinates!' unless (1..8).include?(coord)
    end

    place = @grid.key(start_node)
    horse = Knight.new(place, end_node)
  end
end

# This will form the 'squares' or nodes
class Node
  attr_accessor :connections
  attr_reader :loc

  def initialize(coords)
    @loc = coords
    @connections = { up: nil, u_r: nil, right: nil, d_r: nil, down: nil, d_l: nil, left: nil, u_l: nil }
  end
end

test = Board.new

p test.make_knight([3, 3], [7, 7])
