require 'cuboid'

#This test is incomplete and, in fact, won't even run without errors.  
#  Do whatever you need to do to make it work and please add your own test cases for as many
#  methods as you feel need coverage
describe Cuboid do
  let (:subject) { (Cuboid.new([0, 0, 0], 10, 10, 10)) }

  describe "#initialize" do
    it "Sets the first argument to a instance variable @origin" do
      expect(subject.origin).to eq [0, 0, 0]
    end

    it "Sets the second argument to a instance variable @width" do
      expect(subject.width).to eq 10
    end

    it "Sets the third argument to a instance variable @height" do
      expect(subject.height).to eq 10
    end

    it "Sets the fourth argument to a instance variable @length" do
      expect(subject.length).to eq 10
    end
  end

  describe "#move_to" do

    context "Given valid coords" do
      before do 
        subject.move_to!(30, 30, 30)
      end
  
      it "Should return true" do
        expect(subject.move_to!(1,2,3)).to be true
      end
  
      it "Should move cube to new coords: [x, y, z]" do
        expect(subject.current_pos).to eq [30, 30, 30]
      end
    end

    context "Given invalid coords" do
      before do
        subject.move_to!(-20, 40, -20)
      end

      it "Should return false" do
        expect(subject.move_to!(-20, 40, -20)).to be false
      end

      it "Should not move cube to new coords: [x, y, z]" do
        expect(subject.current_pos).to eq [0, 0, 0]
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
      expect(subject.vertices.is_a? Array).to be true
      expect(subject.vertices.all? { |coord| coord.is_a? Array })
      expect(subject.vertices.uniq.size).to eq 8
    end

    it "Returns the correct vertices" do 
      expect(subject.vertices.all? { |coord| expected_vertices.include?(coord) }).to eq true
    end
  end
  
  describe "#intersects?" do
    let (:another_cube_1) { Cuboid.new([ 5,  5,  5], 10, 10, 10) }
    let (:another_cube_2) { Cuboid.new([ 5,  5, 15], 10, 10, 10) }
    let (:another_cube_3) { Cuboid.new([10, 10, 10], 10, 10, 10) }
    let (:another_cube_4) { Cuboid.new([50, 50, 50], 10, 10, 10) }
    let (:another_cube_5) { Cuboid.new([45, 45, 45], 10, 10, 10) }
    let (:another_cube_6) { Cuboid.new([ 0,  0,  0], 80, 80, 80) }
    let (:another_cube_7) { Cuboid.new([80, 80, 80], 15, 15, 15) }

    context "If another Cuboid intersects with current Cuboid" do
      it "Should return true" do
        expect(subject.intersects?(another_cube_1)).to be true
        expect(another_cube_3.intersects?(another_cube_2)).to be true
        expect(another_cube_6.intersects?(another_cube_2)).to be true
        expect(another_cube_6.intersects?(another_cube_4)).to be true
        expect(another_cube_6.intersects?(another_cube_1)).to be true
      end
    end

    context "If another Cuboid does not intersect with current Cuboid" do
      it "Should return false" do
        expect(subject.intersects?(another_cube_4)).to be false
        expect(subject.intersects?(another_cube_5)).to be false
        expect(subject.intersects?(another_cube_3)).to be false
        expect(another_cube_4.intersects?(another_cube_2)).to be false
        expect(another_cube_7.intersects?(another_cube_6)).to be false
      end
    end
  end
end
