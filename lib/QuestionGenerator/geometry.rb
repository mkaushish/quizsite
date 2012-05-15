require 'set'
require_relative 'tohtml'

include ToHTML

module Geometry
  class GeometryBase < InputField
    # Ways to maek a geo field:
    #   new( [ start shapes in array form ]
    #   new( startshape1, startshape2, ... )
    def initialize(*args)
      if(args[0].is_a? Array)
        @shapes = args[0]
      else
        @shapes = args
      end
      super("geometry")
    end

    # returns an array of the shapes the student drew, in order of creation, given the response hash
    def self.shapesFromResponse(response)
      Shape.decode_a(InputField.fromhash("geometry", response))
    end

    def encodedStartShapes
      Shape.encode_a(@shapes)
    end

    def startTool(tool = nil)
      @tool = tool unless tool.nil?
      @tool || "notool"
    end

    def self.selectedShapes(response)
      Shape.decode_a(InputField.fromhash("selectedshapes", response))
    end

    #
    # Characteristics of the GeometryField that might be useful in geometry questions
    #
    def self.height
      400
    end

    def self.width
      400
    end

    def self.center
      [ (self.width / 2), (self.height / 2) ]
    end

    # returns the coords for a line segment which crosses the center of the screen
    def self.randCenterLine(length)
      l = length / 2
      theta  = rand() * Math::PI
      center = self.center
      x = (l * Math.sin(theta)).to_i # using sin here ensures that x1 will always be lower than x2
      y = (l * Math.cos(theta)).to_i

      [ center[0] - x, center[1] - y, center[0] + x, center[1] + y ]
    end

    # yeah... not exactly the paragon of efficiency I admit, but premature optimization...
    def self.polygonAtCenter(dists)
      self.polygonAtCenterWithPoints("A", dists)[1]
    end

    def self.polygonAtCenterWithPoints(name, dists)
      numpoints = dists.length
      cx, cy = *(self.center)

      points = Array.new(numpoints) do |i|
        dist = (SmallGeoDisplay.width/6) + rand(SmallGeoDisplay.width / 6)
        theta = (2 * Math::PI * (i.to_f / numpoints))
        x = cx + dist * Math.cos(theta)
        y = cy + dist * Math.sin(theta)
        name.next! unless i == 0

        NPoint.new(x, y, name.dup, theta).round
      end

      lines = Array.new(numpoints) do |i|
        j = (i+1) % numpoints
        Line.new(points[i], points[j])
      end
      [ lines, points ]
    end
  end

  # GeometryField is special in many ways:
  #  -When there is a geometry field in the text hash, you *MUST OVERRIDE THE correct? METHOD* on your problem
  #  -The geometry field will be represented by our geometry/drawing javascript app
  #  -when the student submits and answer to a geometry question the app will add hidden fields for all
  #   of the shapes the student has drawn.  These will be labelled in order of creation as geometry1, geometry2,
  #  -I have provided the shapesFromResponse class method to get the ruby shapes in an array from the response hash
  #  -for example usage of the GeometryField, see the BisectLine question currently located in grade6/geo.rb
  class GeometryField < GeometryBase
    def correct?(solution, response)
      raise "I should NEVER be called - you forgot to override QuestionBase's correct method didn't you"
    end
  end

  # NOTE this will taxonomically be extended from input field... but it shouldn't be.  Input field etc should be a mixin
  class GeometryDisplay < GeometryBase
    def correct?(solution, response)
      true
    end
  end

  class SmallGeoDisplay < GeometryDisplay
    def self.width
      200
    end
    def self.height
      200
    end
  end

  class Shape
    # Decodes a SINGLE shape
    def self.decode(s)
      a = s.split(":")
      type = a.shift

      if type == "circle"
        return Circle.new(*a)
      elsif type == "line"
        return Line.new(*a)
      elsif type == "point"
        return Point.new(*a)
      end
    end

    # takes a string, and decodes all the shapes in it, returning an array of shapes
    def self.decode_a(shape_s)
      shape_s.split(",").map { |s| Shape.decode(s) }
    end

    # takes an array of shapes, and encodes them all to a string
    def self.encode_a(shape_a)
      shape_a.map { |s| s.encode }.join(",")
    end
  end

  class Circle < Shape
    attr_accessor :x, :y, :r
    def initialize(x, y, r)
      @x = x.to_i
      @y = y.to_i
      @r = r.to_f
    end

    def encode
      "circle:#{x}:#{y}:#{r}"
    end

    def ==(other)
      return false unless other.is_a?(Circle)
      return @x == other.x && @y == other.y && @r == other.r 
    end
  end

  class Line < Shape
    attr_accessor :x1, :y1, :x2, :y2

    def initialize(x1, y1, x2=nil, y2=nil)
      if(x1.is_a?(Point)) 
        @x1 = x1.x
        @y1 = x1.y
        @x2 = y1.x
        @y2 = y1.y
      else
        @x1 = x1.to_f
        @y1 = y1.to_f
        @x2 = x2.to_f
        @y2 = y2.to_f
      end
    end

    def encode
      "line:#{x1}:#{y1}:#{x2}:#{y2}"
    end

    def ==(other)
      return false unless other.is_a?(Line)
      return (@x1 == other.x1 && @x2 == other.x2 && @y1 == other.y1 && @y2 == other.y2) ||
             (@x1 == other.x2 && @x2 == other.x1 && @y1 == other.y2 && @y2 == other.y1)
    end

    def round!(deg = 0)
      @x1 = @x1.round(deg)
      @y1 = @y1.round(deg)
      @x2 = @x2.round(deg)
      @y2 = @y2.round(deg)
      self
    end

    def toSlopeInt
      m = (y2 - y1) / (x2 - x1)
      b = y1 - (m * x1)
      return [ m, b ]
    end

    def p1
      return Point.new(@x1, @y1)
    end

    def p2
      return Point.new(@x2, @y2)
    end
  end

  class Ray < Line
    def encode
      "ray:#{x1}:#{y1}:#{x2}:#{y2}"
    end

    def ==(other)
      return false unless other.is_a?(Ray)
      return (@x1 == other.x1 && @x2 == other.x2 && @y1 == other.y1 && @y2 == other.y2)
    end
  end

  class InfLine < Line
    def encode
      "infline:#{x1}:#{y1}:#{x2}:#{y2}"
    end

    def ==(other)
      return false unless other.is_a?(InfLine)
      me  = toSlopeInt
      you = other.toSlopeInt
      me[0].closeTo(you[0]) && me[1].closeTo(you[1])
    end
  end

  class Point < Shape
    attr_accessor :x, :y, :name
    def initialize(x,y)
      @x = x.to_i
      @y = y.to_i
    end

    def distance(a1, a2=nil)
      if a1.is_a?(Point)
        return Geometry::distance(@x, @y, a1.x, a1.y)
      elsif ( a1.is_a?(Numeric) && a2.is_a?(Numeric))
        return Geometry::distance(@x, @y, a1, a2)
      end
      return -1
    end

    # destructively rounds the point off
    #  deg = number of decimals to round it to
    def round(deg = 0)
      @x = @x.round(deg)
      @y = @y.round(deg)
      self
    end

    def ==(other)
      return false unless other.is_a?(Point)
      return @x == other.x && @y == other.y
    end

    def encode
      "" # we really don't need these to be written to the canvas
    end
  end

  # Just a point with a name
  class NPoint < Point
    attr_accessor :name, :angle
    def initialize(x, y, name, angle = 45.0)
      @name = name
      @angle = angle
      super(x,y)
    end

    def encode
      "point:#{x}:#{y}:#{name}:#{angle}"
    end
  end


  def distance(x1, y1, x2, y2)
    return Math.hypot(x2-x1, y2-y1)
  end

  def intCircleCircle(c1, c2)
    dist = Geometry::distance(c1.x, c1.y, c2.x, c2.y)
    overlap = (c1.r + c2.r) - dist
    return [] if overlap < 0 || dist == 0 # if no intersections OR circles are same, we don't want POIS

    # if there's 
    if overlap == 0 
      x = (c2.x - c1.x)*(c1.r/(c1.r + c2.r)) + c1.x
      y = (c2.y - c1.y)*(c1.r/(c1.r + c2.r)) + c1.y
      return [Point.new(x,y)]
    end
    
    # we can now assume that there are 2 points of intersection
    # equations taken from http://paulbourke.net/geometry/2circle/
    a = (c1.r * c1.r - c2.r * c2.r + dist * dist) / (2 * dist) # a =~ distance from c1 to the midpoint between the two circles
    h = Math.sqrt(c1.r * c1.r - a * a) # 
    # (x,y) is P2 on the url above, which is the main point between the two circles
    x = (c2.x - c1.x)*(a/dist) + c1.x
    y = (c2.y - c1.y)*(a/dist) + c1.y

    x1 = x - (h/dist)*(c2.y - c1.y)
    x2 = x + (h/dist)*(c2.y - c1.y)
    y1 = y + (h/dist)*(c2.x - c1.x)
    y2 = y - (h/dist)*(c2.x - c1.x)
    return [Point.new(x1, y1), Point.new(x2, y2)]
  end
end
