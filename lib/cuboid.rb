require 'byebug'

class Cuboid
  
  #BEGIN public methods

  # Set attr_reader to access instance variables
  attr_reader :origin, :height, :width, :length, :current_pos

  # Instantialize a Cuboid with:
    # origin: to set starting point [x, y, z], 
    # width: to track x-axis width, 
    # height: to track y-axis height, 
    # length: to track z-axis length,
    # current_pos: to track cuboid position as it moves around.
  def initialize(origin, x_width, y_height, z_length)
    @origin = origin
    @width = x_width
    @height = y_height
    @length = z_length
    @current_pos ||= origin
  end

  def change_length(new_length)
    length = new_length
  end

  def change_width(new_width)
    width = new_width
  end

  def change_height(new_height)
    height = new_height
  end

  # Returns an array containing x-axis coordinates [(current_pos[x]), (current_pos[x] + width)]
  def x_axis_coords
    current_x_coord = self.current_pos[0]
    [current_x_coord, (current_x_coord + self.width)]
  end

  # Returns an array containing y-axis coordinates [(current_pos[y]), (current_pos[y] + height)]
  def y_axis_coords
    current_y_coord = self.current_pos[1]
    [current_y_coord, (current_y_coord + self.height)]
  end

  # Returns an array containing z-axis coordinates [(current_pos[z]), (current_pos[z] + length)]
  def z_axis_coords
    current_z_coord = self.current_pos[2]
    [current_z_coord, (current_z_coord + self.length)]
  end

  # Checks to see if start --> end of cube_1 includes any of the positions in cube_2
  # Edge case return true if cube_1 and cube_2 are at the same spot. ie: [0, 10] == [0, 10] 
  def is_between?(cube_1, cube_2)
    cube_1_start, cube_1_end = cube_1
    cube_2_start, cube_2_end = cube_2
    return true if cube_1 == cube_2

    # EDIT HERE FOR ALL TEST CASES
    # [20, 30] [0, 40]
    cube_2.any? { |pos| ((cube_1_start + 1)...cube_1_end).to_a.include?(pos) } || cube_1.any? { |pos| ((cube_2_start + 1)...cube_2_end).to_a.include?(pos) }
  end

  # Checks if given coordinates are positive integers (assuming negative values are not allowed && grid stretches to positive infinity)
   # If true  => change the current_pos of self to new coords && return true
   # If false => do not change current_pos && return false
  def move_to!(x, y, z)
    if [x, y, z].none? { |pos| pos < 0 }
      @current_pos = [x, y, z]
      true
    else
      false
    end
  end

  # Uses helper methods defined above to create an array on vertices containing the coordinates of each corner of the Cuboid this instance method was called on
  def vertices
    vertices = [];

    x_axis_coords.each do |x_coord| 
      y_axis_coords.each do |y_coord|
        z_axis_coords.each do |z_coord|
          vertices.push([x_coord, y_coord, z_coord])
        end
      end
    end

    vertices
  end
  
  # Iterates through the coordinates of each plane(x, y ,z)
    # Passes each plane of 'self' with corresponding plane of 'other' to helper method #is_between?
    # If #is_between? returns false at any time, return false
    # Else continue execution and implicit return true
  def intersects?(other)
    cube_1_all_coords = [x_axis_coords, y_axis_coords, z_axis_coords]
    cube_2_all_coords = [other.x_axis_coords, other.y_axis_coords, other.z_axis_coords]

    cube_1_all_coords.each_with_index do |coord_1, idx|
      coord_2 = cube_2_all_coords[idx]

      if !is_between?(coord_1, coord_2)
        return false
      end
    end

    true
  end

  #END public methods

  #START private methods
  
  # Private attr_writer to restrict instance variable manupulation to within class definition
  private
  attr_writer :current_pos 

  #END private methods

end