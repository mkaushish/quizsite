#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml'
require_relative '../geometry'

include ToHTML
include Geometry

module Geo
  class BisectLine < QuestionBase
    attr_accessor :x1, :y1, :x2, :y2
    def initialize()
      @x1 = 100 + rand(200);
      @y1 = 100 + rand(200);
      @x2 = 400 - rand(200);
      @y2 = 400 - rand(200);
    end

    def text
      [
        TextLabel.new("Draw a line that bisects the line on the screen"),
        GeometryField.new(Line.new(@x1,@y1,@x2,@y2))
      ]
    end

    # locates and returns all pairs of circles a, b such that
    # (a.x, a.y) = (@x1, @y1)
    # (b.x, b.y) = (@x2, @y2)
    # a.r = b.r
    # a.r > ||line|| / 2
    def getMatchingCircles(shapes)
      ret = []
      shapes.each do |circle1|
        next unless circle1.is_a? Circle
        next unless circle1.x == @x1 && circle1.y == @y1
        next unless circle1.r >= distance(@x1,@y1,@x2,@y2)/2

        shapes.each do |circle2|
          next unless circle2.is_a? Circle
          next unless circle2.x == @x2 && circle2.y == @y2
          next unless circle2.r == circle1.r
          ret << [circle1, circle2]
        end # circle2
      end # circle1
      ret
    end

    def correct?(response)
      shapes = GeometryField.shapesFromResponse(response)
      circles = getMatchingCircles(shapes)

      circles.each do |circs|
        intPoints = Geometry::intCircleCircle(*circs)
        # intPoints should mathematically always return 2 points
        # ... assuming intCircleCircle and getMatchingCircles both work

        shapes.each do |line|
          next unless line.is_a?(Line)
          
          if intPoints[0].distance(line.x1, line.y1) < 3 &&
             intPoints[1].distance(line.x2, line.y2) < 3
            return true
          elsif intPoints[1].distance(line.x1, line.y1) < 3 &&
                intPoints[0].distance(line.x2, line.y2) < 3
            return true
          end
        end # line
      end
      return false
    end
  end
end
