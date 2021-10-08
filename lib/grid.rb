require 'cuboid'

class Grid
  attr_reader :x_max, :y_max, :z_max, :cuboids

  def initialize(params)
    @x_max, @y_max, @z_max = params
    @cuboids = []
  end

  def valid_move?(cuboid, coords)
    coords.each_with_index do |pos, idx|
      return false if pos < 0

      case idx
      when 0
        return false if (pos + cuboid.width) > x_max
      when 1
        return false if (pos + cuboid.height) > y_max
      when 2
        return false if (pos + cuboid.length) > z_max
      end

      true
    end
  end

  def get_cuboid(idx)
    @cuboids[idx]
  end

  def add_cuboid(origin, x_width, y_height, z_length)
    new_cuboid = Cuboid.new(origin, x_width, y_height, z_length)

    if cuboids.none? { |cuboid| cuboid.intersects?(new_cuboid) }
      cuboids.push(Cuboid.new(origin, x_width, y_height, z_length))
      return true
    end

    false
  end

  def remove_cuboid(idx)
    return false if idx >= cuboids.length

    cuboids.delete_at(idx)
  end

  def move_cuboid(index, coords)
    cuboid = cuboids[index]
    return false if cuboid.nil?

    valid_move?(cuboid, coords) ? cuboid.move_to!(*coords) : false
  end

  def rotate!(index, dir)
    cuboid = cuboids[index]
    x, y, z = cuboid.current_pos

    case dir
    when 'up'
      move_cuboid(index, [x, y + 10, z])
    when 'down'
      move_cuboid(index, [x, y - 10, z])
    when 'left'
      move_cuboid(index, [x - 10, y, z])
    when 'right'
      move_cuboid(index, [x + 10, y, z])
    when 'forward'
      move_cuboid(index, [x, y, z - 10])
    when 'backward'
      move_cuboid(index, [x, y, z + 10])
    end
  end

  private
  attr_writer :cuboids
end