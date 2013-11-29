require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml'
require_relative './preg6'
require_relative '../modules/names'
require_relative './c6'
require_relative './perimeterandarea.rb'
require_relative './perimeterandarea_6.rb'
require 'prime'
require 'set'
# TODO override preprocess for the add commas question ( default is now to remove commas )
include ToHTML
include PreG6
include PerimeterandArea

module Mensuration_8
  INDEX = 21
  TITLE = "Mensuration 2"
  
  UNITS = ["mm","cm","dc","m","Dm","hm","km" ]
  UNITS2 = ["millimeter", "centimeter", "decimeter","meter","decameter","hectometer","kilometere"]
  PLACE1= ["garden","park","room"]
  PLACE2= ["path","path","verandah"]
  VALUE1= ["twiced","thriced","quadrupled","increased five times"]
  VALUE2= ["half","one third", "one fourth", "one fifth"]
  
  class Area_rhombus<QuestionWithExplanation
    def self.type
      "Area_rhombus"
    end
    def initialize
      @a = rand(15)+5
      @b = rand(15)+5
      @c= rand(3)
      @d = 2*(rand(7)+5)
      @area = (@a*@d)/2
      @unit = UNITS[@c]
      @choose= rand(2)+1
    end
    def solve
    if @choose==1
    if((@a%2==1)and(@b%2==1))
      {
        "ans"=>(@a*@b)/2.0
      }
    else
      {
        "ans"=>(@a*@b)/2
      }
    end
    else
    {
    	"ans"=>@a
    }
    end
    end
    def text
    if @choose==1
    [
        TextLabel.new("Find the area of a rhombus whose diagonals are of lengths #{@a} #{@unit} and #{@b}#{@unit}."),
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")))
    ]
    else
    [
    	InlineBlock.new(TextLabel.new("The area of a rhombus is #{@area}"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")),TextLabel.new("and one of the diagonals is #{@d}#{@unit}. Find the other diagonal.")),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("#{@unit}"))
    ]
    end
    end
    def explain
    if @choose==1
      [
        SubLabel.new("The area of a rhombus is (diagonal1*diagonal2)/2.")
      ]
    else
    [
    	SubLabel.new("The area of a rhombus is (diagonal1*diagonal2)/2. The area of the given rhombus is #{@area}, one diagonal is #{@d}. Therefore, the length of the other diagonal is 2*area/diagonal1= #{@a}")
    ]
    end
    end
  end

  class Area_trapezium<QuestionWithExplanation
    def self.type
      "Area_trapezium"
    end
    def initialize
      @a = rand(20)+15
      @b = rand(10)+5
      while((@a-@b)%2==1) do
      	@b = rand(10)+5
      end
      @height=rand(10)+10
      @trapezium=[]
      
      @trapezium[0]=0
      @trapezium[1]=0
      @trapezium[2]=@a
      
      @trapezium[3]=@a
      @trapezium[4]=0
      @trapezium[5]=0
      
      @trapezium[6]=@a-(@a-@b)/2
      @trapezium[7]=-@height
      @trapezium[8]=@height
      
      @trapezium[9]=@a-(@a-@b)/2
      @trapezium[10]=0
      @trapezium[11]=0

      @trapezium[12]=@a-(@a-@b)/2
      @trapezium[13]=-@height
      @trapezium[14]=@b

      @trapezium[15]=(@a-@b)/2
      @trapezium[16]=-@height
      @trapezium[17]=0


      @trapezium1=[]
      
      @trapezium1[0]=0
      @trapezium1[1]=0
      @trapezium1[2]=@a
      
      @trapezium1[3]=@a
      @trapezium1[4]=0
      @trapezium1[5]=0
      
      @trapezium1[6]=@a-(@a-@b)/2
      @trapezium1[7]=-@height
      @trapezium1[8]=@height
      
      @trapezium1[9]=@a-(@a-@b)/2
      @trapezium1[10]=0
      @trapezium1[11]=0

      @trapezium1[12]=@a-(@a-@b)/2
      @trapezium1[13]=-@height
      @trapezium1[14]=0

      @trapezium1[15]=(@a-@b)/2
      @trapezium1[16]=-@height
      @trapezium1[17]=0

      @c= rand(3)
      @d = 2*(rand(7)+5)
      @area = (@a+@b)*@height/2.0
      @unit = UNITS[@c]
      # @choose=1
      @choose= rand(2)+1
    end
    def solve
    if @choose==1
    if(((@a+@b)%2==1)and(@height%2==1))
      {
        "ans"=>(@a+@b)*@height/2.0
      }
    else
      {
        "ans"=>(@a+@b)*@height/2
      }
    end
    else
    {
    	"ans"=>@b
    }
    end
    end
    def text
    if @choose==1
    [
        TextLabel.new("Find the area of the following trapezium "),
        DrawShape3.new(@trapezium,@unit,60,380,1,500,500,1,1),
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")))
    ]
    else
    [
    	InlineBlock.new(TextLabel.new("The area of a trapezium is #{@area}"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")),TextLabel.new("the distance between two parallel sides is #{@height} #{@unit} and one of the parallel side is #{@a}#{@unit}. Find the other parallel side.")),
        DrawShape3.new(@trapezium1,@unit,60,380,1,500,500,1,1),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("#{@unit}"))
    ]
    end
    end
    def explain
    if @choose==1
      [
        SubLabel.new("The area of a trapezium is (height*(sum of parallel sides))/2.")
      ]
    else
    [
    	SubLabel.new("The area of a trapezium is (height*(sum of parallel sides))/2.. The area of the given trapezium is #{@area}, one parallel side is #{@a}. Therefore, the length of the other side is (2*area/height)-side1= #{@b}")
    ]
    end
    end
  end

  class Try13_1<QuestionWithExplanation
    def self.type
      "Try13_1"
    end
    def initialize
      @a = rand(15)+5
      @b = rand(15)+5
      @c= rand(3)
      @d = 2*(rand(7)+5)
      @area = (@a*@d)/2
      @unit = UNITS[@c]
      @numtiles=100*(rand(15)+5)
      @choose= rand(2)+1
      @cost=rand(5)+5
    end
    def solve
    {
      "ans"=>(@cost*@numtiles*@area)/10000.0
    }
    end
    def text
    [
        InlineBlock.new(TextLabel.new("The floor of a building consists of #{@numtiles} tiles which are rhombus shaped and each of its diagonals are #{@a} cm and #{@d} cm. Find the cost of polishing the floor if the cost per"),Exponent.new(TextLabel.new("m"),TextLabel.new("2")),TextLabel.new("is Rs #{@cost}.")),
        TextLabel.new(""),
        InlineBlock.new(TextLabel.new("Rs"),TextField.new("ans"))
    ]
    end
    def explain
      [
        SubLabel.new("The area of a rhombus is (diagonal1*diagonal2)/2. So the area of 1 tile is #{@area}. The are of #{@numtiles} tiles is #{@numtiles*@area}. Therefore the cost of polishing is #{(@cost*@numtiles*@area)/10000.0} ")
      ]
    end
  end

  class LateralSurfaceArea<QuestionWithExplanation
    def self.type
      "LateralSurfaceArea"
    end
    def initialize
      @a = rand(15)+5
      @b = rand(15)+5
      @c= rand(15)+5
      @height=rand(20)+10
      @radius=7*(rand(5)+5)
      @d = 2*(rand(7)+5)
      @area = (@a*@d)/2
      @e= rand(3)
      @unit = UNITS[@e]
      @numtiles=100*(rand(15)+5)
      # @choose=1
      @choose= rand(3)+1
      @cost=rand(5)+5
    end
    def solve
    if @choose==1
    {
      "ans"=>4*@a*@a
    }
    elsif @choose==2
    {
      "ans"=>2*(@c*(@a+@b))
    } 
    elsif @choose==3
    {
      "ans"=>(44*@radius*@height)/7
    } 
    end
    end
    def text
    if @choose==1
    [
        TextLabel.new("Find the lateral Surface Area of the following cube"),
        DrawShape2.new('cube',10,10,@a,1,1,@unit,500,500,1,1),
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")))
    ]
    elsif @choose==2
    [
        TextLabel.new("Find the lateral Surface Area of the following cuboid"),
        DrawShape2.new('cuboid_2',10,10,@a,@b,@c,@unit,500,500,1,1),
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")))
    ]
    elsif @choose==3
    [
        TextLabel.new("Find the lateral Surface Area of the following cylinder.Use pi = 22/7 "),
        DrawShape2.new('cylinder',10,10,@radius,@height,1,@unit,500,500,1,1),
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")))
    ]
    end
    end
    def explain
      if @choose==1
      [
        SubLabel.new("Lateral Surface Area of a cube 4*(area of 1 Surface = length*length)")
      ]
      elsif @choose==2
      [
        SubLabel.new("In the lateral surface of a cuboid there are 2 rectangles of dimensions #{@c*@a} and 2 rectangles of dimensions #{@c*@b} ")
      ] 
      elsif @choose==3
      [
        SubLabel.new("The lateral surface area of a cylinder is 2*pi*radius*height")
      ]
      end
    end
  end

  class Try13_2<QuestionWithExplanation
    def self.type
      "Try13_2"
    end
    def initialize
      @a = rand(15)+5
      @b = rand(15)+5
      @c= rand(15)+5
      @height=rand(20)+10
      @radius=7*(rand(5)+5)
      @d = 2*(rand(7)+5)
      @area = (@a*@d)/2
      @e= rand(3)
      @unit = UNITS[@e]
      @numtiles=100*(rand(15)+5)
      # @choose=1
      @choose= rand(4)+1
      @cost=rand(5)+5
      @area1= 4*@a*@a
      @area2= 2*(@c*(@a+@b))
      @area3= (44*@radius*@height)/7
    end
    def solve
    if @choose==1
    {
      "ans"=>@a
    }
    elsif @choose==2
    {
      "ans"=>@c
    } 
    elsif @choose==3
    {
      "ans"=>@radius
    }
    elsif @choose==4
    {
      "ans"=>@height
    } 
    end
    end
    def text
    if @choose==1
    [
        InlineBlock.new(TextLabel.new("The lateral Surface Area of the following cube is #{@area1}"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")),TextLabel.new("Find its sidelength")),
        DrawShape2.new('cube',10,10,@a,0,1,@unit,500,500,1,1),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("#{@unit}"))
    ]
    elsif @choose==2
    [
        InlineBlock.new(TextLabel.new("The lateral Surface Area of the following cuboid is #{@area2}"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")),TextLabel.new("Its length is #{@a}#{@unit} and its breadth is #{@b}#{@unit}.Find its height")),
        DrawShape2.new('cuboid_1',10,10,@a,@b,@c,@unit,500,500,1,1),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("#{@unit}"))
    ]
    elsif @choose==3
    [
        InlineBlock.new(TextLabel.new("The lateral Surface Area of the following cylinder is #{@area3}"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")),TextLabel.new("Its height is #{@height}#{@unit} .Find its radius")),
        DrawShape2.new('cylinder',10,10,@radius,@height,0,@unit,500,500,1,1),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("#{@unit}"))
    ]
  elsif @choose==4
    [
        InlineBlock.new(TextLabel.new("The lateral Surface Area of the following cylinder is #{@area3}"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")),TextLabel.new("Its radius is #{@radius}#{@unit} .Find its height")),
        DrawShape2.new('cylinder',10,10,@radius,@height,0,@unit,500,500,1,1),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("#{@unit}"))
    ]
    end
    end
    def explain
      if @choose==1
      [
        SubLabel.new("Lateral Surface Area of a cube 4*(area of 1 Surface = length*length)")
      ]
      elsif @choose==2
      [
        SubLabel.new("In the lateral surface of a cuboid there are 2 rectangles of dimensions #{@c*@a} and 2 rectangles of dimensions #{@c*@b} ")
      ] 
      elsif @choose==3
      [
        SubLabel.new("The lateral surface area of a cylinder is 2*pi*radius*height")
      ]
    elsif @choose==4
      [
        SubLabel.new("The lateral surface area of a cylinder is 2*pi*radius*height")
      ]
      end
    end
  end


  class Try13_5<QuestionWithExplanation
    def self.type
      "Try13_5"
    end
    def initialize
      @a = rand(15)+5
      @b = rand(15)+5
      @c= rand(15)+5
      @height=rand(20)+10
      @radius=7*(rand(5)+5)
      @d = 2*(rand(7)+5)
      @area = (@a*@d)/2
      @e= rand(3)
      @unit = UNITS[3]
      @numtiles=100*(rand(15)+5)
      # @choose=1
      @choose= rand(3)+1
      @cost=rand(5)+5
      @number = rand(20)+1
    end
    def solve
    if @choose==1
    {
      "ans1"=>(2*(@c*(@a+@b)))*@cost,
      "ans2"=>(2*(@c*(@a+@b))+(@a*@b))*@cost
    } 
    elsif @choose==2
    {
      "ans"=>((44*@radius*@height)/7)*@cost*@number
    } 
    end
    end
    def text
    if @choose==1
    [
        InlineBlock.new(TextLabel.new("The internal measures of a cuboidal room are #{@a} m * #{@b} m * #{@c} m. Find the total cost of whitewashing all four walls of a room, if the cost of white washing is Rs #{@cost} per"),Exponent.new(TextLabel.new("m"),2)),
        DrawShape2.new('cuboid_2',10,10,@a,@b,@c,@unit,500,500,1,1),
        InlineBlock.new(TextLabel.new("Rs"),TextField.new("ans1")),
        TextLabel.new("What will be the cost of white washing if the ceiling of the room is also whitewashed?"),
        InlineBlock.new(TextLabel.new("Rs"),TextField.new("ans2")),
    ]
    elsif @choose==2
    [
        InlineBlock.new(TextLabel.new("In a building there are #{@number} pillars.The radius of each pillar is #{@radius} #{@unit} and height is #{@height} #{@unit}. Find the total cost of painting the curved surface area of all pillars at the rate of Rs #{@cost} per"),Exponent.new(TextLabel.new("m"),TextLabel.new("2"))), 
        DrawShape2.new('cylinder',10,10,@radius,@height,1,@unit,500,500,1,1),
        InlineBlock.new(TextLabel.new("Rs"),TextField.new("ans"))
    ]
    end
    end
    def explain
      if @choose==1
      [
        SubLabel.new("Lateral Surface Area of a cube 4*(area of 1 Surface = length*length)")
      ]
      elsif @choose==2
      [
        SubLabel.new("In the lateral surface of a cuboid there are 2 rectangles of dimensions #{@c*@a} and 2 rectangles of dimensions #{@c*@b} ")
      ] 
      elsif @choose==3
      [
        SubLabel.new("The lateral surface area of a cylinder is 2*pi*radius*height")
      ]
      end
    end
  end


  class TotalSurfaceArea<QuestionWithExplanation
    def self.type
      "TotalSurfaceArea"
    end
    def initialize
      @a = rand(15)+5
      @b = rand(15)+5
      @c= rand(15)+5
      @height=rand(20)+10
      @radius=7*(rand(5)+5)
      @d = 2*(rand(7)+5)
      @area = (@a*@d)/2
      @e= rand(3)
      @unit = UNITS[@e]
      @numtiles=100*(rand(15)+5)
      # @choose=1
      @choose= rand(3)+1
      @cost=rand(5)+5
    end
    def solve
    if @choose==1
    {
      "ans"=>6*@a*@a
    }
    elsif @choose==2
    {
      "ans"=>2*(@c*(@a+@b)+(@a*@b))
    } 
    elsif @choose==3
    {
      "ans"=>(44*@radius*@height)/7+(22*@radius*@radius)/7
    } 
    end
    end
    def text
    if @choose==1
    [
        TextLabel.new("Find the total Surface Area of the following cube"),
        DrawShape2.new('cube',10,10,@a,1,1,@unit,500,500,1,1),
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")))
    ]
    elsif @choose==2
    [
        TextLabel.new("Find the total Surface Area of the following cuboid"),
        DrawShape2.new('cuboid_2',10,10,@a,@b,@c,@unit,500,500,1,1),
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")))
    ]
    elsif @choose==3
    [
        TextLabel.new("Find the total Surface Area of the following cylinder.Use pi = 22/7 "),
        DrawShape2.new('cylinder',10,10,@radius,@height,1,@unit,500,500,1,1),
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")))
    ]
    end
    end
    def explain
      if @choose==1
      [
        SubLabel.new("Total Surface Area of a cube 6*(area of 1 Surface = length*length)")
      ]
      elsif @choose==2
      [
        SubLabel.new("In the total surface of a cuboid there are 2 rectangles of dimensions #{@c*@a}, 2 rectangles of dimensions #{@b*@a} and 2 rectangles of dimensions #{@c*@b} ")
      ] 
      elsif @choose==3
      [
        SubLabel.new("The total surface area of a cylinder is (2*pi*radius*height)+(pi*radius*radius)")
      ]
      end
    end
  end


  class Try13_6<QuestionWithExplanation
    def self.type
      "Try13_6"
    end
    def initialize
      @a = rand(15)+5
      @b = rand(15)+5
      @c= rand(15)+5
      @g = rand(15)+5
      @h = rand(15)+5
      @i = rand(15)+5
      @height=rand(20)+10
      @radius=7*(rand(5)+5)
      @d = 2*(rand(7)+5)
      @area = (@a*@d)/2
      @area1 = 2*(@c*(@a+@b)+(@a*@b))
      @area2 = 2*(@i*(@g+@h)+(@g*@h))
      @e= rand(3)
      @unit = UNITS[@e]
      @numtiles=100*(rand(15)+5)
      # @choose=1
      @choose= rand(3)+1
      @cost=rand(5)+5
    end
    def solve
    if(@area1<@area2)
     {
        "cuboid1"=>"cuboid1"
     }
    else 
      {
        "cuboid1"=>"cuboid2"
     }
    end
    end
    def text
    [
        TextLabel.new("There are two cuboidal boxes as shown in the adjoining figure. Which box requires the lesser amount of material to make?"),
        DrawShape2.new('cuboid_2',10,10,@a,@b,@c,@unit,400,400,1,1),
        DrawShape2.new('cuboid_2',10,10,@g,@h,@i,@unit,400,400,2,1),
        Dropdown.new("cuboid1","cuboid1","cuboid2")
    ]
    end
    def explain
      [
        SubLabel.new("In the total surface of a cuboid there are 2 rectangles of dimensions #{@c*@a}, 2 rectangles of dimensions #{@b*@a} and 2 rectangles of dimensions #{@c*@b}. The total surface area of cuboid1 is #{@area1} and that of cuboid2 is #{@area2}")
      ] 
    end
  end

  class Try13_3<QuestionWithExplanation
    def self.type
      "Try13_3"
    end
    def initialize
      @a = rand(15)+5
      @b = rand(15)+5
      @c= rand(15)+5
      @height=rand(20)+10
      @radius=7*(rand(5)+5)
      @d = 2*(rand(7)+5)
      @area = (@a*@d)/2
      @e= rand(3)
      @unit = UNITS[@e]
      @numtiles=100*(rand(15)+5)
      # @choose=1
      @choose= rand(4)+1
      @cost=rand(5)+5
      @area1= 6*@a*@a
      @area2= 2*(@c*(@a+@b)+(@a*@b))
      @area3= (44*@radius*@height)/7+(22*@radius*@radius)/7
    end
    def solve
    if @choose==1
    {
      "ans"=>@a
    }
    elsif @choose==2
    {
      "ans"=>@c
    } 
    elsif @choose==3
    {
      "ans"=>@radius
    }
    elsif @choose==4
    {
      "ans"=>@height
    } 
    end
    end
    def text
    if @choose==1
    [
        InlineBlock.new(TextLabel.new("The total Surface Area of the following cube is #{@area1}"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")),TextLabel.new("Find its sidelength")),
        DrawShape2.new('cube',10,10,@a,0,1,@unit,500,500,1,1),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("#{@unit}"))
    ]
    elsif @choose==2
    [
        InlineBlock.new(TextLabel.new("The total Surface Area of the following cuboid is #{@area2}"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")),TextLabel.new("Its length is #{@a}#{@unit} and its breadth is #{@b}#{@unit}.Find its height")),
        DrawShape2.new('cuboid_1',10,10,@a,@b,@c,@unit,500,500,1,1),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("#{@unit}"))
    ]
    elsif @choose==3
    [
        InlineBlock.new(TextLabel.new("The total Surface Area of the following cylinder is #{@area3}"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")),TextLabel.new("Its height is #{@height}#{@unit} .Find its radius")),
        DrawShape2.new('cylinder',10,10,@radius,@height,0,@unit,500,500,1,1),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("#{@unit}"))
    ]
  elsif @choose==4
    [
        InlineBlock.new(TextLabel.new("The total Surface Area of the following cylinder is #{@area3}"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")),TextLabel.new("Its radius is #{@radius}#{@unit} .Find its height")),
        DrawShape2.new('cylinder',10,10,@radius,@height,0,@unit,500,500,1,1),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("#{@unit}"))
    ]
    end
    end
    def explain
      if @choose==1
      [
        SubLabel.new("Total Surface Area of a cube 6*(area of 1 Surface = length*length)")
      ]
      elsif @choose==2
      [
        SubLabel.new("In the total surface of a cuboid there are 2 rectangles of dimensions #{@c*@a}, 2 rectangles of dimensions #{@b*@a} and 2 rectangles of dimensions #{@c*@b} ")
      ] 
      elsif @choose==3
      [
        SubLabel.new("The total surface area of a cylinder is (2*pi*radius*height)+(pi*radius*radius)")
      ]
    elsif @choose==4
      [
        SubLabel.new("The total surface area of a cylinder is (2*pi*radius*height)+(pi*radius*radius)")
      ]
      end
    end
  end

  class Volume<QuestionWithExplanation
    def self.type
      "Volume"
    end
    def initialize
      @a = rand(15)+5
      @b = rand(15)+5
      @c= rand(15)+5
      @height=rand(20)+10
      @radius=7*(rand(5)+5)
      @d = 2*(rand(7)+5)
      @area = (@a*@d)/2
      @e= rand(3)
      @unit = UNITS[@e]
      @numtiles=100*(rand(15)+5)
      # @choose=1
      @choose= rand(3)+1
      @cost=rand(5)+5
    end
    def solve
    if @choose==1
    {
      "ans"=>@a*@a*@a
    }
    elsif @choose==2
    {
      "ans"=>@c*(@a*@b)
    } 
    elsif @choose==3
    {
      "ans"=>(22*@radius*@radius*@height)/7
    } 
    end
    end
    def text
    if @choose==1
    [
        TextLabel.new("Find the Volume of the following cube"),
        DrawShape2.new('cube',10,10,@a,1,1,@unit,500,500,1,1),
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("3")))
    ]
    elsif @choose==2
    [
        TextLabel.new("Find the Volume of the following cuboid"),
        DrawShape2.new('cuboid_2',10,10,@a,@b,@c,@unit,500,500,1,1),
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("3")))
    ]
    elsif @choose==3
    [
        TextLabel.new("Find the Volume of the following cylinder.Use pi = 22/7 "),
        DrawShape2.new('cylinder',10,10,@radius,@height,1,@unit,500,500,1,1),
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("3")))
    ]
    end
    end
    def explain
      if @choose==1
      [
        SubLabel.new("Total Volume of a cube sidelength*sidelength*sidelength")
      ]
      elsif @choose==2
      [
        SubLabel.new("Total Volume of a cuboid is length*breadth*height")
      ] 
      elsif @choose==3
      [
        SubLabel.new("The total Volume of a cylinder is (pi*radius*radius)*height")
      ]
      end
    end
  end

  class Try13_4<QuestionWithExplanation
    def self.type
      "Try13_4"
    end
    def initialize
      @a = rand(15)+5
      @b = rand(15)+5
      @c= rand(15)+5
      @height=rand(20)+10
      @radius=7*(rand(5)+5)
      @d = 2*(rand(7)+5)
      @area = (@a*@d)/2
      @e= rand(3)
      @unit = UNITS[@e]
      @numtiles=100*(rand(15)+5)
      # @choose=1
      @choose= rand(4)+1
      @cost=rand(5)+5
      @area1= @a*@a*@a
      @area2= @c*(@a*@b)
      @area3= (22*@radius*@radius*@height)/7
    end
    def solve
    if @choose==1
    {
      "ans"=>@a
    }
    elsif @choose==2
    {
      "ans"=>@c
    } 
    elsif @choose==3
    {
      "ans"=>@radius
    } 
    elsif @choose==4
    {
      "ans"=>@height
    } 
    end
    end
    def text
    if @choose==1
    [
        InlineBlock.new(TextLabel.new("The Volume of the following cube is #{@area1}"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")),TextLabel.new("Find its sidelength")),
        DrawShape2.new('cube',10,10,@a,0,1,@unit,500,500,1,1),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("#{@unit}"))
    ]
    elsif @choose==2
    [
        InlineBlock.new(TextLabel.new("The Volume Area of the following cuboid is #{@area2}"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")),TextLabel.new("Its length is #{@a}#{@unit} and its breadth is #{@b}#{@unit}.Find its height")),
        DrawShape2.new('cuboid_1',10,10,@a,@b,@c,@unit,500,500,1,1),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("#{@unit}"))
    ]
    elsif @choose==3
    [
        InlineBlock.new(TextLabel.new("The Volume of the following cylinder is #{@area3}"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")),TextLabel.new("Its height is #{@height}#{@unit} .Find its radius")),
        DrawShape2.new('cylinder',10,10,@radius,@height,0,@unit,500,500,1,1),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("#{@unit}"))
    ]
  elsif @choose==4
    [
        InlineBlock.new(TextLabel.new("The Volume of the following cylinder is #{@area3}"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")),TextLabel.new("Its radius is #{@radius}#{@unit} .Find its height")),
        DrawShape2.new('cylinder',10,10,@radius,@height,0,@unit,500,500,1,1),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("#{@unit}"))
    ]
    end
    end
    def explain
      if @choose==1
      [
        SubLabel.new("Total Volume of a cube sidelength*sidelength*sidelength")
      ]
      elsif @choose==2
      [
        SubLabel.new("Total Volume of a cuboid is length*breadth*height")
      ] 
      elsif @choose==3
      [
        SubLabel.new("The total Volume of a cylinder is (pi*radius*radius)*height")
      ]
    elsif @choose==4
      [
        SubLabel.new("The total Volume of a cylinder is (pi*radius*radius)*height")
      ]
      end
    end
  end


  class Try13_7<QuestionWithExplanation
    def self.type
      "Try13_7"
    end
    def initialize
      @a = rand(15)+5
      @b = rand(15)+5
      @c= rand(15)+5
      @e= rand(3)
      @unit = UNITS[@e]
      @choose=rand(2)+1
    end
    def solve
    if @choose==1
    {
      "ans"=>@a*@b*@c
    }
    else
    {
      "ans"=>2*@a*@b*@c
    } 
    end
    
    end
    def text
    if @choose==1
    [
        InlineBlock.new(TextLabel.new("A godown is in the shape of a cuboid of measures #{@a}#{@unit}*#{@b}#{@unit}*#{@c}#{@unit}. How many cuboidal boxes boxes can be stored in it if Volume of one box is 1"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("3")),TextLabel.new("?")),
        TextLabel.new(""),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("#{@unit}"))
    ]
  elsif @choose==2
    [
        InlineBlock.new(TextLabel.new("A godown is in the shape of a cuboid of measures #{@a}#{@unit}*#{@b}#{@unit}*#{@c}#{@unit}. How many cuboidal boxes boxes can be stored in it if Volume of one box is 0.5"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("3")),TextLabel.new("?")),
        TextLabel.new(""),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("#{@unit}"))
    ]
    end  
    end
    def explain
    if @choose==1
    [
        SubLabel.new("Total Volume of a cuboid is length*breadth*height. Therefore Volume of godown is #{@a*@b*@c}. Volumeof 1 box is 1. Therefore number of boxes is #{@a*@b*@c}")
    ] 
    else
    [
        SubLabel.new("Total Volume of a cuboid is length*breadth*height. Therefore Volume of godown is #{@a*@b*@c}. Volumeof 1 box is 0.5 . Therefore number of boxes is #{2*@a*@b*@c}")
    ] 
    end
      
    end
  end

  class Try13_9<QuestionWithExplanation
    def self.type
      "Try13_9"
    end
    def initialize
      @radius = 7*(rand(5)+5)
      @height = rand(15)+5
      @a = (44*@radius)/7
      @b = @height
      @c = rand(15)+5
      @e = rand(3)
      @unit = UNITS[@e]
      # @choose=1
      @choose=rand(2)+1
    end
    def solve
      if @choose==1
        {
        "ans"=>(22*@radius*@radius*@height)/7
        }
      else
        {
          "ans"=>(22*@radius*@radius)/7+(44*@radius*@height/7)
        } 
      end
    end
    def text
      if @choose==1
        [
        TextLabel.new("A rectangular piece of paper #{@a} #{@unit} * #{@b} #{@unit} is folded without overlapping to make a cylinder of height #{@b} #{@unit}. Find the volume of the cylinder.(Use pi = 22/7)"),
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("3")))
        ]
      elsif @choose==2
        [   
        TextLabel.new("A rectangular piece of paper #{@a} #{@unit} * #{@b} #{@unit} is folded without overlapping to make a cylinder of height #{@b} #{@unit}. Find the Total Surface Area of the cylinder.(Use pi = 22/7)"),
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")))
        ]
      end  
    end
    def explain
      if @choose==1
        [
        SubLabel.new("The height of the cylinder is #{@height}#{@unit}. The radius of the cylinder would be #{@a}/2*pi = #{@radius}. Therefore the volume(pi*radius*radius*height) would be #{(22*@radius*@radius*@height)/7}")
        ] 
      elsif @choose==2
        [
        SubLabel.new("The height of the cylinder is #{@height}#{@unit}. The radius of the cylinder would be #{@a}/2*pi = #{@radius}. Therefore the total surface rea(2*pi*radius*height+pi*radius*radius) would be #{(22*@radius*@radius)/7+(44*@radius*@height/7)}")
        ] 
      end
    end
  end

  class Try13_8<QuestionWithExplanation
    def self.type
      "Try13_8"
    end
    def initialize
      @a = 7*(rand(5)+1)
      @b = 3*(rand(5)+5)
      @c= 2*(rand(10)+5)
      @flow = 1
      @flow = Grade6ops.euclideanalg(@b, @c)
      if @flow==1
       @flow = Grade6ops.euclideanalg(@b, @a) 
      end
      if @flow==1
       @flow = Grade6ops.euclideanalg(@c, @a) 
      end
      @flow = 1

      @volume = @a*@b*@c*1000
      @unit = UNITS[3]
      # @choose=2
      @choose=rand(2)+1
    end
    def solve
      if @choose==1
        {
          "ans"=>(22*@a*@a*@b*1000)/7
         }
      elsif @choose==2
        {
          "ans"=>@volume/(60*@flow)
          # "ans"=>@a

        }  
      end
    end
    def text
      if @choose==1
        [
        TextLabel.new("A milk tank is in the form of cylinder whose radius is #{@a} m and length is #{@b} m. Find the quantity of milk in litres that can be stored in the tank?"),
       DrawShape2.new('cylinder',5,5,@a,@b,1,@unit,500,200,1,1),
       TextLabel.new(""),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("litres"))
        ]
      elsif @choose==2
        [
        TextLabel.new("Water is pouring into a cubiodal reservoir at the rate of #{@flow} litres per minute. If the dimensions of reservoir are #{@a}m * #{@b}#{@unit} * #{@c}#{@unit}, find the number of hours it will take to fill the reservoir."),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("hours"))
        ]    
      end
    end
    def explain
      if @choose==1
        [
        SubLabel.new("The total Volume of a cylinder is (pi*radius*radius)*height and 1 cubic meter =1000 litres")
        ]
      elsif @choose==2
        [
        SubLabel.new("The volume of the reservoir(length*breadth*height) is #{@volume} litres. Flow rate is #{@flow} litres per minute. Therefore time taken to fill the reservoir is (volume of reservoir)/(flowrate*60) = #{@volume/(60*@flow)} hours")
        ]   
      end
    end
  end


  class Try13_10<QuestionWithExplanation
    def self.type
      "Try13_10"
    end
    def initialize
      @a = rand(4)
      @b = rand(4)
      @c = rand(4)
      @d = rand(2)
      @e = rand(2)
      @f = rand(2)

      @place1 =VALUE1[@a]
      @place2 = VALUE2[@a]
      if @d==0
        @place3 = VALUE1[@a]
        @factor1 = @a+2
      else
        @place3 = VALUE2[@a]
        @factor1 = 1.0/(@a+2)
      end
      if @e==0
        @place4 = VALUE1[@b]
        @factor2 = @b+2
      else
        @place4 = VALUE2[@b]
        @factor2 = 1.0/(@b+2)
      end
      if @f==0
        @place5 = VALUE1[@c]
        @factor3 = @c+2
      else
        @place5 = VALUE2[@c]
        @factor3 = 1.0/(@c+2)
      end
      
      @factor = @factor1*@factor2*@factor3
      if @factor<1
        @factor4 = 1.0/@factor
      else
        @factor4 = @factor
      end
      @factor5 = @factor1*@factor1*@factor3
      if @factor5<1
        @factor7 = 1.0/@factor5
      else
        @factor7 = @factor5
      end
      @factor6 = @factor1*@factor3
      if @factor6<1
        @factor8 = 1.0/@factor6
      else
        @factor8 = @factor6
      end
      @factor=@factor.round(2)
      if (@factor7.is_a? Integer)
      else 
      @factor7=@factor7.round(2)
      end
      if (@factor8.is_a? Integer)
      else 
      @factor8=@factor8.round(2)
      end
      if ((@factor7-@factor7.to_i)==0)
        @factor7 = @factor7.to_i
      end
      if ((@factor8-@factor8.to_i)==0)
        @factor8 = @factor8.to_i
      end
      while (@factor4==1)or(@factor7==1)or(@factor8==1)
        @a = rand(4)
      @b = rand(4)
      @c = rand(4)
      @d = rand(2)
      @e = rand(2)
      @f = rand(2)

      @place1 =VALUE1[@a]
      @place2 = VALUE2[@a]
      if @d==0
        @place3 = VALUE1[@a]
        @factor1 = @a+2
      else
        @place3 = VALUE2[@a]
        @factor1 = 1.0/(@a+2)
      end
      if @e==0
        @place4 = VALUE1[@b]
        @factor2 = @b+2
      else
        @place4 = VALUE2[@b]
        @factor2 = 1.0/(@b+2)
      end
      if @f==0
        @place5 = VALUE1[@c]
        @factor3 = @c+2
      else
        @place5 = VALUE2[@c]
        @factor3 = 1.0/(@c+2)
      end
      
      @factor = @factor1*@factor2*@factor3
      if @factor<1
        @factor4 = 1.0/@factor
      else
        @factor4 = @factor
      end
      @factor5 = @factor1*@factor1*@factor3
      if @factor5<1
        @factor7 = 1.0/@factor5
      else
        @factor7 = @factor5
      end
      @factor6 = @factor1*@factor3
      if @factor6<1
        @factor8 = 1.0/@factor6
      else
        @factor8 = @factor6
      end
      @factor=@factor.round(2)
      if (@factor7.is_a? Integer)
      else 
      @factor7=@factor7.round(2)
      end
      if (@factor8.is_a? Integer)
      else 
      @factor8=@factor8.round(2)
      end
      if ((@factor7-@factor7.to_i)==0)
        @factor7 = @factor7.to_i
      end
      if ((@factor8-@factor8.to_i)==0)
        @factor8 = @factor8.to_i
      end
      end

      @choose=4
      # @choose=rand(2)+1
    end
    def solve
      if @choose==1
        {
          "ans1"=>(@a+2)*(@a+2),
          "ans2"=>(@a+2)*(@a+2)*(@a+2)
         }
      elsif @choose==2
        {
          "ans1"=>(@a+2)*(@a+2),
          "ans2"=>(@a+2)*(@a+2)*(@a+2)
         }
      elsif @choose==3
          if @factor>1
           {
            "increase"=>"increase",
            "ans"=>@factor4
            # "ans"=>@factor5
           }
           else
            {
            "increase"=>"decrease",
            "ans"=>@factor4
           }
          end
      elsif @choose==4
          
           {
            # "equation" => (@choose1 == 0) ? "Equation" : "Not Equation"
            "increase_1"=>(@factor5<=1) ? "decrease" : "increase",
            "ans1"=>@factor7,
            "increase_2"=>(@factor6<=1) ? "decrease" : "increase",
            "ans2"=>@factor8
           }
          
      end
    end
    def text
      if @choose==1
        [
        TextLabel.new("If each edge of a cube is #{@place1}."),
        TextLabel.new("How many times will its surface area increase?"),
        InlineBlock.new(TextField.new("ans1")),
        TextLabel.new("How many times will its volume increase?"),
        InlineBlock.new(TextField.new("ans2")),
        ]
      elsif @choose==2
        [
        TextLabel.new("If each edge of a cube becomes #{@place2}."),
        TextLabel.new("How many times will its surface area decrease?"),
        InlineBlock.new(TextField.new("ans1")),
        TextLabel.new("How many times will its volume decrease?"),
        InlineBlock.new(TextField.new("ans2")),
        ]
      elsif @choose==3
        [
          TextLabel.new("In a cuboid, if the length becomes #{@place3}, breadth becomes #{@place4} and the height becomes #{@place5}."),
          TextLabel.new("What will be the change in the volume of the cuboid?"),
          Dropdown.new("increase","increase","decrease"),
          TextLabel.new("by a factor of "),
          TextField.new("ans")
        ]
      elsif @choose==4
        [
          TextLabel.new("In a cylinder, if the radius becomes #{@place3} and the height becomes #{@place5}."),
          TextLabel.new("What will be the change in the volume of the cylinder?"),
          InlineBlock.new(Dropdown.new("increase_1","increase","decrease"),TextLabel.new("by a factor of "),TextField.new("ans1")),
          TextLabel.new("What will be the change in the lateral surface area of the cylinder?"),
          InlineBlock.new(Dropdown.new("increase_2","increase","decrease"),TextLabel.new("by a factor of "),TextField.new("ans2")),

        ]
      end
    end
    def explain
      if @choose==1
       [
        SubLabel.new("Volume of a cube is sidelength*sidelength*sidelength and total surface area is 6*sidelength*sidelength")
       ] 
      elsif @choose==2
       [
        SubLabel.new("Volume of a cube is sidelength*sidelength*sidelength and total surface area is 6*sidelength*sidelength")
       ]
      elsif @choose==3
       [
        SubLabel.new("Volume of a cuboid is length*breadth*height ")
       ]  
      elsif @choose==4
        [
        SubLabel.new("The Volume of a cylinder is (pi*radius*radius)*height and lateral surface area is 2*pi*radius*height")
        ] 
      end
    end
  end


  PROBLEMS = [
    
   
   PerimeterandArea::Area_rectangle,
   PerimeterandArea::Try11_13,
   PerimeterandArea_6::Try12_3,
   Mensuration_8::Area_rhombus,
   Mensuration_8::Area_trapezium,
   Mensuration_8::Try13_1,
   Mensuration_8::Try13_2,
   Mensuration_8::Try13_3,
   Mensuration_8::Try13_4,
   Mensuration_8::Try13_5,
   Mensuration_8::Try13_6,
   Mensuration_8::Try13_7,
   Mensuration_8::Try13_8,
   Mensuration_8::Try13_9,
   Mensuration_8::Try13_10,
   Mensuration_8::LateralSurfaceArea,
   Mensuration_8::TotalSurfaceArea,
   Mensuration_8::Volume
     ] # //Anurag is module name and dummy is class name
end