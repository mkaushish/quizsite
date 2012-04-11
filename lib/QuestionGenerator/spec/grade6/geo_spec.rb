require_relative '../../grade6/geo.rb'

describe "Geometry: " do
  describe "Bisect Line: " do
    before :each do
      @blQuestion = Geo::BisectLine.new()
      @blQuestion.x1 = 5
      @blQuestion.y1 = 5
      @blQuestion.x2 = 150
      @blQuestion.y2 = 150
    end

    it "getMatchingCircles should return all pairs of circles which could be used to bisext the line" do
      shapes = [
        Circle.new(3  ,5  ,123),
        Circle.new(150,150,128),
        Circle.new(4  ,3  ,123),
        Circle.new(5  ,5  ,123),
        Circle.new(4  ,3  ,123),
        Circle.new(150,150,123),
        Circle.new(5  ,5  ,128),
        Circle.new(150,150,10 ),
        Circle.new(5  ,5  ,10 )
      ]
      
      matchingCircs = [
        [ Circle.new(5  ,5  ,128), Circle.new(150,150,128) ],
        [ Circle.new(5  ,5  ,123), Circle.new(150,150,123) ]
      ]

      blqcircs = @blQuestion.getMatchingCircles(shapes)

      if blqcircs[0] == matchingCircs[0]
        blqcircs[1].should == matchingCircs[1]
      else
        blqcircs[1].should == matchingCircs[0]
        blqcircs[0].should == matchingCircs[1]
      end
    end

    describe "correct?: " do
      before :each do
        @c1 = Circle.new(5,5,125)
        @c2 = Circle.new(150,150,125)
        @c3 = Circle.new(150,150,126)
        @intpoints = Geometry::intCircleCircle(@c1, @c2)
        @l1 = Line.new(*@intpoints)
        @l2 = Line.new(5,23,53,56)
        @param_key = GeometryField.new().name
      end

      it "correct? should only be true if shapes contains a circle on each segment end and a line between their intersection points" do
        @blQuestion.correct?({@param_key => Shape.encode_a( [ @c1, @c2, @l1 ] ) }).should be_true
        @blQuestion.correct?({@param_key => Shape.encode_a( [ @c1, @c2, @l2 ] ) }).should_not be_true
        @blQuestion.correct?({@param_key => Shape.encode_a( [ @c3, @c1, @l1 ] ) }).should_not be_true
        @blQuestion.correct?({@param_key => Shape.encode_a( [ @l1, @c2, @c1 ] ) }).should be_true
        @blQuestion.correct?({@param_key => Shape.encode_a( [ @c1, @c2, @c3, @l1, @l2 ] ) }).should be_true
      end

      it "correct? should accept a line within 3 eucldean pixels of the circles intersection points" do
        l = Line.new(@intpoints[0].x + 2, @intpoints[0].y - 2,
                     @intpoints[1].x - 2, @intpoints[1].y - 2)
        @blQuestion.correct?({@param_key => Shape.encode_a( [ @c1, @c2, l ] ) }).should be_true

        l = Line.new(@intpoints[0].x + 3, @intpoints[0].y - 3,
                     @intpoints[1].x - 3, @intpoints[1].y - 3)
        @blQuestion.correct?({@param_key => Shape.encode_a( [ @c1, @c2, l ] ) }).should_not be_true
      end

      it "correct? should accept a line segment going either direction" do
        l = Line.new(@l1.x2, @l1.y2, @l1.x1, @l1.y1)
        @blQuestion.correct?({@param_key => Shape.encode_a( [ @c1, @c2, l ] ) }).should be_true
      end
    end

    it "solve should return a correct? answer" do
      bl = Geo::BisectLine.new()
      bl.correct?(bl.prefix_solve).should be_true
    end
  end
end
