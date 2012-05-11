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
  class NameAngles < QuestionWithExplanation
    attr_accessor :points, :lines

    def initialize
      cx, cy = *(SmallGeoDisplay.center)
      numpoints = rand(2) + 4
      dists = Array.new(numpoints) { (SmallGeoDisplay.width/6) + rand(SmallGeoDisplay.width / 6) }
      @lines, @points = *(SmallGeoDisplay::polygonAtCenterWithPoints("A", dists))
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

    def explain
      angle_names = solve["ans"]
      i = rand(@points.length)
      pname = @points[(i+1) % @points.length].name
      angle = angle_names[i]
      [ 
        Subproblem.new( [
          TextLabel.new("Angles are named after the three points that define them.  The point at the center of the angle (the vertex) is always in the middle of the angle name, but the other ones don't matter.  That means that the angle centered on point #{pname} could be called either #{angle} or #{angle.reverse}.  When going through and naming all the angles, make sure each point is in the middle in exactly one of the names.  One way of writing all the names is { #{angle_names.join(", ")} }"),
          SmallGeoDisplay.new(*@lines, *@points)
        ], {} )
      ]
    end
  end

  #
  # Chapter 4.4 exercises
  #
  class NameTriangles < QuestionWithExplanation
    attr_accessor :lines
    def initialize
      start_letter = ["A", "C", "U", "X"].sample
      dists = Array.new(3) { (SmallGeoDisplay.width/6) + rand(SmallGeoDisplay.width / 6) }
      @lines, @points = *(SmallGeoDisplay::polygonAtCenterWithPoints(start_letter, dists))
    end

    def solve
      ans = @points.map { |p| p.name }.sort.join("")
      { "ans1" => ans, "ans2" => ans.reverse }
    end

    def correct?(params)
      a1, a2 = *(QuestionBase.vars_from_response("ans1", "ans2", params))
      a1.upcase!
      a2.upcase!
      return false if a1 == a2
      return false unless a1.split("").sort == soln["ans1"].split("")
      return false unless a2.split("").sort == soln["ans1"].split("")
      return true
    end

    def text
      [
        TextLabel.new("Give 2 different names for this triangle"),
        SmallGeoDisplay.new(*@lines, *@points),
        TextField.new("ans1"),
        TextField.new("ans2")
      ]
    end

    def explain
      tnames = @points.map { |p| p.name }.permutation.to_a.map { |a| a.join("") }
      [ 
        Subproblem.new( [
          TextLabel.new("Triangles are named after the three points that define them, and the order doesn't matter.  This is because no matter what order you name the points in, you can count them off going in a cycle around the triangle! The full list of ways to write the name of this triangle is { #{tnames.join(", ")} }"  ),
          SmallGeoDisplay.new(*@lines, *@points)
        ], {} )
      ]
    end
  end

  #
  # Just taken from the end
  #
  class DefVertices
  end

  class DefAdjacentSides
  end

  class DefAdjacentVertices
  end

  class DefDiagonal
  end

  PROBLEMS = [
    Chapter4::NameLine,
    Chapter4::NameAngles,
    Chapter4::NameTriangles
  ]
end
