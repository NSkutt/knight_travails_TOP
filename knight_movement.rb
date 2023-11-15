# frozen_string_literal: true

# moves the knight and tracks its location
class Knight
  attr_reader :position, :moves

  def initialize(coords)
    @position = coords
    @moves = []
    @home = KnightNode.new(@position)
    tree_builder(@home)
  end

  def tree_builder(place)
    p ["--#{place.object_id}--", place.square.loc]
    place.possibilities.each_key do |direction|
      coords = find_square(place, direction)
      next if coords.nil?

      exists = search_tree(coords)
      place.possibilities[direction] = exists || fill_in(coords)
    end
    populate(place)
    next_node = @moves.shift
    tree_builder(next_node) unless filled_in(next_node)
  end

  def fill_in(node)
    explore = KnightNode.new(node)
    # tree_builder(explore) CANNOT RECUR HERE, INFINITE LOOP
    explore.object_id
  end

  def populate(paths)
    paths.possibilities.each_value do |n_id|
      next if n_id.nil?

      futures = ObjectSpace._id2ref(n_id)
      @moves.push(futures)
    end
  end

  def filled_in(node)
    bool = ''
    node.possibilities.each do |check|
      return bool = true unless check.last.nil?

      bool = false
    end
    bool
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
    GC.disable
    return cur.object_id if destination.loc == cur.square.loc

    result = 'x'
    cur.possibilities.each do |new_square|
      return false if new_square.last.nil?

      coord = ObjectSpace._id2ref(new_square.last).square.loc
      return false if prev.include?(coord)

      result = search_tree(destination, ObjectSpace._id2ref(new_square.last), prev.push(cur.square.loc))
    end
    GC.enable
    result
  end

  def movement(place, dir)
    ObjectSpace._id2ref(place.connections[dir])
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
