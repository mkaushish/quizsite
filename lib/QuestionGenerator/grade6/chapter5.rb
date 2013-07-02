#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml'
require_relative '../geometry'
require_relative '../grade6'

include ToHTML
include Geometry
module Chapter5
  INDEX = "chapter5"
  TITLE = "Understanding Elementary shapes"

  class Try3_4 < QuestionBase
  	def has_notepad?() false ; end
  	def self.type
  		"measurement of line segments "
  	end
  	attr_accessor :x1, :y1, :x2, :y2
  	def initialize
      @x1=rand(100) + 1
      @y1=rand(250)+100
      @x2=rand(20)+500
      @y2=@y1
      @xmid=rand(20)+110
      @ymid=@y1
      @ac=@xmid-@x1
      @ab=@x2 - @x1
      @cb= @x2 - @xmid
    end
    def solve
      {"ans" => @ac}
    end
  	def text
  			[
        TextLabel.new("Find the length of AC when AB = #{@ab} and CB = #{@cb} "),
        GeometryDisplay.new(Line.new(@x1,@y1,@xmid,@ymid),Line.new(@xmid,@ymid,@x2,@y2),NPoint.new(@x1,@y1,"A",0),NPoint.new(@xmid,@ymid,"C",0),NPoint.new(@x2,@y2,"B",0)),
        TextField.new("ans")
        ]
    end
  end

  class Question2 < QuestionBase
    def has_notepad?() false ; end
    def self.type
      "Clock angle "
    end
    def initialize
      @time1=rand(12) + 1
      @time2=rand(12) + 1
      if @time1 < @time2
        @angle = (@time2 - @time1)*30
      else
        @angle = (12- @time1 + @time2)*30
      end
    end
    def solve
      {"ans" => @angle}
    end
    def text
      [
       TextLabel.new("What fraction of a clockwise revolution does the hour hand of a clock turn through,when it goes from #{@time1} to #{@time2}"),
       InlineBlock.new(TextField.new("ans"),TextLabel.new("degrees"))
      ]
    end
  end

  class Question3 < QuestionBase
    def has_notepad?() false ; end
    def self.type
      "Direction of Clock"
    end
    def initialize
      @randdir=rand(4)
      
      @dir=["north","east","south","west"]
      @dir_value=[0,90,180,270]
      @randclock=rand(2)
      @i=rand(4)
      @direc=@dir_value[@i]
      if(@randclock == 0)#anticlockwise
        @sign=-1
        @strclock="Anticlockwise"
      else
        @sign=1 #clockwise
        @strclock="Clockwise"
      end

        
      if(@randdir == 0)
       @fraction1=1
        @num=1
        @den=1
      elsif(@randdir == 1)
        @fraction1=0.5
        @num=1
        @den=2
      elsif (@randdir = 2)
        @fraction1=0.75
        @num=3
        @den=4
      else
        @fraction1=1.5
        @num=3
        @den=2
      end
      @fraction1=@fraction1*1.0
      @angleans=@direc + @sign*@fraction1*360
      while(@angleans > 360 || @angleans < 0)
        
        if(@angleans > 360)
          @angleans = @angleans - 360
        end
        if(@angleans < 0)
          @angleans = @angleans + 360
        end
        
      end
      if(@angleans == 0 || @angleans == 360)
        @ans="North"
      end
      if(@angleans == 90)
        @ans="East"
      end
      if(@angleans == 180)
        @ans="South"
      end
      if(@angleans == 270)
        @ans="West"
      end
      if(@angleans == 45)
        @ans="North-East"
      end
      if(@angleans == 135)
        @ans="South-East"
      end
      if(@angleans == 225)
        @ans="South-West"
      end
      if(@angleans == 315)
        @ans="North-West"
      end

    end
    def solve
      {"ans" => @ans}
    end
    def text
      [
        InlineBlock.new(TextLabel.new("Which direction will you face if you start facing #{@dir[@i]} and make "),Fraction.new(@num,@den),TextLabel.new(" of a revolution #{@strclock}")),
        Dropdown.new("ans","North","East","South","West","North-East","South-East","South-West","North-West")
      ]
    end
  end
  class Question4 < QuestionBase
    def has_notepad?() false ; end
    def self.type
      "Match the Angle"
    end
    def initialize
      @anglearr=["Straight Angle","Right Angle","Acute Angle","Obtuse Angle","Reflex Angle"]
      @anglematch=["Half of a revolution","One-fourth of a revolution","Less than one-Fourth of a revolution","Between 1/2 and 1/4 of a revolution",
      "More than half a revolution","One complete revolution"]
      @i=rand(5)
      @ans=@anglematch[@i]
    end
    def solve
      {"ans" => @ans}
    end
    def text
      [
        TextLabel.new("Match the angle with the correct option"),TextLabel.new(@anglearr[@i]),Dropdown.new("ans","Half of a revolution","One-fourth of a revolution","Less than one-Fourth of a revolution","Between 1/2 and 1/4 of a revolution",
          "More than half a revolution","One complete revolution")
      ]
    end
  end
  class Question5 < QuestionBase
    attr_accessor :x1, :y1, :x2, :y2
    def has_notepad?() false ; end
    def self.type
      "Identify the type of Angle"
    end
    def initialize
      @randdir=rand(4)
      @x1=rand(500) + 1
      @y1=rand(500) + 1
      @x2=rand(1000)
      while(@x2 -@x1 < 10 && @x2 - @x1 > -10 )
        @x2=rand(1000)
      end
      @y2=rand(1000)
      @x3=rand(1000)
      while((@x3 - @x1 <10 && @x3 - @x1 > -10)||(@x3 - @x2 <10 && @x3 - @x2 > -10))
        @x3=rand(1000)
      end
      @y3=rand(1000)
      @lineAB = Math.sqrt((@x2 - @x1)**2 + (@y2 - @y1)**2)
      @lineBC = Math.sqrt((@x3 - @x1)**2 + (@y3 - @y1)**2)
      @lineAC = Math.sqrt((@x3 - @x2)**2 + (@y3 - @y2)**2)
      @cosangleABC = (@lineAC**2 - @lineAB**2 + @lineBC**2)/(2*@lineAB*@lineBC)
      @angleABC= Math.acos(@cosangleABC)
      @pi=Math::PI
      if(@angleABC < @pi/2 && @angleABC > @pi/2)
        @ans="Acute"
      elsif(@angleABC == @pi/2)
        @ans="Right"
      elsif(@angleABC > @pi/2 && @angleABC < @pi)
        @ans="Obtuse"
      elsif(@angleABC == @pi/2)
        @ans="Straight"
      else
        @ans="Reflex"
      end
    end
    def solve
      {"ans" => @ans}
    end
    def text
      [
        GeometryDisplay.new(Line.new(@x1,@y1,@x2,@y2),Line.new(@x1,@y1,@x3,@y3),NPoint.new(@x1,@y1,"B",0),NPoint.new(@x2,@y2,"A",0),NPoint.new(@x3,@y3,"C",0)),
        TextLabel.new("What kind of Angle is shown above?"),Dropdown.new("ans","Acute","Right","Obtuse","Straight","Reflex")
      ]
    end
  end

