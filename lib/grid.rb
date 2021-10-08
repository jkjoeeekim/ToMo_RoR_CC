require 'cuboid'

class Grid
  attr_reader :x_max, :y_max, :z_max, :cuboids

  def initialize(params)
    @x_max, @y_max, @z_max = params
    @cuboids = []
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

  def move_cuboid(idx, coords)
    cuboid = cuboids[idx]
    return false if cuboid.nil?

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
    end

    cuboid.move_to!(*coords)
  end

  private
  attr_writer :cuboids
end