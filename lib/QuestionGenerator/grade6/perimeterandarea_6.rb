require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml'
require_relative './preg6'
require_relative '../modules/names'
require_relative './c6'
require_relative './perimeterandarea.rb'
require 'prime'
require 'set'
# TODO override preprocess for the add commas question ( default is now to remove commas )
include ToHTML
include PreG6
include PerimeterandArea

module PerimeterandArea_6
  INDEX = "perimeterandarea_6"
  TITLE = "PerimeterandArea_6"
  
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
        DrawShape4.new('arc_4',50,20,7,100,0.25*@PI,0.5*@PI,'a','b','c',300,300,1,1)

         # DrawShape3.new(@original2,'cm',50,50,0)
       ]
    end
  end

  class Try12_1<QuestionWithExplanation
    def self.type
      "Try12_1"
    end
    def initialize
      @a = rand(15)+5
      @b = rand(15)+1
      @c = rand(20)+1
      @times = rand(10)+2
      @person, @person2 = Names.generate(2)
      @area = @a*@b
      @perimeter = 2*(@a+@b)
      @choose = rand(2)
      @d = 3
      @unit = UNITS[@d]
      if @choose!=0
        if (4*@c)<@perimeter
          @choose=1
        else
          @choose=2
        end
      end
    end
    def solve
      if @choose==0
       {
        "ans1"=>@perimeter*@times
       }
       elsif @choose==1 
        {
          
           "ans1"=>@perimeter-4*@c,
           "#{@person}"=>"#{@person2}"
        }
        else
        {
            "ans1"=>4*@c-@perimeter,
            "#{@person}"=>"#{@person}" 
        }
       end 
    end
    def text
      if @choose==0
        [
          TextLabel.new("An athlete takes #{@times} rounds of a rectangular park, #{@a} m long and #{@b} m wide. Find the total distance covered by him."),
          DrawShape2.new('rectangle',@a,@b,5,3,5,@unit,300,300,1,1),
          InlineBlock.new(TextField.new("ans1"),TextLabel.new("#{@unit}")),
        ]
      else
        [
          TextLabel.new("#{@person} runs around a square field of side #{@c} m, #{@person2} runs around a rectangular field #{@a} m long and #{@b} m wide. Who covers more distance and by how much?"),
          DrawShape2.new('rectangle',@c,@c,5,1,5,@unit,300,300,2,1),
          DrawShape2.new('rectangle',@a,@b,5,3,5,@unit,300,300,1,1),
          Dropdown.new("#{@person}", "#{@person}", "#{@person2}"),
          InlineBlock.new(TextField.new("ans1"),TextLabel.new("#{@unit}"))
        ]
      end 
    end
    def explain
      if @choose==0
        [
          SubLabel.new("The perimeter of the rectangular park is 2*(length+breadth)=#{@perimeter}. Therefore distance covered in #{@times} rounds is #{@times}*#{@perimeter} = #{@times*@perimeter}.")
        ]
      else
        [
          if ((4*@c)<@perimeter)
           SubLabel.new("Perimeter of the square field is 4*sidelength=#{4*@c}.The perimeter of the rectangular park is 2*(length+breadth)=#{@perimeter}. Since  #{4*@c}<#{@perimeter}, #{@person2} covers #{@perimeter-4*@c}m more distance.") 
          else
           SubLabel.new("Perimeter of the square field is 4*sidelength=#{4*@c}.The perimeter of the rectangular park is 2*(length+breadth)=#{@perimeter}. Since  #{4*@c}>#{@perimeter}, #{@person} covers #{-@perimeter+4*@c}m more distance.") 
          end
          
        ]
      end
    end
  end


  class Try12_2 < QuestionBase
    def self.type
      "Try12_2"
    end
    def initialize
      @a = rand(10)+5
      @b = rand(10)+5

      @original2=[]
      @original2[0]=20;
      @original2[1]=0;
      @original2[2]=11;
      @original2[3]=20;
      @original2[4]=10;
      @original2[5]=12;
      @original2[6]=0;
      @original2[7]=10;
      @original2[8]=13;
      @original2[9]=0;
      @original2[10]=5;
      @original2[11]=14;
      @original2[12]= 5;
      @original2[13]=3;
      @original2[14]=17;
      @PI= Math.acos(-1)
      @angle = @PI/2.0


      @figure1=[]
      @figure[0]=0
    end
    def solve
      {"ans" => @a}
    end
    def text
      
      [
        TextLabel.new("Find the perimeter of the given figure"),
         DrawShape3.new(@original2,'cm',50,50,1)
       ]
    end
  end


  PROBLEMS = [
    
   
   PerimeterandArea::Createkb4,
   PerimeterandArea::Per_rectangle,
   PerimeterandArea::Per_triangle,
   PerimeterandArea::Per_regpolygon,
   PerimeterandArea::Area_rectangle,
   PerimeterandArea::Area_triangle,
   PerimeterandArea::Try11_4,
   PerimeterandArea::Try11_1,
   PerimeterandArea::Try11_13,
   PerimeterandArea::Try11_14,
   PerimeterandArea::Per_parallelogram,
   PerimeterandArea_6::Try12_1,
   PerimeterandArea_6::Try12_2

    ] # //Anurag is module name and dummy is class name
end