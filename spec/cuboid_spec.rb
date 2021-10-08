require 'cuboid'

#This test is incomplete and, in fact, won't even run without errors.  
#  Do whatever you need to do to make it work and please add your own test cases for as many
#  methods as you feel need coverage
describe Cuboid do
  let (:newcube) { (Cuboid.new([0, 0, 0], 10, 10, 10)) }

  describe "Properly initializes a new Cuboid instance" do
    it "Sets the first argument to a local variable @origin" do
      expect(newcube.origin).to eq [0, 0, 0]
    end

    it "Sets the second argument to a local variable @width" do
      expect(newcube.width).to eq 10
    end

    it "Sets the third argument to a local variable @height" do
      expect(newcube.height).to eq 10
    end

    it "Sets the fourth argument to a local variable @length" do
      expect(newcube.length).to eq 10
    end
  end

  describe "#move_to" do

    context "Given valid coords" do
      before do 
        newcube.move_to!(30, 30, 30)
      end
  
      it "Should return true" do
        expect(newcube.move_to!(1,2,3)).to be true
      end
  
      it "Should move cube to new coords: [x, y, z]" do
        expect(newcube.current_pos).to eq [30, 30, 30]
      end
    end

    context "Given invalid coords" do
      before do
        newcube.move_to!(-20, 40, -20)
      end

      it "Should return false" do
        expect(newcube.move_to!(-20, 40, -20)).to be false
      end

      it "Should not move cube to new coords: [x, y, z]" do
        expect(newcube.current_pos).to eq [0, 0, 0]
      end
    end
  end    
  
  describe "#vertices" do
    let (:expected_vertices) {[
      [ 0,  0,  0],
      [ 0,  0, 10],
      [ 0, 10,  0],
      [10,  0,  0],
      [10, 10,  0],
      [ 0, 10, 10],
      [10,  0, 10],
      [10, 10, 10],
    ]}

    it "Returns (8) unique vertices of the cuboid in a 2D-array" do
      expect(newcube.vertices.is_a? Array).to be true
      expect(newcube.vertices.all? { |coord| coord.is_a? Array })
      expect(newcube.vertices.uniq.size).to eq 8
    end

    it "Returns the correct vertices" do 
      expect(newcube.vertices.all? { |coord| expected_vertices.include?(coord) }).to eq true
    end
  end
  
  describe "#intersects?" do
    let (:another_cube_1) { Cuboid.new([ 5,  5,  5], 10, 10, 10) }
    let (:another_cube_2) { Cuboid.new([ 5,  5, 15], 10, 10, 10) }
    let (:another_cube_3) { Cuboid.new([10, 10, 15], 10, 10, 10) }
    let (:another_cube_4) { Cuboid.new([50, 50, 50], 10, 10, 10) }

    context "If another Cuboid intersects with current Cuboid" do
      it "Should return true" do
        expect(newcube.intersects?(another_cube_1)).to be true
        expect(another_cube_3.intersects?(another_cube_2)).to be true
      end
    end

    context "If another Cuboid does not intersect with current Cuboid" do
      it "Should return false" do
        # expect(newcube.intersects?(another_cube_2)).to be false
        expect(another_cube_4.intersects?(another_cube_2)).to be false
      end
    end
  end
end