class Question6 < QuestionBase
    attr_accessor :x1, :y1, :x2, :y2
    def has_notepad?() false ; end
    def self.type
      "True or False"
    end
    def initialize
      @statements=["Each Angle of a rectangle is a right angle","The opposite sides of a rectangle are equal in lengths","The diagonals of a square are perpendicular to one-another",
        "All the sides of a rhombus are of equal length","All the sides of a parallelogram are of equal length","The opposite sides of a trapezium are parallel",
        "The diagonals of a Rhombus are at right angles","The sum of angles of a quadrilateral is 360 degrees"]
      @stat_ans=[1,1,1,1,0,0,0,1]
      @randi=rand(8)
      if(@stat_ans[@randi]==1)
        @ans="True"
      else
        @ans="False"
      end
    end
    def solve
      {"ans" => @ans}
    end
    def text
      [
        TextLabel.new("Choose whether the statement is true or false:-"),
        TextLabel.new("#{@statements[@randi]}"),
        Dropdown.new("ans","True","False")
      ]
    end
  end
  class Question7 < QuestionWithExplanation
    attr_accessor :x1, :y1, :x2, :y2
    def has_notepad?() false ; end
    def self.type
      "Octagon"
    end
    def initialize
      @numpoints = 8
      @name = "Octagon"
    end

    def text
      [
        TextLabel.new("Draw a #{@name} on the canvas below"),
        GeometryField.new()
      ]
    end

    def solve
      lines = GeometryField::polygonAtCenter(@numpoints)
      { "geometry" => Shape.encode_a(lines) }
    end

    def correct?(response)
      lines = GeometryField::shapesFromResponse(response).uniq
      lines.each { |l| return false unless l.is_a?(Line) }
      return false if lines.length != @numpoints
      return Geometry::formPolygon?(lines)
    end

    def explain
      [
        Subproblem.new([
          TextLabel.new("A #{@name} is a polygon with #{@numpoints} sides.  Here's an example below!"),
          SmallGeoDisplay.new(SmallGeoDisplay::polygonAtCenter(@numpoints))
        ], {} )
        # TODO add in example problem - this will require modifying next_subproblem.js.erb
      ]
    end
  end



  PROBLEMS = [Chapter5::Try3_4,
  Chapter5::Question2,
  Chapter5::Question3,
  Chapter5::Question4,
  Chapter5::Question5,
  Chapter5::Question6,
  Chapter5::Question7]
end