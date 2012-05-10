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
      Point.new(x, y, name.dup)
    end
  end

  #
  # Chapter 4.1 exercises
  # 
  class NameLine < QuestionBase
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
  end

  class NameRay
      length = rand(50) + 100
      endpoints = SmallGeoDisplay.randCenterLine(length)
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
  class NameAngles
  end

  class AngleInteriors
  end

  #
  # Chapter 4.4 exercises
  #
  class NameTriangles
  end

  PROBLEMS = [
    Chapter4::NameLine
  ]
end
