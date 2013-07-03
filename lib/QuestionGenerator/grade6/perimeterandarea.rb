require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml'
require_relative './preg6'
require_relative '../modules/names'
require_relative './c6'
require 'prime'
require 'set'
# TODO override preprocess for the add commas question ( default is now to remove commas )
include ToHTML
include PreG6

module PerimeterandArea
  INDEX = "perimeterandarea"
  TITLE = "PerimeterandArea"
  
  UNITS = ["mm","cm","dc","m","Dm","hm","km" ]
  UNITS2 = ["millimeter", "centimeter", "decimeter","meter","decameter","hectometer","kilometere"]
  PLACE1= ["garden","park","room"]
  PLACE2= ["path","path","verandah"]
  

  class Createkb4 < QuestionBase
    def self.type
      "Createkb4"
    end
    def initialize
      @original2=[]
      @original2[0]=20;
      @original2[1]=0;
      @original2[2]=11;
      @original2[3]=20;
      @original2[4]=10;
      # @original2[5]=12;
      # @original2[6]=0;
      # @original2[7]=10;
      # @original2[8]=13;
      # @original2[9]=0;
      # @original2[10]=5;
      # @original2[11]=14;
      # @original2[12]= 5;
      # @original2[13]=3;
      # @original2[14]=17;
      @PI= Math.acos(-1)
      @angle = @PI/2.0
    end
    def solve
      {"ans" => @a}
    end
    def text
      
      [
        # TextLabel.new("Translate the given table into a bar graph taking the scale as 5 students per unit of length"), 
         # DrawShape2.new('arc_2',100,100,15,0,@angle,300,300,1,1),
        DrawShape4.new('arc_4',50,20,20,500,0.25*@PI,0.5*@PI,'a','b','c',700,500,1,1)

         # DrawShape3.new(@original2,'cm',50,50,0)
       ]
    end
  end

  class Per_circle<QuestionWithExplanation
    def self.type
      "Per_circle"
    end
    def initialize
      @a = rand(15)+5
      @b = rand(2)
      @unit = UNITS[@b]
    end
    def solve
      {
        "ans"=>2*@a
      }
    end
    def text
      [
        TextLabel.new("What is the perimeter/circumference of the folowing circle?"),
        DrawShape2.new('circle',@a,@a+1,@a+1,1,1,@unit,300,300,1,1),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("pi"))
      ]
    end
    def explain
      [
        SubLabel.new("The perimeter/circumference of a circle is 2*r*pi.")
      ]
    end
  end

  class Area_circle<QuestionWithExplanation
    def self.type
      "Area_circle"
    end
    def initialize
      @a = rand(15)+5
      @b = rand(2)
      @unit = UNITS[@b]
    end
    def solve
      {
        "ans"=>@a*@a
      }
    end
    def text
      [
        TextLabel.new("What is the area of the folowing circle?"),
        DrawShape2.new('circle',@a,@a+1,@a+1,1,1,@unit,300,300,1,1),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("pi"))
      ]
    end
    def explain
      [
        SubLabel.new("The area of a circle is r*r*pi.")
      ]
    end
  end

  class Per_rectangle<QuestionWithExplanation
    def self.type
      "Per_rectangle"
    end
    def initialize
      @a = rand(15)+5
      @b = rand(15)+5
      @choose = rand(3)
      @unit = UNITS[@b]
    end
    def solve
      if @choose==0
       {
        "ans"=>4*@a
       } 
      else
      {
        "ans"=>2*(@a+@b)
      }
      end
    end
    def text
      if @choose==0
      [
        TextLabel.new("What is the perimeter of the folowing square?"),
        DrawShape2.new('rectangle',@a,@a,5,3,5,@unit,300,300,1,1),
        InlineBlock.new(TextField.new("ans"))
      ]
      else
      [
        TextLabel.new("What is the perimeter of the folowing rectangle?"),
        DrawShape2.new('rectangle',@a,@b,5,3,5,@unit,300,300,1,1),
        InlineBlock.new(TextField.new("ans"))
      ]
      end
    end
    def explain
      if choose==0
      [
        SubLabel.new("The perimeter of a square is 4*(length).")
      ] 
      else
      [
        SubLabel.new("The perimeter of a rectangle is 2*(length+breadth).")
      ]
      end
    end
  end

  class Area_rectangle<QuestionWithExplanation
    def self.type
      "Area_rectangle"
    end
    def initialize
      @a = rand(15)+5
      @b = rand(15)+5
      @choose = rand(3)

      @unit = UNITS[@choose]
    end
    def solve
      if @choose==0
       {
        "ans"=>@a*@a
       } 
      else
      {
        "ans"=>@a*@b
      }
      end
    end
    def text
      if @choose==0
      [
        TextLabel.new("What is the area of the folowing square?"),
        DrawShape2.new('rectangle',@a,@a,5,3,5,@unit,300,300,1,1),
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")))
      ]
      else
      [
        TextLabel.new("What is the area of the folowing rectangle?"),
        DrawShape2.new('rectangle',@a,@b,5,3,5,@unit,300,300,1,1),
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")))
      ]
      end
    end
    def explain
      if choose==0
      [
        SubLabel.new("The area of a square is (length)*(length).")
      ] 
      else
      [
        SubLabel.new("The area of a rectangle is (length*breadth).")
      ]
      end
    end
  end

  class Per_triangle<QuestionWithExplanation
    def self.type
      "Per_triangle"
    end
    def initialize
      @a = rand(10)+10
      @b = rand(10)+10
      @c = rand(10)+10
      @choose = rand(3)
      @d = rand(2)
      @unit = UNITS[@d]
    end
    def solve
      if @choose==0
       {
        "ans"=>3*@a
       } 
      elsif @choose==1 
      {
        "ans"=>2*@a+@b
      }
      else
      {
        "ans"=>@a+@b+@c
      }
      end
    end
    def text
      if @choose==0
      [
        TextLabel.new("What is the perimeter of the folowing triangle?"),
        DrawShape2.new('eqtriangle',@a,@a,20,0,280,@unit,300,300,1,1),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("#{@unit}"))
      ]
      elsif @choose==1
      [
        TextLabel.new("What is the perimeter of the folowing triangle?"),
        DrawShape2.new('isotriangle',@a,@b,20,0,280,@unit,300,300,1,1),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("#{@unit}"))
      ]
      else
      [
        TextLabel.new("What is the perimeter of the folowing triangle?"),
        DrawShape2.new('scalene',@a,@b,@c,0,1,@unit,300,300,1,1),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("#{@unit}"))
      ]
      end
    end
    def explain
      if choose==0
      [
        SubLabel.new("The perimeter of an equilateral triangle is 3*(sidelength).")
      ] 
      elsif @choose==1
      [
        SubLabel.new("The perimeter of an isosceles triangle is 2*(length of the common side)+length of the third side.")
      ]
      else
      [
        SubLabel.new("The perimeter of a triangle is the sum of the lengths of its three sides.")
      ]
      end
    end

  end

  class Area_triangle<QuestionWithExplanation
    def self.type
      "Area_triangle"
    end
    def initialize
      @a = rand(10)+10
      @b = rand(10)+10
      @c = rand(10)+10
      # @choose = rand(3)
      @choose=2
      @d = rand(2)
      @unit = UNITS[@d]
      @height=0
      @base=0
      @angle=0
      @PI= Math.acos(-1)
      if @choose==0
        @base=@a
        @height = (@a/2.0)*Math.tan(@PI/3)
      elsif @choose==1
          @angle = Math.acos(@b/(2.0*@a))
          @height = (@b/2.0)*(Math.tan(@angle))
          @base=@b
      else
        @cosA = (@b*@b+@c*@c-@a*@a)/(2.0*@b*@c)
        @angleA = Math.acos(@cosA)
        @sinA = Math.sin(@angleA)
        @radius = @a/(2.0*Math.sin(@angleA))
        @cosB = (@a*@a+@c*@c-@b*@b)/(2.0*@a*@c)
        @angleB = Math.acos(@cosB)
        @a1 = @radius*@sinA
        @a2 = @radius*@cosA
        @b2 = @radius*Math.sin(0.5*@PI-(@angleA+2*@angleB))
        if @a2>@b2
          @height = @a2-@b2
        else
          @height = @b2-@a2
        end
        @base=2*@a1
      end
    end
    def solve
      {
        "ans"=>((@base*@height)/2.0).round
        # "ans"=>@height
      }
    end
    def text
      if @choose==0
      [
        TextLabel.new("What is the area of the folowing triangle to the nearest integer value?"),
        DrawShape2.new('eqtriangle',@a,@a,20,1,280,@unit,300,300,1,1),
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")))
      ]
      elsif @choose==1
      [
        TextLabel.new("What is the area of the folowing triangle to the nearest integer value?"),
        DrawShape2.new('isotriangle',@a,@b,20,1,280,@unit,300,300,1,1),
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")))
      ]
      else
      [
        TextLabel.new("What is the area of the folowing triangle to the nearest integer value?"),
        DrawShape2.new('scalene',@a,@b,@c,1,1,@unit,300,300,1,1),
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")))
      ]
      end
    end
    def explain
      [
        SubLabel.new("The area of a triangle is 1/2(base*height).")
      ]
    end
  end

  class Per_regpolygon<QuestionWithExplanation
    def self.type
      "Per_regpolygon"
    end
    def initialize
      @a = rand(5)+5
      @b = rand(15)+1
      @c = rand(10)+10
      @choose = rand(3)
      @d = rand(2)
      @unit = UNITS[@d]
    end
    def solve
       {
        "ans"=>@b*@a
       } 
    end
    def text
      [
        TextLabel.new("What is the perimeter of the folowing polygon?"),
        DrawShape2.new('regularpolygon',@a,@b,500,1,1,@unit,500,500,1,1),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("#{@unit}"))
      ]
    end
    def explain
      [
        SubLabel.new("The perimeter of an regular polygon  is (number of sides)*(sidelength).")
      ] 
    end
  end


  class Unit_conversion<QuestionWithExplanation
    def self.type
      "Unit_conversion"
    end
    def initialize
      @a = rand(6)
      @b = rand(6)
      while @b==@a do
       @b = rand(6) 
      end
      if @b>@a
        @c=@a
        @a=@b
        @b=@c
      end
      # @choose = 1
      @choose = rand(3)
      @d = rand(9)+1
      @e = 10**(@a-@b)
      @unit1 = UNITS[@a]
      @unit2 = UNITS[@b]
      @unit3 = UNITS2[@a]
      @unit4 = UNITS2[@b]
      @f = 10**(2*(3-@a))
    end
    def solve
      if @choose==0
        {
        "ans"=>@d*(10**(2*(@a-@b)))
       }
      elsif @choose==1
        {
        "ans1"=>@d*(10**(-2*(@a-@b)))
       }
       else
        {
          "ans"=>@d*(10**(2*(3-@a)+4))
        }
      end
        
    end
    def text
    if @choose==0
      [
        InlineBlock.new(TextLabel.new("#{@d}"),Exponent.new(TextLabel.new("#{@unit1}"),TextLabel.new("2")),TextLabel.new(" = "),TextField.new("ans"),Exponent.new(TextLabel.new("#{@unit2}"),TextLabel.new("2")))
      ]
    elsif @choose==1
      [
        InlineBlock.new(TextLabel.new("#{@d}"),Exponent.new(TextLabel.new("#{@unit2}"),TextLabel.new("2")),TextLabel.new(" = "),TextField.new("ans1"),Exponent.new(TextLabel.new("#{@unit1}"),TextLabel.new("2")))
      ]
    else
      [
        InlineBlock.new(TextLabel.new("#{@d} Hectare "),TextLabel.new(" = "),TextField.new("ans"),Exponent.new(TextLabel.new("#{@unit1}"),TextLabel.new("2")))
      ]
    end
    end
    def correct?(params)
      if @choose==2
       solsum = 0
      bool = true
      resps = QuestionBase.vars_from_response( "ans1" , params)
      puts "********\n" + resps.to_s + "********\n"
      (((resps.to_f) == (@d*(10**(-2*(@a-@b)))).to_f)or((resps.to_f) == (@d*(10**(-2*(@a-@b)))))) 
      end
    end
    def explain
      if @choose==0
      [
        SubLabel.new("Hint: 1 #{@unit3} = #{@e} #{@unit4}.")
      ] 
      elsif @choose==1
      [
        SubLabel.new("Hint: 1 #{@unit3} = #{@e} #{@unit4}.")
      ]
      else
      [
        Subproblem.new([InlineBlock.new(TextLabel.new("Hint: 1 Hectare = 100"),Exponent.new(TextLabel.new("m"),TextLabel.new("2"))),TextLabel.new(" 1 m = #{@f} #{@unit3}.")])
      ]
      end  
    end
  end

  class Try11_1<QuestionWithExplanation
    def self.type
      "Try11_1"
    end
    def initialize
      @a = rand(15)+5
      @b = rand(15)+1
      @area = @a*@b
      @perimeter = 2*(@a+@b)
      @choose = rand(3)
      @d = rand(2)
      @unit = UNITS[@d]
    end
    def solve
      if @choose==0
       {
        "ans1"=>@b,
        "ans2"=>@perimeter
       }
       elsif @choose==1
       {
        "ans1"=>@b,
        "ans2"=>@area
       }
       else
        {
          "ans1"=>@a
        }
       end 
    end
    def text
      if @choose==0
        [
          TextLabel.new("The area of a rectangular sheet is #{@area}"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")),
          DrawShape2.new('rectangle',@a,@b,5,0,5,@unit,300,300,1,1),
          TextLabel.new("If the length of the sheet is #{@a}#{@unit}, what is its width?"),
          InlineBlock.new(TextField.new("ans1"),TextLabel.new("#{@unit}")),
          TextLabel.new("What is the perimeter of the rectangle?"),
          InlineBlock.new(TextField.new("ans2"),TextLabel.new("#{@unit}"))
        ]
      elsif @choose==1
       [
          TextLabel.new("The perimeter of a rectangular sheet is #{@perimeter}#{@unit}"),
          DrawShape2.new('rectangle',@a,@b,5,0,5,@unit,300,300,1,1),
          TextLabel.new("If the length of the sheet is #{@a}#{@unit}, what is its width?"),
          InlineBlock.new(TextField.new("ans1"),TextLabel.new("#{@unit}")),
          TextLabel.new("What is the area of the rectangle?"),
          InlineBlock.new(TextField.new("ans2"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")))
        ]
      else
        [
          TextLabel.new("The perimeter of a square  is #{4*@a}#{@unit}"),
          DrawShape2.new('rectangle',@a,@a,5,0,5,@unit,300,300,1,1),
          TextLabel.new("What is its sidelength?"),
          InlineBlock.new(TextField.new("ans1"),TextLabel.new("#{@unit}")),
        ]
      end 
    end
    def explain
      if @choose==0
        [
          Subproblem.new([TextLabel.new("The area of a rectangle is length*breadth. Now the area is #{@area}. Length is #{@a}, therefore breadth is area/length = #{@b}.")])
        ]
      elsif @choose==1 
        [
          Subproblem.new([TextLabel.new("The perimeter of a rectangle is 2*(length+breadth). Now the perimeter is #{@perimeter}. Length is #{@a}, therefore breadth is (perimeter-2*length)/2 = #{@b}.")])
        ]
      else
        [
          SubLabel.new("Perimeter of a square is 4*sidelength. Since perimeter is #{4*@a}, therefore sidelength is #{4*@a}/4 =#{@a}")
        ]
      end
    end
  end

  class Try11_2<QuestionWithExplanation
    def self.type
      "Try11_2"
    end
    def initialize
      @a = rand(5)+1
      @b = rand(5)+1
      @c = rand(5)+1
      @side = @a*@b
      @area1 = @a*@b*@a*@b
      @perimeter1 = 4*(@a*@b)
      @length=@a 
      @breadth = @b*@a*@b
      @choose=0
      # @choose = rand(2)
      @perimeter2= 2*(@a+@b*@a*@b)
      @d = rand(2)
      @unit = UNITS[@d]
    end
    def solve
      if @choose==0
       {
        "ans1"=>@breadth,
        "ans2"=>@perimeter2
       }
       else
       {
        "ans1"=>@side,
        "ans2"=>@perimeter1
       }
       end 
    end
    def text
      if @choose==0
        [
          TextLabel.new("The area of a square and a rectangle are equal.If the side of the square is #{@side} #{@unit} and the length of the rectangle is #{@length} #{@unit}, find the breadth of the rectangle"),
          DrawShape2.new('rectangle',@side,@side,5,3,5,@unit,310,400,1,1),
          DrawShape2.new('rectangle',@length,@breadth,5,1,5,@unit,310,@breadth*10+70,2,1),
          InlineBlock.new(TextField.new("ans1"),TextLabel.new("#{@unit}")),
          TextLabel.new("What is the perimeter of the rectangle?"),
          InlineBlock.new(TextField.new("ans2"),TextLabel.new("#{@unit}"))
        ]
      else
       [
          TextLabel.new("The area of a square and a rectangle are equal.If the length of the rectangle is #{@length}#{@unit} and the breadth of the rectangle is #{@breadth} #{@unit}, find the length of the side of the square"),
          DrawShape2.new('rectangle',@length,@breadth,5,3,5,@unit,320,400,1,1),
          DrawShape2.new('rectangle',@side,@side,5,0,5,@unit,320,400,2,1),
          InlineBlock.new(TextField.new("ans1"),TextLabel.new("#{@unit}")),
          TextLabel.new("What is the perimeter of the square?"),
          InlineBlock.new(TextField.new("ans2"),TextLabel.new("#{@unit}"))
        ]
      end 
    end
    def explain
      if @choose==0
        [
          Subproblem.new([TextLabel.new("The area of a rectangle is length*breadth. Now the area is #{@side}*#{@side}=#{@area}. Length is #{@a}, therefore breadth is area/length = #{@b}.")])
        ]
      else 
        [
          Subproblem.new([TextLabel.new("The area of a rectangle is length*breadth. Now the area is #{@length}*#{@breadth}=#{@area}. Therefore breadth is  square root of area = #{@side}.")])
        ]
      end
    end
  end

  class Try11_3<QuestionWithExplanation
    def self.type
      "Try11_3"
    end
    def initialize
      @a = rand(5)+1
      @b = rand(5)+1
      @side = @a+@b
      @area1 = @side*@side
      @perimeter1 = 4*(@side)
      @length=@a 
      @breadth = @a+2*@b
      @choose = rand(2)
      @perimeter2= 4*@side
      @area2=@length*@breadth
      @d = rand(2)
      @unit = UNITS[@d]
    end
    def solve
      if @choose==0
       {
        "ans1"=>@breadth,
        "ans2"=>@perimeter2,
        "ans3"=>@area2
       }
       else
       {
        "ans1"=>@side,
        "ans2"=>@perimeter1,
        "ans3"=>@area1
       }
       end 
    end
    def text
      if @choose==0
        [
          TextLabel.new("A wire is in the shape of a square of side #{@side}#{@unit}.If the wire is rebent into a rectangle of length #{@length}#{@unit}. Find its breadth."),
          DrawShape2.new('rectangle',@side,@side,5,3,5,@unit,310,300,1,1),
          DrawShape2.new('rectangle',@length,@breadth,5,1,5,@unit,310,300,2,1),
          InlineBlock.new(TextField.new("ans1"),TextLabel.new("#{@unit}")),
          TextLabel.new("Also calculate the perimeter  and area of the rectangle"),
          InlineBlock.new(TextLabel.new("Perimeter = "),TextField.new("ans2"),TextLabel.new("#{@unit}")),
          InlineBlock.new(TextLabel.new("Area = "),TextField.new("ans3"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")))
        ]
      else
[
          TextLabel.new("A wire is in the shape of a rectangle of length #{@length}#{@unit} and breadth #{@breadth}#{@unit}.If the wire is rebent into a shape of a square. Find its side length."),
          DrawShape2.new('rectangle',@side,@side,5,3,5,@unit,310,300,1,1),
          DrawShape2.new('rectangle',@length,@breadth,5,1,5,@unit,310,300,2,1),
          InlineBlock.new(TextField.new("ans1"),TextLabel.new("#{@unit}")),
          TextLabel.new("Also calculate the perimeter  and area of the rectangle"),
          InlineBlock.new(TextLabel.new("Perimeter = "),TextField.new("ans2"),TextLabel.new("#{@unit}")),
          InlineBlock.new(TextLabel.new("Area = "),TextField.new("ans3"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")))
        ]
      end 
    end
    def explain
      if @choose==0
        [
          Subproblem.new([TextLabel.new("Since the same wire was rebent, the perimeter of both the figures is the same.The perimeter of the square was 4*sidelength=#{@perimeter1}, the length of the rectangle was #{@length}.Therefore breadth is (perimeter-2*length)/2 = #{@breadth}. The new area and perimeter can now be calculated easily.")])
        ]
      else 
        [
          Subproblem.new([TextLabel.new("Since the same wire was rebent, the perimeter of both the figures is the same.The perimeter of the rectangle was 2*(length+breadth)=#{@perimeter1}.Therefore sidelength of square is (perimeter)/4 = #{@side}. The new area and perimeter can now be calculated easily.")])
        ]
      end
    end
  end

  class Try11_4<QuestionWithExplanation
    def self.type
      "Try11_4"
    end
    def initialize
      @a = rand(3)+2
      @b = rand(2)+3
      @side = @a+@b
      @area1 = @a*@b
      @length=rand(5)+7 
      @breadth = rand(5)+7 
      # @choose=1
      @choose = rand(2)
      @perimeter2= 2*(@length+@breadth)
      @area2=@length*@breadth
      @area=@area2-@area1
      @d = 3
      @unit = UNITS[@d]
      @cost1=(rand(5)+1)*10
      @cost2=(rand(10)+1)*10
      @figure=[]
      @figure[0]=0
      @figure[1]=0
      @figure[2]=0

      @figure[3]=@length
      @figure[4]=0
      @figure[5]=@breadth

      @figure[6]=@length
      @figure[7]=@breadth
      @figure[8]=@length

      @figure[9]=0
      @figure[10]=@breadth
      @figure[11]=0

      @figure[12]=0
      @figure[13]=0
      @figure[14]=@a

      @figure[15]=@a
      @figure[16]=0
      @figure[17]=@b

      @figure[18]=@a
      @figure[19]=@b
      @figure[20]=0

      @figure[21]=0
      @figure[22]=@b
      @figure[23]=0


    end
    def solve
      if @choose==0
       {
        "ans1"=>@area*@cost1
       }
       else
       {
        "ans1"=>@area2,
        "ans2"=>@area2*@cost1*10,
        "ans3"=>@perimeter2*@cost2
       }
       end 
    end
    def text
      if @choose==0
        [
          InlineBlock.new(TextLabel.new("A door of length #{@a}m and breadth #{@b}m is fitted in a wall.The length of the wall is #{@length}m and the breadth is #{@breadth}m.Find the cost of white washing the wall, if the rate of white washing the wall is Rs#{@cost1} per"),
            Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2"))),
           DrawShape3.new(@figure,'m',50,50,1),
          InlineBlock.new(TextField.new("ans1"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2"))),
       ]
      else
[
          TextLabel.new("The length and the breadth of a rectangular piece of land are #{@length} m and #{@breadth} m respectively. Find:"),
          DrawShape2.new('rectangle',@length,@breadth,5,3,5,@unit,700,300,2,1),
          TextLabel.new("Area of the land"),
          InlineBlock.new(TextLabel.new("Area = "),TextField.new("ans1"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2"))),
          TextLabel.new(""),
          InlineBlock.new(TextLabel.new("The cost of land if 1"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")),TextLabel.new("costs Rs#{10*@cost1}")),
          TextField.new("ans2"),
          TextLabel.new(" Also find the cost of fencing at the rate of Rs #{@cost2} per metre."),
          TextField.new("ans3")

        ]
      end 
    end
    def explain
      if @choose==0
        [
          Subproblem.new([TextLabel.new("Area of door is #{@a}*#{@b}=#{@area1}. Area of wall is #{@length}*#{@breadth}=#{@area2}. Therefore, area to be white washed #{@area2}-#{@area1}=#{@area}. Therefore cost is#{@area}*#{@cost1}=#{@area*@cost1}.")])
        ]
      else 
        [
          Subproblem.new([TextLabel.new("Area of land is #{@length}*#{@breadth}=#{@area2}. So, cost of land is #{10*@cost1}*#{@area2}=#{10*@cost1*@area2}. Perimeter of the land is #{@perimeter2}. Therefore cost of fencing is #{@perimeter2}*#{@cost2}=#{@perimeter2*@cost2}")])
        ]
      end
    end
  end

  class Per_parallelogram<QuestionWithExplanation
    def self.type
      "Per_parallelogram"
    end
    def initialize
      @a = rand(5)+1
      @b = rand(5)+1
      @c = rand(10)+10
      @choose=2
      @d = rand(2)
      @unit = UNITS[@d]
      @height=rand(20)+5
      @base=rand(20)+5
      @figure=[]
      @figure[0]=@a
      @figure[1]=0
      @figure[2]=@base

      @figure[3]=@a+@base
      @figure[4]=0
      @figure[5]=@height

      @figure[6]=@base
      @figure[7]=@height
      @figure[8]=@base

      @figure[9]=0
      @figure[10]=@height
      @figure[11]=@height

      # @figure[12]=@a
      # @figure[13]=0
      # @figure[14]=@height

      # @figure[15]=@a
      # @figure[16]=@height
      # @figure[17]=0
      
    end
    def solve
      {
        "ans"=>2*(@base+@height)
        # "ans"=>@height
      }
    end
    def text
      [
        TextLabel.new("What is the perimeter of the folowing parallelogram ?"),
        DrawShape3.new(@figure,@unit,50,50,1),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("#{@unit}"))
      ]
    end
    def explain
      [
        SubLabel.new("The perimeter of a parallelogram is the sum of the sides.")
      ]
    end
  end


  class Area_parallelogram<QuestionWithExplanation
    def self.type
      "Area_parallelogram"
    end
    def initialize
      @a = rand(5)+1
      @b = rand(5)+1
      @c = rand(10)+10
      @choose=2
      @d = rand(2)
      @unit = UNITS[@d]
      @height=rand(20)+5
      @base=rand(20)+5
      @figure=[]
      @figure[0]=@a
      @figure[1]=0
      @figure[2]=@base

      @figure[3]=@a+@base
      @figure[4]=0
      @figure[5]=0

      @figure[6]=@base
      @figure[7]=@height
      @figure[8]=0

      @figure[9]=0
      @figure[10]=@height
      @figure[11]=0

      @figure[12]=@a
      @figure[13]=0
      @figure[14]=@height

      @figure[15]=@a
      @figure[16]=@height
      @figure[17]=0
      
    end
    def solve
      {
        "ans"=>(@base*@height)
        # "ans"=>@height
      }
    end
    def text
      [
        TextLabel.new("What is the area of the folowing parallelogram ?"),
        DrawShape3.new(@figure,@unit,50,50,1),
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")))
      ]
    end
    def explain
      [
        SubLabel.new("The area of a parallelogram is (base*height).")
      ]
    end
  end

  class Try11_5<QuestionWithExplanation
    def self.type
      "Try11_5"
    end
    def initialize
      @a = rand(5)+1
      @b = rand(5)+1
      @c = rand(10)+10
      @choose=2
      @d = rand(2)
      @unit = UNITS[@d]
      @height=rand(20)+5
      @base=rand(20)+5
      @figure=[]
      @figure[0]=@a
      @figure[1]=0
      @figure[2]=@base

      @figure[3]=@a+@base
      @figure[4]=0
      @figure[5]=0

      @figure[6]=@base
      @figure[7]=@height
      @figure[8]=0

      @figure[9]=0
      @figure[10]=@height
      @figure[11]=0

      @figure[12]=@a
      @figure[13]=0
      @figure[14]=0

      @figure[15]=@a
      @figure[16]=@height
      @figure[17]=0
      
    end
    def solve
      {
        "ans"=>@height
        # "ans"=>@height
      }
    end
    def text
      [
        InlineBlock.new(TextLabel.new("The area of the folowing parallelogram is #{@base*@height}"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")),TextLabel.new("Find the height")),
        DrawShape3.new(@figure,@unit,10,20,1),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("#{@unit}"))
      ]
    end
    def explain
      [
        SubLabel.new("The area of the parallelogram is (base*height)=#{@base*@height}. Length of the base is #{@base}. Therefore height is #{@base*@height}/#{@base}=#{@height}")
      ]
    end
  end

  class Try11_6<QuestionWithExplanation
    def self.type
      "Try11_6"
    end
    def initialize
      @a = rand(10)+10
      @b = rand(10)+10
      @c = rand(10)+10
      # @choose = rand(3)
      @choose=2
      @d = rand(2)
      @unit = UNITS[@d]
      @height=0
      @base=0
      @angle=0
      @PI= Math.acos(-1)
      if @choose==0
        @base=@a
        @height = (@a/2.0)*Math.tan(@PI/3)
      elsif @choose==1
          @angle = Math.acos(@b/(2.0*@a))
          @height = (@b/2.0)*(Math.tan(@angle))
          @base=@b
      else
        @cosA = (@b*@b+@c*@c-@a*@a)/(2.0*@b*@c)
        @angleA = Math.acos(@cosA)
        @sinA = Math.sin(@angleA)
        @radius = @a/(2.0*Math.sin(@angleA))
        @cosB = (@a*@a+@c*@c-@b*@b)/(2.0*@a*@c)
        @angleB = Math.acos(@cosB)
        @a1 = @radius*@sinA
        @a2 = @radius*@cosA
        @b2 = @radius*Math.sin(0.5*@PI-(@angleA+2*@angleB))
        if @a2>@b2
          @height = @a2-@b2
        else
          @height = @b2-@a2
        end
        @base=2*@a1
      end
    end
    def solve
      {
        # "ans"=>((@base*@height)/2.0).round
        "ans"=>@base.round
      }
    end
    def text
      if @choose==0
      [
        InlineBlock.new(TextLabel.new("The area of the folowing triangle  is #{((@base*@height)/2.0).round(2)}"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")),TextLabel.new("The height is #{@height.round(2)}#{@unit}. Find the base to the nearest integer value")),
        DrawShape2.new('eqtriangle',@a,@a,20,0,280,@unit,300,300,1,1),
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")))
      ]
      elsif @choose==1
      [
        InlineBlock.new(TextLabel.new("The area of the folowing triangle is #{((@base*@height)/2.0).round(2)}"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")),TextLabel.new("The height is #{@height.round(2)}#{@unit}. Find the base to the nearest integer value")),
        DrawShape2.new('isotriangle',@a,@b,15,0,280,@unit,300,300,1,1),
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")))
      ]
      else
      [
        InlineBlock.new(TextLabel.new("The area of the folowing triangle is #{((@base*@height)/2.0).round(2)}"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")),TextLabel.new("The height is #{@height.round(2)}#{@unit}. Find the base to the nearest integer value")),
        DrawShape2.new('scalene',@a,@b,@c,0,1,@unit,300,300,1,1),
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")))
      ]
      end
    end
    def explain
      [
        SubLabel.new("The area of the triangle is 1/2(base*height)=#{((@base*@height)/2.0).round(2)}. Height is #{@height.round(2)}.Therefore base length is 2*area/height = #{@base.round} ")
      ]
    end
  end

  class Try11_7<QuestionWithExplanation
    def self.type
      "Try11_7"
    end
    def initialize
      @a = rand(15)+5
      @b = rand(2)
      @pi = 3.14
      @unit = UNITS[@b]
      @choose=rand(2)
    end
    def solve
      if @choose==0
      {
        "ans"=>(@pi*@a*2).round(2)
      }
      else
      {
        "ans"=>(@pi*@a*@a).round(2)
      }
      end
    end
    def text
      if @choose==0
      [
        TextLabel.new("The area of the folowing circle is #{(@pi*@a*@a).round(2)}. What is its circumference?"),
        DrawShape2.new('circle',@a,@a+10,@a+10,0,1,@unit,300,300,1,1),
        InlineBlock.new(TextField.new("ans"))
      ]
      else
      [
        TextLabel.new("The circumference of the folowing circle is #{(@pi*@a*2).round(2)}. What is its area?"),
        DrawShape2.new('circle',@a,@a+10,@a+10,0,1,@unit,300,300,1,1),
        InlineBlock.new(TextField.new("ans"))
      ]
      end
    end
    def explain
      if @choose==0
      [
        SubLabel.new("The area of a circle is r*r*pi= #{(@pi*@a*@a).round(2)}.So the radius is square root of area/pi = #{@a}. Therefore the circumference is 2*pi*r= #{(@pi*@a*2).round(2)}")
      ]
      else
      [
        SubLabel.new("The circumference of a circle is 2*r*pi= #{(@pi*@a*2).round(2)}.So the radius is circumference/(pi*2) = #{@a}. Therefore the area is pi*r*r= #{(@pi*@a*@a).round(2)}")
      ]
      end
    end
  end

  class Try11_8<QuestionWithExplanation
    def self.type
      "Try11_8"
    end
    def initialize
      @a = rand(10)+5
      @b = @a*5
      @c = rand(10)+1
      @pi = 3.14
      @unit = UNITS[3]
      # @choose=1
      @choose=rand(2)
      @PI= Math.acos(-1)
    end
    def solve
      if @choose==0
      {
        "ans"=>(@pi*@a*4).round(2)
      }
      else
      {
        "ans"=>(@pi*(@a+2)*2).round(2)
      }
      end
    end
    def text
      if @choose==0
      [
        TextLabel.new("Find the perimeter of the given shape.Radius of the arcs is #{@a}#{@unit}.(Use PI=3.14)"),
        DrawShape2.new('arc_1',2*@b+50,@b+50,@a,0,1,-@PI,500,500,1,1),
        DrawShape2.new('arc_2',3*@b+50,2*@b+50,@a,0,1,@PI/2.0,500,500,1,0),
        DrawShape2.new('arc_1',3*@b+50,2*@b+50,@a,0,1,1.5*@PI,500,500,1,0),
        DrawShape2.new('arc_2',2*@b+50,3*@b+50,@a,0,1,@PI,500,500,1,0),
        DrawShape2.new('arc_1',@b+50,2*@b+50,@a,-@PI,1,@PI/2.0,300,300,1,0),
        DrawShape2.new('arc_2',@b+50,2*@b+50,@a,-@PI,1,-@PI/2.0,300,300,1,0),
        InlineBlock.new(TextField.new("ans"))
      ]
      else
      [
        TextLabel.new("Sudhanshu divides a circular disc of radius #{@a} cm in two equal parts. What is the perimeter of each semicircular shape disc?(Use PI=3.14)"),
        DrawShape2.new('circle',@a,@a+10,@a+10,0,1,@unit,500,500,1,1),
        InlineBlock.new(TextField.new("ans"))
      ]
      end
    end
    def explain
      if @choose==0
      [
        SubLabel.new("The shape is composed of 4 semicircles. Therefore its perimeter is 4*pi*radius=#{(@pi*@a*4).round(2)}")
      ]
      else
      [
        SubLabel.new("The circumference of a semicircle is r*pi= #{(@pi*@a).round(2)}.Also we need to add the diameter. Therefore the perimeter is #{(@pi*@a).round(2)} +2*radius=#{(@pi*(@a+2)*2).round(2)}")
      ]
      end
    end
  end

  class Try11_9<QuestionWithExplanation
    def self.type
      "Try11_9"
    end
    def initialize
      @a = rand(10)+5
      @b = rand(5)+3
      while @b==@a do
      @b = rand(5)+3
      end
      @c = rand(3)
      @pi = 3.14
      @unit = UNITS[@c]
      
      @PI= Math.acos(-1)
    end
    def solve
      {
        "ans1"=>(@pi*@a*@a).round(2),
        "ans2"=>(@pi*@b*@b).round(2),
        "ans3"=>(@pi*((@a*@a)-(@b*@b))).round(2)
      }
    end
    def text
      [
        TextLabel.new("The adjoining figure shows two circles with the same centre. The radius of the larger circle is #{@a} cm and the radius of the smaller circle is #{@b} cm"),
        DrawShape2.new('circle',@a,@a+5,@a+5,0,1,@unit,300,300,0,1),
        DrawShape2.new('circle',@b,@a+5,@a+5,0,1,@unit,300,300,0,0),
        TextLabel.new("Find the area of the larger circle(Use pi =3.14)"),
        InlineBlock.new(TextField.new("ans1")),
        TextLabel.new("Find the area of the smaller circle(Use pi =3.14)"),
        InlineBlock.new(TextField.new("ans2")),
        TextLabel.new("Find the area between the two circles(Use pi =3.14)"),
        InlineBlock.new(TextField.new("ans3")),
      ]
    end
    def explain
      [
        SubLabel.new("The area of a circle is r*r*pi.Therefore, area of outer circle is #{(@pi*@a*@a).round(2)}"),
        SubLabel.new("The area of a circle is r*r*pi.Therefore, area of inner circle is #{(@pi*@b*@b).round(2)}"),
        SubLabel.new("Therefore, area between the 2 circles is #{(@pi*@a*@a).round(2)}-#{(@pi*@b*@b).round(2)} = #{(@pi*((@a*@a)-(@b*@b))).round(2)}"),

      ]
    end
  end

  class Try11_10<QuestionWithExplanation
    def self.type
      "Try11_10"
    end
    def initialize
      @a = rand(15)+5
      @b = rand(5)+1
      @unit = UNITS[@b]
      @cost1=(rand(5)+1)*10
      @cost2=(rand(10)+1)*10
      @choose= rand(2)
      @pi=3.14
    end
    def solve
      if @choose==0
       {
        "ans"=>(@a*@a*@pi*@cost1).round(2)
        } 
      else
        {
          "ans1"=>(2*@pi*@a*@b).round(2),
          "ans2"=>(2*@a*@pi*@cost2*@b).round(2)
        }
      end
    end
    def text
      if @choose==0
      [
        InlineBlock.new(TextLabel.new("Find the cost of polishing a circular table-top of radius #{@a} #{@unit}, if the rate of polishing is Rs #{@cost1} per"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")), TextLabel.new("Take pi = 3.14")),
        DrawShape2.new('circle',@a,@a+1,@a+1,1,1,@unit,300,300,1,1),
        InlineBlock.new(TextLabel.new("Rs"),TextField.new("ans"))
      ]
      else
      [
        InlineBlock.new(TextLabel.new("A gardener wants to fence a circular garden of radius #{@a}#{@unit}. Find the length of the rope he needs to purchase, if he makes #{@b} rounds of fence. Also find the costs of rope,if it cost Rs#{@cost2} per #{@unit}. Take pi = 3.14")),
        DrawShape2.new('circle',@a,@a+1,@a+1,1,1,@unit,300,300,1,1),
        InlineBlock.new(TextLabel.new("Length of rope ="),TextField.new("ans1"),TextLabel.new("#{@unit}")),
        TextLabel.new(""),
        InlineBlock.new(TextLabel.new("Cost of rope = Rs"),TextField.new("ans2"))
      ]
      end
    end
    def explain
      if @choose==0
      [ 
        SubLabel.new("The area of a circle is r*r*pi. Therefore the area is #{(@a*@a*@pi).round(2)}. Cost per unit area is Rs #{@cost1}. Therefore total cost is #{(@a*@a*@pi*@cost1).round(2)}") 
      ]
      else
      [ 
        SubLabel.new("The circumference of a circle is 2*r*pi. Therefore the length of #{@b} rounds is #{(2*@pi*@a*@b).round(2)}. Cost per unit length is Rs #{@cost2}. Therefore total cost is #{(2*@a*@pi*@cost2*@b).round(2)}")
      ]
      end
    end
  end

  class Try11_11<QuestionWithExplanation
    def self.type
      "Try11_11"
    end
    def initialize
      @a = rand(5)+1
      @b = 44*@a
      @person, @person2 = Names.generate(2)
      @unit = UNITS[@b]
      @cost1=(rand(5)+1)*10
      @cost2=(rand(10)+1)*10
      @choose= rand(2)
      @pi=22/7
    end
    def solve
       {
        "ans1"=>@a*7,
        "ans2"=>((@a*7)*(@a)*22),
        "ans3"=>11*@a,
        "circle"=>((((@a*7)*(@a*22))-((11*@a)*(11*@a)))>0) ? "circle" : "square"
        } 
    end
    def text
      [
        InlineBlock.new(TextLabel.new(" #{@person} took a wire of length #{@b} cm and bent it into the shape of a circle. Find the radius of that circle.(Take pi=22/7)")),
        TextLabel.new(""),
        InlineBlock.new(TextField.new("ans1"),TextLabel.new("cm")),
        TextLabel.new(""),
        InlineBlock.new(TextLabel.new("Also find its area."),TextField.new("ans2"),Exponent.new(TextLabel.new("cm"),TextLabel.new("2"))),
        TextLabel.new("If the same wire is bent into the shape of a square, what will be the length of each of its sides? "),
        TextField.new("ans3"),
        TextLabel.new("Which figure encloses more area, the circle or the square?"),
        Dropdown.new("circle", "circle", "square")
      ]
    end
    def explain
      [ 
        SubLabel.new("The length of the wire is #{@b}. The circumference of a circle is 2*pi*radius. Therefore radius is #{@b}/(2*pi)=#{@a*7}. The perimeter of square is 4*sidelength. Therefore sidelength of square is #{@b}/4 = #{@a*11}. Now you can easily find their areas.")
      ]
    end
  end  


  class Try11_12<QuestionWithExplanation
    def self.type
      "Try11_12"
    end
    def initialize
      @a = rand(2)+1
      @b = 7*@a
      @c= rand(7)+2
      @d= 44*@a*@c
      @unit = UNITS[@b]
      @cost1=(rand(5)+1)*10
      @cost2=(rand(10)+1)*10
      # @choose=0
      @radius=rand(10)+10
      @choose= rand(2)
      @pi=3.14
    end
    def solve
      if @choose==0
      {
        "ans"=>@c*100,
      } 
      else
      {
        "ans"=>((@pi*@c*@radius)/6).round(2)
      }
      end
    end
    def text
      if @choose==0
      [
        InlineBlock.new(TextLabel.new("How many times a wheel of radius #{@b}cm must rotate to go #{@d} m?(Take pi= 22/7)")),
        TextField.new("ans")
      ]
      else
      [
        TextLabel.new("The minute hand of a circular clock is #{@radius} cm long. How far does the tip of the minute hand move in #{@c} hours.(Take pi = 3.14)"),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("cm"))
      ]
    end
    end
    def explain
      if @choose==0
      [ 
        SubLabel.new(" The circumference of a circle is 2*pi*radius. Therefore circumference is #{44*@a}. Now in order to cover #{@d} m the circle must rotate 100*#{@d}/#{44*@a} = #{@c*100}")
      ]
      else
      [
        SubLabel.new("In 1 hour the minute hand covers 2*pi/12 degrees moving a distance of (2*pi/12)*radius= #{((@pi*@radius)/6).round(2)}. Therefore in #{@c} hours it covers #{((@pi*@c*@radius)/6).round(2)}")
      ]
      end
    end
  end  

  class Try11_13<QuestionWithExplanation
    def self.type
      "Try11_13"
    end
    def initialize
      @length1 = rand(15)+5
      @breadth1= rand(15)+5
      @c= rand(2)+2
      @length2=@length1-2*@c
      @breadth2=@breadth1-2*@c
      @area1= @length1*@breadth1
      @area2= @length2*@breadth2
      @area=@area1-@area2
      @cost1=(rand(5)+1)*10
      @d = rand(3)
      @place1=PLACE1[@d]
      @place2=PLACE2[@d]
      @unit= "m"
    end
    def solve
      {
        "ans1"=>@area,
        "ans2"=>@area*@cost1
      } 
    end
    def text
      [
        InlineBlock.new(TextLabel.new("A rectangular #{@place1} is #{@length1}m long and #{@breadth1} m wide. A #{@place2} #{@c} m wide is constructed inside the #{@place1}. Find the area of the #{@place2}.")),
        DrawShape2.new('rectangle',@length1,@breadth1,5,3,5,@unit,300,300,1,1),
        DrawShape2.new('rectangle',@length2,@breadth2,5+@c,0,5+@c,@unit,300,300,1,0),
        TextField.new("ans1"),
        TextLabel.new(""),
        InlineBlock.new(TextLabel.new("Also find the cost of cementing it at the rate of Rs #{@cost1} per"),Exponent.new(TextLabel.new("m"),TextLabel.new("2"))),
        TextLabel.new(""),
        InlineBlock.new(TextLabel.new("Rs"),TextField.new("ans2"))
      ]
    end
    def explain
      [ 
        SubLabel.new(" The area of the #{@place1} is #{@length1}*#{@breadth1}=#{@area1}. The area of the #{@place1} without #{@place2} is #{@length2}*#{@breadth2}=#{@length2*@breadth2}. Therefore the area of the #{@place2} is #{@area1}-#{@area2}= #{@area1-@area2}. Therefore the cost incurred is Rs#{@cost1}*#{@area}=Rs#{@cost1*@area}.")
      ]
    end
  end  

  class Try11_14<QuestionWithExplanation
    def self.type
      "Try11_14"
    end
    def initialize
      @length1 = 2*(rand(10)+5)
      @breadth1= 2*(rand(10)+5)
      @c= rand(2)+2
      @g = rand(3)+1
      @length2=2*@g
      @breadth2=@length2
      @area1= @length1*@breadth1
      @area2= @length1*@breadth2
      @area3=@breadth1*@breadth2
      @area4=@breadth2*@breadth2
      @area5=@area2+@area3-@area4
      @area=@area1-@area2-@area3+@area4
      @cost1=(rand(5)+1)*10
      @cost2=(rand(10)+1)*10
      @d = rand(3)
    end
    def solve
      {
        "ans1"=>@area5,
        "ans2"=>@area5*@cost1,
        "ans3"=>@area,
        "ans4"=>@area*@cost2
      } 
    end
    def text
      [
        InlineBlock.new(TextLabel.new("Two cross roads,each of width #{@length2} m,run at right angles through the centre of a rectangular park of length #{@length1} m and breadth #{@breadth1} m and parallel to its sides. Find the area of the roads. Also find the cost of constructing the roads at the rate of Rs #{@cost1} per"),Exponent.new(TextLabel.new("m"),TextLabel.new("2"))),
        DrawShape2.new('rectangle',@length1,@breadth1,5,3,5,@unit,400,400,1,1),
        DrawShape2.new('rectangle',@length2,@breadth1,5+(@length1-@length2)/2,0,5,@unit,400,400,1,0),
        DrawShape2.new('rectangle',@length1,@breadth2,5,0,5+(@breadth1-@breadth2)/2,@unit,400,400,1,0),
        InlineBlock.new(TextLabel.new("Area of roads = "),TextField.new("ans1"),Exponent.new(TextLabel.new("m"),TextLabel.new("2"))),
        TextLabel.new(""),
        InlineBlock.new(TextLabel.new("Cost of roads = Rs"),TextField.new("ans2")),
        TextLabel.new(""),
        InlineBlock.new(TextLabel.new("Also find the area of the park excluding cross roads and the cost of planting grass in at the rate of Rs #{@cost2}"),Exponent.new(TextLabel.new("m"),TextLabel.new("2"))),
        TextLabel.new(""),
        InlineBlock.new(TextLabel.new("Area of the park excluding cross roads"),TextField.new("ans3"),Exponent.new(TextLabel.new("m"),TextLabel.new("2"))),
        TextLabel.new(""),
        InlineBlock.new(TextLabel.new("Cost of planting grass = Rs"),TextField.new("ans4"))
      ]
    end
    def explain
      [ 
        SubLabel.new(" The area of the park is #{@length1}*#{@breadth1}=#{@area1}.The area of the roads is #{@length1*@breadth2}+#{@breadth1*@breadth2}-#{@breadth2*@breadth2}=#{@area5}. Therefore the cost of roads is Rs#{@cost1}*#{@area5}=Rs#{@cost1*@area5}.The area of the park without roads is #{@area1}-#{@area5}=#{@area}. Therefore the cost incurred in planting grass in it is Rs#{@cost2}*#{@area}=Rs#{@cost2*@area}.")
      ]
    end
  end  

  class Try11_15<QuestionWithExplanation
    def self.type
      "Try11_15"
    end
    def initialize
      @length1 = 2*(rand(10)+5)
      @breadth1= 2*(rand(10)+5)
      @c= @breadth1/2
      if @length1<@breadth1
        @c=@breadth1/2
      end
      @radius = rand(@c)-1
      while @radius<=0
        @radius = rand(@c)-1
      end
      @pi = 3.14
      @area1= @length1*@breadth1
      @area2= @pi*@radius*@radius
      @area=@area1-@area2
      @circumference=2*@pi*@radius
      @d = 3
      @unit= UNITS[@d]
    end
    def solve
      {
        "ans1"=>@area1,
        "ans2"=>@area2.round(2),
        "ans3"=>@area.round(2),
        "ans4"=>@circumference.round(2)
      } 
    end
    def text
      [
        InlineBlock.new(TextLabel.new("The adjoining figure represents a rectangular lawn with a circular flower bed in the middle. Find:(Use pi = 3.14)")),
        DrawShape2.new('rectangle',@length1,@breadth1,5,3,5,@unit,400,400,1,1),
        DrawShape2.new('circle',@radius,10+@length1,10+(@breadth1),1,5,@unit,400,400,1,0),
        InlineBlock.new(TextLabel.new("Area of the whole land? = "),TextField.new("ans1"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2"))),
        TextLabel.new(""),
        InlineBlock.new(TextLabel.new("Area of the flower bed? = "),TextField.new("ans2"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2"))),
        TextLabel.new(""),
        InlineBlock.new(TextLabel.new("Area of the lawn excluding the flower bed? = "),TextField.new("ans3"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2"))),
        TextLabel.new(""),
        InlineBlock.new(TextLabel.new("Circumference of the flower bed ="),TextField.new("ans4"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2"))),
        TextLabel.new(""), 
      ]
    end
    def explain
      [ 
        SubLabel.new(" The area of the lawn is #{@length1}*#{@breadth1}=#{@area1}.The area of the flower bed is radius*radius*pi = #{@area2.round(2)}.The area of the lawn without flower bed is #{@area1}-#{@area2.round(2)}=#{@area.round(2)}. The circumference of the flower bed is 2*pi*Radius= #{@circumference.round(2)}.")
      ]
    end
  end  


PROBLEMS = [
    
   
   PerimeterandArea::Createkb4,
   PerimeterandArea::Per_circle,
   PerimeterandArea::Per_rectangle,
   PerimeterandArea::Per_triangle,
   PerimeterandArea::Per_regpolygon,
   PerimeterandArea::Area_circle,
   PerimeterandArea::Area_rectangle,
   PerimeterandArea::Area_triangle,
   PerimeterandArea::Unit_conversion,
   PerimeterandArea::Try11_1,
   PerimeterandArea::Try11_2,
   PerimeterandArea::Try11_3,
   PerimeterandArea::Try11_4,
   PerimeterandArea::Area_parallelogram,
   PerimeterandArea::Try11_5,
   PerimeterandArea::Try11_6,
   PerimeterandArea::Try11_7,
   PerimeterandArea::Try11_8,
   PerimeterandArea::Try11_9,
   PerimeterandArea::Try11_10,
   PerimeterandArea::Try11_11,
   PerimeterandArea::Try11_12,
   PerimeterandArea::Try11_13,
   PerimeterandArea::Try11_14,
   PerimeterandArea::Try11_15,
   PerimeterandArea::Per_parallelogram
    
    ] # //Anurag is module name and dummy is class name
end