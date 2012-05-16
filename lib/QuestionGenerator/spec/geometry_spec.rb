require_relative '../geometry.rb'

include Geometry

describe "Geometry: " do
  describe "GeometryField: " do
    before :each do
      @shapes = [ Line.new(20,30,40,50), Circle.new(100,200,20) ]
      @encoded_shapes = "line:20:30:40:50,circle:100:200:20"
      @gf = GeometryField.new(*@shapes)
      @response = { ToHTML::add_prefix("geometry") => @encoded_shapes }
    end

    it "should ALWAYS be named geometry" do
      @gf.name.should == ToHTML::add_prefix("geometry");
    end

    it "should encode shapes with encodedStartShapes" do
      @gf.encodedStartShapes.gsub(/\.0+\b/, '').should == @encoded_shapes
    end

    it "should decode response shapes with shapesFromResponse" do
      GeometryField.shapesFromResponse(@response).should == @shapes
    end
  end

  describe "Shapes: " do
    describe "Circle: " do
      before :each do
        @circle = Circle.new(1,2,3)
      end

      it "should have a working ==" do
        @circle.should_not == Circle.new(1,2,4)
        @circle.should == Circle.new(1,2,3)
        @circle.should_not == Circle.new(2,2,3)
        @circle.should_not == Circle.new(1,3,3)
      end
    end

    describe "Line: " do 
      before :each do
        @line = Line.new(1,2,3,4)
      end

      it "should have a working ==" do
        @line.should_not == Line.new(1,2,3,3)
        @line.should_not == Line.new(1,3,3,4)
        @line.should == Line.new(1,2,3,4)
        @line.should_not == Line.new(5,2,3,4)
      end

      it "== should return true on reversed line segments" do
        @line.should == Line.new(3,4,1,2)
      end
    end

    describe "Point: " do
      before :each do
        @point = Point.new(1,2)
      end

      it "should have an == method" do
        @point.should == Point.new(1,2)
        @point.should_not == Point.new(2,2)
      end
    end

    # Shape methods
    describe "static methods: " do
      before :each do
        @shapes = [ Line.new(20,30,40,50), Circle.new(100,200,20) ]
        @encoded_shapes = "line:20:30:40:50,circle:100:200:20"
      end
      it "should encode an array of shapes to a string with Shape.encode_a" do
        Shape.encode_a(@shapes).gsub(/\.0+\b/, "").should == @encoded_shapes
      end

      it "should decode a string to an array of shapes with Shape.decode_a" do
        Shape.decode_a(@encoded_shapes).should == @shapes
      end
    end
  end

  describe "intCircleCircle" do
    it "should be accurate within .01 on reasonable sized circles" do
      # example calculations taken from http://www.analyzemath.com/CircleEq/circle_intersection.html
      circle1 = Circle.new(2,3,3)
      circle2 = Circle.new(1,-1,4)
      intpoints = Geometry::intCircleCircle(circle1,circle2)
      intpoints.map! { |p| p.round(2) }
      
      realintpoints = [ Point.new(-0.96, 2.49), Point.new(4.37, 1.16) ]

      if realintpoints[0] == intpoints[0]
        realintpoints[1].should == intpoints[1];
      else
        realintpoints[1].should == intpoints[0];
        realintpoints[0].should == intpoints[1];
      end
    end
  end

  describe "formPolygon?" do
    it "should return true when lines form a polygon" do
      lines = GeometryField.polygonAtCenter([12,13,15,17])
      Geometry::formPolygon?(lines).should be_true
    end

    it "should return false when lines don't form a polygon" do
      lines = [Line.new(1,2,3,4), Line.new(3,4,5,6), Line.new(5,6,7,8) ]
      Geometry::formPolygon?(lines).should_not be_true
    end

    it "shouldn't matter which order the lines are in" do
      lines = GeometryField.polygonAtCenter([12,13,15,17])
      lines.shuffle!
      Geometry::formPolygon?(lines).should be_true
    end
  end
end
