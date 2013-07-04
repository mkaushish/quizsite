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
      @figure3=[]
      @figure3[0]=20;
      @figure3[1]=0;
      @figure3[2]=11;
      @figure3[3]=20;
      @figure3[4]=10;
      # @figure3[5]=12;
      # @figure3[6]=0;
      # @figure3[7]=10;
      # @figure3[8]=13;
      # @figure3[9]=0;
      # @figure3[10]=5;
      # @figure3[11]=14;
      # @figure3[12]= 5;
      # @figure3[13]=3;
      # @figure3[14]=17;
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

         # DrawShape3.new(@figure3,'cm',50,50,0)
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


  class Try12_4 < QuestionWithExplanation
    def self.type
      "Try12_4"
    end
    def initialize
      @a = rand(10)+10
      @b = rand(10)+10
      @c = rand(5)+1
      @d = rand(5)+2
      @e = rand(5)+2
      @f = rand(5)+2
      @h = rand(5)+5
      @g = rand(2)+3
      # @choose=1
      @choose=rand(6)+1
      
      @figure3=[]
      @figure3[0]=20;
      @figure3[1]=0;
      @figure3[2]=11;
      @figure3[3]=20;
      @figure3[4]=10;
      @figure3[5]=12;
      @figure3[6]=0;
      @figure3[7]=10;
      @figure3[8]=13;
      @figure3[9]=0;
      @figure3[10]=5;
      @figure3[11]=14;
      @figure3[12]= 5;
      @figure3[13]=3;
      @figure3[14]=17;


      @figure1=[]
      @figure1[0]=0
      @figure1[1]=0
      @figure1[2]=@a
      
      @figure1[3]=@a
      @figure1[4]=0
      @figure1[5]=@b

      @figure1[6]=@a-@c
      @figure1[7]=@b
      @figure1[8]=@a-2*@c

      @figure1[9]=@c
      @figure1[10]=@b
      @figure1[11]=@b


      @figure2=[]
      @figure2[0]=0
      @figure2[1]=0
      @figure2[2]=@a
      
      @figure2[3]=@a
      @figure2[4]=0
      @figure2[5]=@b

      @figure2[6]=@a+@c
      @figure2[7]=@b
      @figure2[8]=@d

      @figure2[9]=@c+@a-@d
      @figure2[10]=@b
      @figure2[11]=@f+@d/2

      @figure2[12]= @c+@a-@d-@e
      @figure2[13]=@b-@f
      @figure2[14]=@c+@a-@d-@e

      @figure2[15]=0
      @figure2[16]=@b-@f
      @figure2[17]=@b-@f

      @figure4=[]
      @figure4[0]=0
      @figure4[1]=0
      @figure4[2]=@h

      @figure4[3]=@h
      @figure4[4]=0
      @figure4[5]=@h

      @figure4[6]=@h
      @figure4[7]=-@h
      @figure4[8]=@g

      @figure4[9]=@h+@g
      @figure4[10]=-@h
      @figure4[11]=@h

      @figure4[12]=@h+@g
      @figure4[13]=0
      @figure4[14]=@h

      @figure4[15]=2*@h+@g
      @figure4[16]=0
      @figure4[17]=@g

      @figure4[18]=2*@h+@g
      @figure4[19]=@g
      @figure4[20]=@h

      @figure4[21]=@h+@g
      @figure4[22]=@g
      @figure4[23]=@h

      @figure4[24]=@h+@g
      @figure4[25]=@g+@h
      @figure4[26]=@g

      @figure4[27]=@h
      @figure4[28]=@g+@h
      @figure4[29]=@h

      @figure4[30]=@h
      @figure4[31]=@g
      @figure4[32]=@h

      @figure4[33]=0
      @figure4[34]=@g
      @figure4[35]=@g


      @figure5=[]
      @figure5[0]=0
      @figure5[1]=0
      @figure5[2]=@a

      @figure5[3]=0
      @figure5[4]=@a
      @figure5[5]=@b

      @figure5[6]=@b
      @figure5[7]=@a
      @figure5[8]=@g

      @figure5[9]=@b
      @figure5[10]=@a-@g
      @figure5[11]=@b-@g

      @figure5[12]=@g
      @figure5[13]=@a-@g
       @figure5[14]=@a-@g

      @figure5[15]=@g
      @figure5[16]=0
      @figure5[17]=@g


      @figure6=[]
      @figure6[0]=0
      @figure6[1]=0
      @figure6[2]=@h

      @figure6[3]=@h
      @figure6[4]=0
      @figure6[5]=@a

      @figure6[6]=@h
      @figure6[7]=@a
      @figure6[8]=@g

      @figure6[9]=@h+@g
      @figure6[10]=@a
      @figure6[11]=@g

      @figure6[12]=@h+@g
      @figure6[13]=0
      @figure6[14]=@h

      @figure6[15]=2*@h+@g
      @figure6[16]=0
      @figure6[17]=@g

      @figure6[18]=2*@h+@g
      @figure6[19]=-@g
      @figure6[20]=2*@h+@g

      @figure6[21]=0
      @figure6[22]=-@g
      @figure6[23]=@g

      # @figure7=[]
      # @figure7[0]=0
      # @figure7[1]=0
      # @figure7[2]=@a

      # @figure7[3]=0
      # @figure7[4]=@a
      # @figure7[5]=@g

      # @figure7[6]=@g
      # @figure7[7]=@a
      # figure7[8]=@a-@g

      # @figure7[9]=@g
      # @figure7[10]=@g
      # @figure7[11]=
      @perimeter1=0
      @i=0
      
    end
    def solve
      if @choose==1
         @perimeter1=0
        while @i<@figure1.length do
        @perimeter1=@perimeter1+@figure1[@i+2]
        @i=@i+3
        end
        @i=0
        {"ans" => @perimeter1}
      elsif @choose==2
         @perimeter2=0
        while @i<@figure2.length do
        @perimeter2=@perimeter2+@figure2[@i+2]
        @i=@i+3
        end
        @i=0
        {"ans" => @perimeter2}
      elsif @choose==3
         @perimeter3=0
        while @i<@figure3.length do
        @perimeter3=@perimeter3+@figure3[@i+2]
        @i=@i+3
        end
        @i=0
        {"ans" => @perimeter3}
      elsif @choose==4
         @perimeter4=0
        while @i<@figure4.length do
        @perimeter4=@perimeter4+@figure4[@i+2]
        @i=@i+3
        end
        @i=0
        {"ans" => @perimeter4}
      elsif @choose==5
         @perimeter5=0
        while @i<@figure5.length do
        @perimeter5=@perimeter5+@figure5[@i+2]
        @i=@i+3
        end
        @i=0
        {"ans" => @perimeter5}
      elsif @choose==6
         @perimeter6=0
        while @i<@figure6.length do
        @perimeter6=@perimeter6+@figure6[@i+2]
        @i=@i+3
        end
        @i=0
        {"ans" => @perimeter6}
      else
      end
    end
  def text
    if @choose==1
      [
        TextLabel.new("Find the perimeter of the given figure"),
        DrawShape3.new(@figure1,'cm',20,50,1),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("cm"))
      ] 
    elsif @choose==2
      [
        TextLabel.new("Find the perimeter of the given figure"),
        DrawShape3.new(@figure2,'cm',20,50,1),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("cm"))
      ]
    elsif @choose==3
      [
        TextLabel.new("Find the perimeter of the given figure"),
        DrawShape3.new(@figure3,'cm',20,50,1),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("cm"))
      ]
    elsif @choose==4
      [
        TextLabel.new("Find the perimeter of the given figure"),
        DrawShape3.new(@figure4,'cm',20,100,1),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("cm"))
      ]
    elsif @choose==5
      [
        TextLabel.new("Find the perimeter of the given figure"),
        DrawShape3.new(@figure5,'cm',20,50,1),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("cm"))
      ]
    else
      [
        TextLabel.new("Find the perimeter of the given figure"),
        DrawShape3.new(@figure6,'cm',20,50,1),
        InlineBlock.new(TextField.new("ans"),TextLabel.new("cm"))
      ]  
    end
    end

    def explain
      [
        SubLabel.new("Perimeter is the sum of sides of the figure.")
      ]
    end
  end

  class Try12_5 < QuestionBase
    def self.type
      "Try12_5"
    end
    def initialize
      @a = rand(10)+10
      @b = rand(10)+10
      @c = rand(5)+1
      @d = rand(5)+2
      @e = rand(5)+2
      @f = rand(5)+2
      @h = rand(5)+5
      @g = rand(2)+3
      # @choose=6
      @choose=rand(3)+4

      @figure4=[]
      @figure4[0]=0
      @figure4[1]=0
      @figure4[2]=@h

      @figure4[3]=@h
      @figure4[4]=0
      @figure4[5]=@h

      @figure4[6]=@h
      @figure4[7]=-@h
      @figure4[8]=@g

      @figure4[9]=@h+@g
      @figure4[10]=-@h
      @figure4[11]=@h

      @figure4[12]=@h+@g
      @figure4[13]=0
      @figure4[14]=@h

      @figure4[15]=2*@h+@g
      @figure4[16]=0
      @figure4[17]=@g

      @figure4[18]=2*@h+@g
      @figure4[19]=@g
      @figure4[20]=@h

      @figure4[21]=@h+@g
      @figure4[22]=@g
      @figure4[23]=@h

      @figure4[24]=@h+@g
      @figure4[25]=@g+@h
      @figure4[26]=@g

      @figure4[27]=@h
      @figure4[28]=@g+@h
      @figure4[29]=@h

      @figure4[30]=@h
      @figure4[31]=@g
      @figure4[32]=@h

      @figure4[33]=0
      @figure4[34]=@g
      @figure4[35]=@g


      @figure5=[]
      @figure5[0]=0
      @figure5[1]=0
      @figure5[2]=@a

      @figure5[3]=0
      @figure5[4]=@a
      @figure5[5]=@b

      @figure5[6]=@b
      @figure5[7]=@a
      @figure5[8]=@g

      @figure5[9]=@b
      @figure5[10]=@a-@g
      @figure5[11]=@b-@g

      @figure5[12]=@g
      @figure5[13]=@a-@g
       @figure5[14]=@a-@g

      @figure5[15]=@g
      @figure5[16]=0
      @figure5[17]=@g


      @figure6=[]
      @figure6[0]=0
      @figure6[1]=0
      @figure6[2]=@h

      @figure6[3]=@h
      @figure6[4]=0
      @figure6[5]=@a

      @figure6[6]=@h
      @figure6[7]=@a
      @figure6[8]=@g

      @figure6[9]=@h+@g
      @figure6[10]=@a
      @figure6[11]=@a

      @figure6[12]=@h+@g
      @figure6[13]=0
      @figure6[14]=@h

      @figure6[15]=2*@h+@g
      @figure6[16]=0
      @figure6[17]=@g

      @figure6[18]=2*@h+@g
      @figure6[19]=-@g
      @figure6[20]=2*@h+@g

      @figure6[21]=0
      @figure6[22]=-@g
      @figure6[23]=@g

      @i=0
      
    end
    def solve
      if @choose==4
        @area=4*@h*@g+@g*@g
        {"ans" => @area}
      elsif @choose==5
        @area=(@a+@b-@g)*@g
        {"ans" => @area}
      elsif @choose==6
        @area=(2*@h+@g+@a)*@g
        {"ans" => @area}
      else
      end
    end
  def text
    if @choose==4
      [
        TextLabel.new("By splitting the figure into rectangles, find its area."),
        DrawShape3.new(@figure4,'cm',20,100,1),
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("cm"),TextLabel.new("2")))
      ]
    elsif @choose==5
      [
        TextLabel.new("By splitting the figure into rectangles, find its area."),
        DrawShape3.new(@figure5,'cm',20,50,1),
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("cm"),TextLabel.new("2")))
      ]
    else
      [
        TextLabel.new("By splitting the figure into rectangles, find its area."),
        DrawShape3.new(@figure6,'cm',20,50,1),
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("cm"),TextLabel.new("2")))
      ]  
    end
    end

  end

  class Try12_3<QuestionWithExplanation
    def self.type
      "Try12_3"
    end
    def initialize
      @a = rand(15)+10
      @b = rand(15)+10
      @c = rand(20)+1
      @size1=0.5
      @size2=1
      @person, @person2 = Names.generate(2)
      @area = @a*@b
      @perimeter = 2*(@a+@b)
      @choose = rand(2)
      @d = 3
      @unit = UNITS[@d]
      
    end
    def solve
      if @choose==0
       {
        "ans1"=>@area*4
       }
      else
        {
          "ans1"=>@area
        }
      end 
    end
    def text
      if @choose==0
        [
          TextLabel.new("#{@person} wants to cover the floor of a room #{@a} m wide and #{@b} m long by squared tiles. If each square tile is of side #{@size1} m, then find the number of tiles required to cover the floor of the room."),
          DrawShape2.new('rectangle',@a,@b,5,3,5,@unit,300,300,1,1),
          InlineBlock.new(TextField.new("ans1"))
        ]
      else
        [
          TextLabel.new("#{@person} wants to cover the floor of a room #{@a} m wide and #{@b} m long by squared tiles. If each square tile is of side #{@size2} m, then find the number of tiles required to cover the floor of the room."),
          DrawShape2.new('rectangle',@a,@b,5,3,5,@unit,300,300,1,1),
          InlineBlock.new(TextField.new("ans1"))
        ]
      end 
    end
    def explain
      if @choose==0
        [
          SubLabel.new("The area of the room is #{@a}*#{@b}=#{@a*@b}. The area of 1 tile is #{@size1}*#{@size1}=#{@size1*@size1}. Therefore, the number of tiles required is #{@a*@b}/#{@size1*@size1}=#{4*@a*@b}")
        ]
      else
        [
          SubLabel.new("The area of the room is #{@a}*#{@b}=#{@a*@b}. The area of 1 tile is #{@size1}*#{@size1}=#{@size1*@size1}. Therefore, the number of tiles required is #{@a*@b}/#{@size1*@size1}=#{@a*@b}")
        ]
      end
    end
  end

  class Try12_6 < QuestionBase
    def self.type
      "Try12_6"
    end
    def initialize
      @i=2*(rand(10)+5)
      @j=2*(rand(10)+5)
      @a = rand(10)+10
      while (@a%2==1) do
      @a = rand(10)+10
      end
      @b = rand(10)+10
      while (@b%2==1) do
      @b = rand(10)+10
      end
      @c = rand(5)+1
      @d = rand(5)+2
      @e = rand(5)+2
      @f = rand(5)+2
      @h = rand(10)+7
      while (@h%2==1) do
        @h = rand(5)+5
      end
      @g = rand(2)+3
       while (@g%2==1) do
      @g = rand(2)+3
      end
      # @choose=4
      @choose=rand(3)+1

      @figure4=[]
      @figure4[0]=0
      @figure4[1]=0
      @figure4[2]=@h

      @figure4[3]=@h
      @figure4[4]=0
      @figure4[5]=@h

      @figure4[6]=@h
      @figure4[7]=-@h
      @figure4[8]=@g

      @figure4[9]=@h+@g
      @figure4[10]=-@h
      @figure4[11]=@h

      @figure4[12]=@h+@g
      @figure4[13]=0
      @figure4[14]=@h

      @figure4[15]=2*@h+@g
      @figure4[16]=0
      @figure4[17]=@g

      @figure4[18]=2*@h+@g
      @figure4[19]=@g
      @figure4[20]=@h

      @figure4[21]=@h+@g
      @figure4[22]=@g
      @figure4[23]=@h

      @figure4[24]=@h+@g
      @figure4[25]=@g+@h
      @figure4[26]=@g

      @figure4[27]=@h
      @figure4[28]=@g+@h
      @figure4[29]=@h

      @figure4[30]=@h
      @figure4[31]=@g
      @figure4[32]=@h

      @figure4[33]=0
      @figure4[34]=@g
      @figure4[35]=@g


      @figure5=[]
      @figure5[0]=0
      @figure5[1]=0
      @figure5[2]=@a

      @figure5[3]=0
      @figure5[4]=@a
      @figure5[5]=@b

      @figure5[6]=@b
      @figure5[7]=@a
      @figure5[8]=@g

      @figure5[9]=@b
      @figure5[10]=@a-@g
      @figure5[11]=@b-@g

      @figure5[12]=@g
      @figure5[13]=@a-@g
       @figure5[14]=@a-@g

      @figure5[15]=@g
      @figure5[16]=0
      @figure5[17]=@g


      @figure6=[]
      @figure6[0]=0
      @figure6[1]=0
      @figure6[2]=@h

      @figure6[3]=@h
      @figure6[4]=0
      @figure6[5]=@a

      @figure6[6]=@h
      @figure6[7]=@a
      @figure6[8]=@g

      @figure6[9]=@h+@g
      @figure6[10]=@a
      @figure6[11]=@a

      @figure6[12]=@h+@g
      @figure6[13]=0
      @figure6[14]=@h

      @figure6[15]=2*@h+@g
      @figure6[16]=0
      @figure6[17]=@g

      @figure6[18]=2*@h+@g
      @figure6[19]=-@g
      @figure6[20]=2*@h+@g

      @figure6[21]=0
      @figure6[22]=-@g
      @figure6[23]=@g


    end
    def solve
      if @choose==1
      {"ans" => (@i*@j)/4}
      elsif @choose==2
      {
        "ans" => (4*@h*@g+@g*@g)/4
      }
      elsif @choose==3
      {
        "ans" => ((@a+@b-@g)*@g)/4
      }
      else
      {
        "ans" => ((2*@h+@g+@a)*@g)/4
      } 
      end
    end
    def text
      if @choose==1
      [
        TextLabel.new("In the graph paper every square measures 1 cm * 1 cm.Find the area of the figure below"),
        DrawShape.new("ans",'rectangle3',20,20,0,0,500,500,0,2,500,500,1,1),
        DrawShape2.new('rectangle',@i,@j,4,0,4,'cm',500,500,1,0),
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("cm"),TextLabel.new("2")))
       ]
      elsif @choose==2
       [
        TextLabel.new("In the graph paper every square measures 1 cm * 1 cm.Find the area of the figure below"),
        DrawShape.new("ans",'rectangle3',20,20,0,0,500,500,0,2,500,500,1,1),
        DrawShape3.new(@figure4,'cm',60,180,0,500,500,1,0),
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("cm"),TextLabel.new("2")))
       ]
     elsif @choose==3
       [
        TextLabel.new("In the graph paper every square measures 1 cm * 1 cm.Find the area of the figure below"),
        DrawShape.new("ans",'rectangle3',20,20,0,0,500,500,0,2,500,500,1,1),
        DrawShape3.new(@figure5,'cm',60,180,0,500,500,1,0),
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("cm"),TextLabel.new("2")))
       ]
      else
        [
        TextLabel.new("In the graph paper every square measures 1 cm * 1 cm.Find the area of the figure below"),
        DrawShape.new("ans",'rectangle3',20,20,0,0,500,500,0,2,500,500,1,1),
        DrawShape3.new(@figure6,'cm',60,180,0,500,500,1,0),
        InlineBlock.new(TextField.new("ans"),Exponent.new(TextLabel.new("cm"),TextLabel.new("2")))
       ]
      end 
    end
  end


  PROBLEMS = [
    
   
   # PerimeterandArea::Createkb4,
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
   PerimeterandArea_6::Try12_4,
   PerimeterandArea_6::Try12_3,
   PerimeterandArea_6::Try12_5,
   PerimeterandArea_6::Try12_6

    ] # //Anurag is module name and dummy is class name
end