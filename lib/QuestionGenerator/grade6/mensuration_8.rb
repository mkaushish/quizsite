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
  INDEX = "mensuration_8"
  TITLE = "Mensuration_8"
  
  UNITS = ["mm","cm","dc","m","Dm","hm","km" ]
  UNITS2 = ["millimeter", "centimeter", "decimeter","meter","decameter","hectometer","kilometere"]
  PLACE1= ["garden","park","room"]
  PLACE2= ["path","path","verandah"]
  
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
        TextLabel.new("The floor of a building consists of #{@numtiles} tiles which are rhombus shaped and each of its diagonals are #{@a} cm 
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("#{@unit}"),TextLabel.new("2")))
    ]
    end
    def explain
      [
        SubLabel.new("The area of a rhombus is (diagonal1*diagonal2)/2.")
      ]
    end
  end

  PROBLEMS = [
    
   
   PerimeterandArea::Createkb4,
   PerimeterandArea::Area_rectangle,
   PerimeterandArea::Try11_13,
   PerimeterandArea_6::Try12_3,
   Mensuration_8::Area_rhombus,
   Mensuration_8::Area_trapezium,
   Mensuration_8::Try13_1
     ] # //Anurag is module name and dummy is class name
end