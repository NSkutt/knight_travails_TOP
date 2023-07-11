# frozen_string_literal: true



# moves the knight and tracks its location
class Knight
  attr_reader :position

  def initialize(coords)
    @position = coords
    @possibilities = { nnw: nil, nne: nil, ene: nil, ese: nil, sse: nil, ssw: nil, wsw: nil, wnw: nil }
    move_tree
  end

  def move_tree
    @possibilities.each_key do |direction|
      current = @position.connections
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
        current = ObjectSpace._id2ref(current).connections unless i == 2
        i += 1
      end
      @possibilities[direction] = current
    end
  end

  def movement(place, dir)
    ObjectSpace._id2ref(place.connections[dir])
  end
end
