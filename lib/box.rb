require 'cuboid'

class Box

  #BEGIN public methods

  # Set attr_reader to access instance variables
  attr_reader :x_max, :y_max, :z_max, :cuboids

  # Instantialize a Box with:
    # [x, y, z] integers (params) to set max parameters for each axis
    # an empty array of cuboids to keep track of all cuboids placed inside the Box params
  def initialize(params)
    @x_max, @y_max, @z_max = params
    @cuboids = []
  end

  # Helper method that receives a Cuboid instance and [x, y, z] coordinates
  # Creates a new Cuboid at new coordinates and check to ensure no intersections
  # Checks if coordinates on each axis are within the bounds of the Box params
  # A cuboid can have unique width(x), height(y), and length(z)
  def valid_move?(cuboid, coords)
    newcube = Cuboid.new(coords, cuboid.width, cuboid.height, cuboid.length)

    if cuboids.none? { |cube| cube.intersects?(newcube) }
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
      true
    else
      false
    end
  end

  # Helper method that returns a Cuboid instance at given index
  def get_cuboid(idx)
    cuboids[idx]
  end

  # Checks if a new Cuboid can be added to the box at given origin coordinates, 
  # also taking into account unique width(x), height(y), length(z)
    # If true
      # Push the new Cuboid instance to @cuboids array
      # Return true
    # Else
      # Return false
  def add_cuboid(origin, x_width, y_height, z_length)
    new_cuboid = Cuboid.new(origin, x_width, y_height, z_length)

    if cuboids.none? { |cuboid| cuboid.intersects?(new_cuboid) }
      cuboids.push(Cuboid.new(origin, x_width, y_height, z_length))
      return true
    end

    false
  end

  # Edge case: return false if cuboid does not exist
  # Delete a Cuboid at given index
  def remove_cuboid(idx)
    return false if cuboids[idx].nil?

    cuboids.delete_at(idx)
  end

  # Edge case: return false if cuboid does not exist
  # Calls helper method #valid_move? to check if move is within Box params && does not intersect
    # If true
      # Calls Cuboid#move_to! with given coordinates
      # Return true
    # Else
      # Return false
  def move_cuboid(index, coords)
    cuboid = get_cuboid(index)
    return false if cuboid.nil?

    valid_move?(cuboid, coords) ? cuboid.move_to!(*coords) : false
  end

  # Receives 2 arguments.  1) index of Cuboid you want to move  2) direction of movement
  # Manipulates [x, y, z] coordinate with respect to the cuboid's dimensions
  # Calls helper method Grid#move_cuboid which will check #valid_move? and return true/false
  def rotate!(index, dir)
    cuboid = get_cuboid(index)
    x, y, z = cuboid.current_pos

    case dir
    when 'up'
      move_cuboid(index, [x, y + cuboid.height, z])
    when 'down'
      move_cuboid(index, [x, y - cuboid.height, z])
    when 'left'
      move_cuboid(index, [x - cuboid.width, y, z])
    when 'right'
      move_cuboid(index, [x + cuboid.width, y, z])
    when 'forward'
      move_cuboid(index, [x, y, z - cuboid.length])
    when 'backward'
      move_cuboid(index, [x, y, z + cuboid.length])
    else
      raise StandardError.new("Not a valid direction")
    end
  end

  #END public methods

  #START private methods

  # Private attr_writer to restrict instance variable manupulation to within class definition
  private
  attr_writer :cuboids

  #END private methods
  
end