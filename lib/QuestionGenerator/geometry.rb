require 'set'
require_relative 'tohtml'

include ToHTML

module Geometry
  # GeometryField is special in many ways:
  #  -When there is a geometry field in the text hash, you *MUST OVERRIDE THE correct? METHOD* on your problem
  #  -The geometry field will be represented by our geometry/drawing javascript app
  #  -when the student submits and answer to a geometry question the app will add hidden fields for all
  #   of the shapes the student has drawn.  These will be labelled in order of creation as geometry1, geometry2,
  #  -I have provided the shapesFromResponse class method to get the ruby shapes in an array from the response hash
  #  -for example usage of the GeometryField, see the BisectLine question currently located in grade6/geo.rb
  class GeometryField < InputField

    # Pass me the start shapes in an array, or as a list of seperate arguments
    def initialize(*args)
      if(args[0].is_a? Array)
        @shapes = args[0]
      else
        @shapes = args
      end
      super("geometry")
    end

    def correct?(solution, response)
      raise "I should NEVER be called - you forgot to override QuestionBase's correct method didn't you"
    end

    # returns an array of the shapes the student drew, in order of creation, given the response hash
    def self.shapesFromResponse(response)
      Shape.decode_a(InputField.fromhash("geometry", response))
    end

    def encodedStartShapes
      Shape.encode_a(@shapes)
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
      return (@x1 == other.x1 && @x2 == other.x2 && @y1 == other.y1 && @y2 == other.y2) ||
             (@x1 == other.x2 && @x2 == other.x1 && @y1 == other.y2 && @y2 == other.y1)
    end
  end

  class Point
    attr_accessor :x, :y
    def initialize(x,y)
      @x = x
      @y = y
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
      return @x == other.x && @y == other.y
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
