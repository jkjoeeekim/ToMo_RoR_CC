require 'box'
require 'cuboid'

describe Box do
  let (:subject) { (Box.new([150, 100, 200])) }

  describe "Properly initializes a new Box instance" do
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

  describe "#get_cuboid" do
    before do
      subject.add_cuboid([0, 0, 0], 10, 10, 10)
      subject.add_cuboid([20, 20, 20], 10, 10, 10)
    end

    it "Should return a Cuboid instance at given index of @cuboids array" do
      expect(subject.get_cuboid(1).is_a? Cuboid).to be true
      expect(subject.get_cuboid(1).origin).to eq [20, 20, 20]
    end
  end

  describe "#add_cuboid" do
    before do
      subject.add_cuboid([0, 0, 0], 10, 10, 10)
    end
    
    it "Should call Cuboid#intersects? to check if the new cuboid intersects with any existing cuboids" do
      expect(subject.cuboids.first).to receive(:intersects?)
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

    it "Should return false if cuboid does not exist at given index" do
      expect(subject.remove_cuboid(4)).to be false
    end
  end

  describe "#move_cuboid" do
    before do
      subject.add_cuboid([0, 0, 0], 10, 10, 10)
    end
    
    it "Should call Cuboid#move_to!" do
      subject.add_cuboid([20, 20, 20], 10, 10, 10)
      expect(subject.cuboids.first).to receive(:move_to!)
      subject.move_cuboid(0, [50, 50, 50])
    end

    it "Should return false if given coords are out of bounds within Box parameters" do
      expect(subject.move_cuboid(0, [-10, 0, 0])).to be false
      expect(subject.move_cuboid(0, [160, 0, 0])).to be false
    end

    it "Should return false if given index does not exist in @cuboids array" do
      expect(subject.move_cuboid(2, [15, 15, 15])).to be false
    end

    context "Given valid move coords" do
      it "Should move the current_pos of a cuboid at given index to specified coordinates" do
        subject.move_cuboid(0, [50, 50, 50])
        expect(subject.cuboids.first.current_pos).to eq [50, 50, 50]
      end

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
  
  describe "#rotate!" do
    it "Should take in 2 arguments: an index to grab a Cuboid instance, and a direction as a String" do
      expect {subject.rotate!(0, 'up', 'down')}.to raise_error(ArgumentError)
      expect {subject.rotate!(0)}.to raise_error(ArgumentError)
    end

    context "When direction is 'up'" do
      context "If move is possible" do
        before do
          subject.add_cuboid([0, 0, 0], 10, 10, 10)
        end

        it "Should change @current_pos[1] (y-axis value) of specified Cuboid instance by the height of the instance" do
          subject.rotate!(0, 'up')
          expect(subject.cuboids.first.current_pos[1]).to eq 10
        end

        it "Should return true" do
          expect(subject.rotate!(0, 'up')).to be true
        end
      end

      context "If move is not possible" do
        it "Should return false" do
          subject.add_cuboid([0, 90, 0], 10, 10, 10)
          expect(subject.rotate!(0, 'up')).to be false
        end
      end
    end

    context "When direction is 'down'" do      
      context "If move is possible" do
        before do
          subject.add_cuboid([0, 10, 0], 10, 10, 10)
        end
        
        it "Should change @current_pos[1] (y-axis value) of specified Cuboid instance by the height of the instance" do
          subject.rotate!(0, 'down')
          expect(subject.cuboids.first.current_pos[1]).to eq 0
        end

        it "Should return true" do
          expect(subject.rotate!(0, 'down')).to be true
        end
      end

      context "If move is not possible" do
        it "Should return false" do
          subject.add_cuboid([0, 0, 0], 10, 10, 10)
          expect(subject.rotate!(0, 'down')).to be false
        end
      end
    end

    context "When direction is 'left'" do
      context "If move is possible" do
        before do
          subject.add_cuboid([10, 0, 0], 10, 10, 10)
        end

        it "Should change @current_pos[0] (x-axis value) of specified Cuboid instance by the width of the instance" do
          subject.rotate!(0, 'left')
          expect(subject.cuboids.first.current_pos[0]).to eq 0
        end

        it "Should return true" do
          expect(subject.rotate!(0, 'left')).to be true
        end
      end

      context "If move is not possible" do
        it "Should return false" do
          subject.add_cuboid([0, 0, 0], 10, 10, 10)
          expect(subject.rotate!(0, 'left')).to be false
        end
      end
    end

    context "When direction is 'right'" do
      context "If move is possible" do
        before do
          subject.add_cuboid([0, 0, 0], 10, 10, 10)
        end

        it "Should change @current_pos[0] (x-axis value) of specified Cuboid instance by the width of the instance" do
          subject.rotate!(0, 'right')
          expect(subject.cuboids.first.current_pos[0]).to eq 10
        end
        
        it "Should return true" do
          expect(subject.rotate!(0, 'right')).to be true
        end
      end

      context "If move is not possible" do
        it "Should return false" do
          subject.add_cuboid([140, 0, 0], 10, 10, 10)
          expect(subject.rotate!(0, 'right')).to be false
        end
      end
    end

    context "When direction is 'forward'" do
      context "If move is possible" do
        before do
          subject.add_cuboid([0, 0, 10], 10, 10, 10)
        end

        it "Should change @current_pos[2] (z-axis value) of specified Cuboid instance by the length of the instance" do
          subject.rotate!(0, 'forward')
          expect(subject.cuboids.first.current_pos[2]).to eq 0
          expect(subject.cuboids.length).to eq 1
        end

        it "Should return true" do
          expect(subject.rotate!(0, 'forward')).to be true
        end
      end

      context "If move is not possible" do
        it "Should return false" do
          subject.add_cuboid([0, 0, 0], 10, 10, 10)
          expect(subject.rotate!(0, 'forward')).to be false
        end
      end
    end

    context "When direction is 'backward'" do
      context "If move is possible" do
        before do
          subject.add_cuboid([0, 0, 0], 10, 10, 10)
        end

        it "Should change @current_pos[2] (z-axis value) of specified Cuboid instance by the length of the instance" do
          subject.rotate!(0, 'backward')
          expect(subject.cuboids.first.current_pos[2]).to eq 10
        end

        it "Should return true" do
          expect(subject.rotate!(0, 'backward')).to be true
        end
      end

      context "If move is not possible" do
        it "Should return false" do
          subject.add_cuboid([0, 0, 190], 10, 10, 10)
          expect(subject.rotate!(0, 'backward')).to be false
        end
      end
    end

    context "When direction is invalid" do
      it "Should raise error 'Not a valid direction'" do
        subject.add_cuboid([0, 0, 0], 10, 10, 10)
        expect {subject.rotate!(0, 'frontwards')}.to raise_error("Not a valid direction")
      end
    end
  end
end