
class Cuboid
  
  #BEGIN public methods that should be your starting point

  # Set attr_reader to access instance variables
  attr_reader :origin, :height, :width, :length, :current_pos

  # Instantialize an instance of Cuboid with:
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
  
  #returns true if the two cuboids intersect each other.  False otherwise.
  def intersects?(other)
    cube_x_start, cube_x_end = x_axis_coords
    cube_y_start, cube_y_end = y_axis_coords
    cube_z_start, cube_z_end = z_axis_coords

    other_x_start, other_x_end = other.x_axis_coords
    other_y_start, other_y_end = other.y_axis_coords
    other_z_start, other_z_end = other.z_axis_coords

    cube_x_end > other_x_start && cube_y_end > other_y_start && cube_z_end > other_z_start
  end

  #END public methods that should be your starting point  
  private
  attr_writer :current_pos
end