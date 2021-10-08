require 'cuboid'

class Grid
  attr_reader :x_max, :y_max, :z_max, :cuboids

  def initialize(params)
    @x_max, @y_max, @z_max = params
    @cuboids = []
  end

  def add_cuboid(origin, x_width, y_height, z_length)
    new_cuboid = Cuboid.new(origin, x_width, y_height, z_length)

    if cuboids.none? { |cuboid| cuboid.intersects?(new_cuboid) }
      @cuboids.push(Cuboid.new(origin, x_width, y_height, z_length))
      return true
    end

    false
  end

  def remove_cuboid(idx)
    
  end

  def move_cuboid(idx, coords)

  end

  private
  attr_writer :cuboids
end