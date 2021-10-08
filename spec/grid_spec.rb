require 'grid'
require 'cuboid'

describe Grid do
  let (:subject) { (Grid.new([150, 100, 200])) }

  describe "Properly initializes a new Grid instance" do
    it "Sets the first index of passed argument [x, y, z] as maximum parameters for x-axis" do
      expect(subject.x_max).to eq 150
    end

    it "Sets the second index of passed argument [x, y, z] as maximum parameters for y-axis" do
      expect(subject.y_max).to eq 100
    end

    it "Sets the third index of passed argument [x, y, z] as maximum parameters for z-axis" do
      expect(subject.z_max).to eq 200
    end

    it "Sets an instance variable @cuboids to an empty array" do
      expect(subject.cuboids).to eq []
    end
  end

  describe "#add_cuboid" do
    before do
      subject.add_cuboid([0, 0, 0], 10, 10, 10)
    end
    
    it "Should call Cuboid#intersects? to check if the new cuboid intersects with any existing cuboids" do
      expect(subject.cuboids[0]).to receive(:intersects?)
      subject.add_cuboid([20, 20, 20], 10, 10, 10)
    end

    context "Given valid coords" do
      it "Should instantialize a Cuboid before adding it to @cuboids array" do
        expect(subject.cuboids.all? { |cuboid| cuboid.is_a?(Cuboid) }).to be true
      end

      it "Should add a new cuboid to instance variable @cuboids array" do
        subject.add_cuboid([30, 30, 30], 10, 10, 10)
        expect(subject.cuboids.length).to eq 2
      end

      it "Should return true" do
        expect(subject.add_cuboid([30, 30, 30], 10, 10, 10)).to be true
      end
    end

    context "Given invalid coords" do
      before do
        subject.add_cuboid([0, 0, 0], 10, 10, 10)
      end

      it "Should not add a new cuboid to @cuboids array" do
        expect(subject.cuboids.length).to eq 1
      end

      it "Should return false" do
        expect(subject.add_cuboid([0, 0, 0], 10, 10, 10)).to be false
      end
    end
  end

  describe "#remove_cuboid" do
    before do
      subject.add_cuboid([0, 0, 0], 10, 10, 10)
      subject.add_cuboid([20, 20, 20], 10, 10, 10)
      subject.add_cuboid([40, 40, 40], 10, 10, 10)
    end

    it "Should remove cuboid from @cuboids array at given index" do
      subject.remove_cuboid(1)
      expect(subject.cuboids.none? { |cuboid| cuboid.origin == [20, 20, 20]}).to be true
    end
  end

  describe "#move_cuboid" do
    before do
      subject.add_cuboid([0, 0, 0], 10, 10, 10)
    end

    it "Should call Cuboid#intersects? to check if the move coords cause an intersection with an existing cuboid" do
      subject.add_cuboid([20, 20, 20], 10, 10, 10)
      expect(subject.cuboids[0]).to receive(:intersects?)
      subject.move_cuboid(0, [50, 50, 50])
    end

    it "Should return false if given coords are out of bounds within grid parameters" do
      expect(subject.move_cuboid(0, [-10, 0, 0])).to be false
      expect(subject.move_cuboid(0, [160, 0, 0])).to be false
    end

    it "Should return false if given index does not exist in @cuboids array" do
      expect(subject.move_cuboid(2, [15, 15, 15])).to be false
    end

    context "Given valid move coords" do
      it "Should return true" do
        expect(subject.move_cuboid(0, [140, 0, 0])).to be true
      end
    end

    context "Given invalid move coords" do
      it "Should return false" do
        expect(subject.move_cuboid(0, [145, 0, 0])).to be false
      end
    end
  end
end