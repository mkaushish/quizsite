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
      @gf.encodedStartShapes.should =~ /#{@encoded_shapes}(:?\.0+)?/
    end

    it "should decode response shapes with shapesFromResponse" do
      @gf.shapesFromResponse(@response).should == @shapes
    end
  end
end
