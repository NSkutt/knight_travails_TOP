# frozen_string_literal: true

# moves the knight and tracks its location
class Knight
  attr_reader :position, :moves

  def initialize(start, finish)
    @position = start
    @endpoint = finish
    @moves = []
    @home = KnightNode.new(@position)
    tree_builder(@home)
    p find_path
  end

  def tree_builder(place)
    place.possibilities.each_key do |direction|
      coords = find_square(place, direction)
      next if coords.nil?

      exists = search_tree(coords)
      place.possibilities[direction] = exists || fill_in(coords)
      break if exists && end_loop(exists)
    end
    next_node = @moves.shift
    tree_builder(next_node) unless next_node.nil?
  end

  def fill_in(node)
    explore = KnightNode.new(node)
    @moves.push(explore)
    explore.object_id
  end

  def end_loop(location)
    coord_set = ObjectSpace._id2ref(location).square.loc
    if coord_set == @endpoint
      @moves.clear
      true
    else
      false
    end
  end

  def find_square(place, direction)
    current = place.square.connections
    i = 0
    while i < 3
      moving = direction[i]
      case moving
      when 'n'
        current = current[:up]
      when 'e'
        current = current[:right]
      when 's'
        current = current[:down]
      when 'w'
        current = current[:left]
      end
      return nil if current.nil?

      current = ObjectSpace._id2ref(current).connections unless i == 2
      i += 1
    end
    ObjectSpace._id2ref(current)
  end

  def search_tree(destination, cur = @home, prev = [])
    return cur.object_id if destination.loc == cur.square.loc

    result = false
    cur.possibilities.each do |new_square|
      next if new_square.last.nil?

      coord = ObjectSpace._id2ref(new_square.last).square.loc
      next if prev.include?(coord)

      result = search_tree(destination, ObjectSpace._id2ref(new_square.last), prev.push(cur.square.loc)) || result
    end
    result
  end

  def find_path(cur = @home, the_path_back = [], the_path_forward = [])
    the_path_back.push(cur.square.loc)
    return the_path_back if @endpoint == cur.square.loc

    cur.possibilities.each do |new_square|
      next if new_square.last.nil?

      coord = ObjectSpace._id2ref(new_square.last).square.loc
      next if the_path_back.include?(coord) || the_path_forward.to_s.include?(coord.to_s)

      the_path_forward.push(ObjectSpace._id2ref(new_square.last))
    end
    next_square = the_path_forward.shift
    find_path(next_square, the_path_back, the_path_forward)
  end
end

# allows building of the knights board
class KnightNode
  attr_accessor :possibilities
  attr_reader :square

  def initialize(square_node)
    @square = square_node
    @possibilities = { nnw: nil, nne: nil, ene: nil, ese: nil, sse: nil, ssw: nil, wsw: nil, wnw: nil }
  end
end
