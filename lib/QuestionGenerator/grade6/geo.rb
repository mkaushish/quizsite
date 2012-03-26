#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml'
require_relative '../geometry'

include ToHTML
include Geometry

module Geo
  class BisectLine < QuestionBase
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

    def correct?(response)
      shapes = GeometryField.shapesFromResponse(response)
      shapes.each do |circle1|
        next unless circle1.is_a? Circle
        next unless circle1.x == @x1 && circle1.y == @y1
        next unless circle1.r >= distance(@x1,@y1,@x2,@y2)/2

        shapes.each do |circle2|
          next unless circle2.is_a? Circle
          next unless circle2.x == @x2 && circle1.y == @y2
          next unless circle2.r == circle1.r
          intPoints = Geometry::intCircleCircle(circle1, circle2)
          # intPoints should mathematically always return 2 points...

          shapes.each do |line|
            if intPoints[0].distance(line.x1, line.y1) < 3 &&
               intPoints[1].distance(line.x2, line.y2) < 3
              return true
            elsif intPoints[1].distance(line.x1, line.y1) < 3 &&
                  intPoints[2].distance(line.x2, line.y2) < 3
              return true
            end
          end # line
        end # circle2
      end # circle1
      return false
    end
  end
end
