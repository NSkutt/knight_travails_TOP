# frozen_string_literal: true

# moves the knight and tracks its location
class Knight
  attr_reader :position

  def initialize(coords)
    @position = coords
    @home = KnightNode.new(@position)
    move_tree(@home)
    build_tree(@home)
  end

  def move_tree(place)
    place.possibilities.each_key do |direction|
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
      place.possibilities[direction] = current
    end
  end

  def build_tree(place)
    p 'test'
    place.possibilities.each_value do |square|
      p square
      p ObjectSpace._id2ref(square).loc
      xy = ObjectSpace._id2ref(square).loc
      exists = search_tree(xy)

    end
  end

  def search_tree(destination, cur = @home)
    return cur if destination == cur.square
    return false unless cur.possibilities

    cur.possibilities.each do |new_square|
      search_tree(destination, ObjectSpace._id2ref(new_square.last))
    end
  end


  def movement(place, dir)
    ObjectSpace._id2ref(place.connections[dir])
  end
end

# allows building of the knights board
class KnightNode
  attr_accessor :possibilities
  attr_reader :square

  def initialize(coords)
    @square = coords
    @possibilities = { nnw: nil, nne: nil, ene: nil, ese: nil, sse: nil, ssw: nil, wsw: nil, wnw: nil }
  end
end
