#!/usr/bin/env ruby
require_relative '../grade6'

include ToHTML
include Geometry

module Chapter4
  def Chapter4.pointsOnLine(m, b, startx, endx, num_points, start_name = "A")
    name = start_name.dup
    x_inc = (endx - startx) / (num_points + 1) # + endpoints

    Array.new(num_points) do |i|
      x = startx + x_inc * (i + 1) # i_0 = first end point
      y = m*x + b
      name.next! unless i == 0
      NPoint.new(x, y, name.dup, (1.0/m))
    end
  end

  #
  # Chapter 4.1 exercises
  # 
  class NameLine < QuestionWithExplanation
    attr_accessor :l, :points
    def initialize
      length = rand(50) + 100
      endpoints = SmallGeoDisplay.randCenterLine(length)
      @l = InfLine.new(*endpoints)
      m, b = *(@l.toSlopeInt)

      num_points = 3 + (length / 125) # 125 = avg length
      start_letter = ["A", "E", "U", "W"].sample
      @points = Chapter4::pointsOnLine(m, b, @l.x1, @l.x2, num_points)
    end

    def text
      num_lines = @points.length * (@points.length - 1)
      [
        TextLabel.new("Name the line in all possible (#{num_lines}) ways"),
        SmallGeoDisplay.new(@l, *@points),
        MultiTextField.new("ans")
      ]
    end

    def solve
      {
        "ans" => @points.map { |p| p.name }.permutation(2).to_a.map { |a| a.join("") }
      }
    end

    def explain
      [
        Subproblem.new([
          TextLabel.new("A line is named after 2 points on it, and the order doesn't matter.  Therefore you can call the following line any of these names: { #{soln["ans"].join(", ")} }"),
          SmallGeoDisplay.new(@l1, *@points)
          ], {} )
      ]
    end
  end

  class NameRay
    def initialize
      length = rand(50) + 100
      endpoints = SmallGeoDisplay.randCenterLine(length)
      @l = Ray.new(*endpoints)
      m, b = *(@l.toSlopeInt)
      
      num_points = 3 + (length / 125) # 125 = avg length
      start_letter = ["A", "E", "U", "W"].sample
      @points = Chapter4::pointsOnLine(m, b, @l.x1, @l.x2, num_points)
    end
  end

  # which point is an intersection of a line
  class NameIntPoints
      length = rand(50) + 50
      endpoints = SmallGeoDisplay.randCenterLine(length)
  end

  # is a point on a given line/ray?
  class PointOnLine
  end

  #
  # Chapter 4.2 exercises
  #

  # is a curve open or closed?
  class OpenClosedCurves
  end

  #
  # Chapter 4.3 exercises
  #
  class NameAngles < QuestionBase
    attr_accessor :points, :lines

    def initialize
      cx, cy = *(SmallGeoDisplay.center)
      numpoints = rand(2) + 4

      name = "A"
      @points = Array.new(numpoints) do |i|
        dist = (SmallGeoDisplay.width/6) + rand(SmallGeoDisplay.width / 6)
        theta = (2 * Math::PI * (i.to_f / numpoints))
        x = cx + dist * Math.cos(theta)
        y = cy + dist * Math.sin(theta)
        name.next! unless i == 0

        NPoint.new(x, y, name.dup, theta)
      end

      @lines = Array.new(numpoints) do |i|
        j = (i+1) % numpoints
        Line.new(@points[i], @points[j])
      end
    end

    def solve
      angle_names = Array.new(@points.length) do |i|
        j = (i + 1) % @points.length
        k = (j + 1) % @points.length
        "#{@points[i].name}#{@points[j].name}#{@points[k].name}"
      end

      { "ans" => angle_names }
    end

    def preprocess(name, response)
      ret = response.upcase
      # Angles can be written in either order, so we'll standardize it
      ret.reverse! if ret.reverse < ret
      ret
    end

    def text
      [ 
        TextLabel.new("Give a name for each of the angles in the following drawing"),
        SmallGeoDisplay.new(*@lines, *@points),
        MultiTextField.new("ans")
      ]
    end
  end

  #
  # Chapter 4.4 exercises
  #
  class NameTriangles
  end

  PROBLEMS = [
    Chapter4::NameLine,
    Chapter4::NameAngles
  ]
end
