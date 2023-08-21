# frozen_string_literal: true

# moves the knight and tracks its location
class Knight
  attr_reader :position

  def initialize(coords)
    @position = coords
    @moves = []
    @home = KnightNode.new(@position)
    tree_builder(@home)
  end

  def tree_builder(place)
    p "xxx #{place.square.loc} xxx"
    place.possibilities.each_key do |direction|
      coords = find_square(place, direction)
      next if coords.nil?

      exists = search_tree(coords)
      p "ex: #{exists}"
      place.possibilities[direction] = exists || KnightNode.new(coords).object_id
    end
    @moves.push(place)
    recur(@moves.last)
  end

  # Will need to pass ObjSpac.id2ref of KnightNode.possibility[direction] to tree_builder
  def recur(k_node)
    p "kn: #{k_node.possibilities}"
    k_node.possibilities.each do |_dir, id|
      next_node = ObjectSpace._id2ref(id)
      coords = next_node.square.loc
      valid = coords.first.between?(1, 8) && coords.last.between?(1, 8)
      tree_builder(next_node) while valid
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

  def search_tree(destination, cur = @home)
    return cur if destination == cur.square.loc

    result = 'x'
    cur.possibilities.each do |new_square|
      return false if new_square.last.nil?

      result = search_tree(destination, ObjectSpace._id2ref(new_square.last))
    end
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
