#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml'
require_relative './preg6'
require_relative './c6'
require 'prime'
require 'set'
# TODO override preprocess for the add commas question ( default is now to remove commas )
include ToHTML
include PreG6
include Chapter6

module Algebra_6
  INDEX = "algebra_6"
  TITLE = "Algebra 1"
  
  VARIABLES=["x", "z", "y", "u", "v", "w", "p", "m", "n", "l", "b", "h"] 
  OPTIONS1 = ["cadets in a row", "mangoes in a box", "dots in a row", "kilometeres in an hour", "pencils per students"]
  OPTIONS2 = ["cadets", "mangoes", "dots", "kilometeres", "pencils"]
  OPTIONS3 = ["rows", "boxs", "rows", "hours", "students"]
  SHAPES = [  "equilateral triangle","square",  "pentangon", "hexagon", "septagon", "octagon","nonagon", "decagon", "rectangle", "cube", "cuboid"]
  DIMENSIONS = ["length", "breadth", "height"]
  OPERATIONS = ["addition", "subtraction", "multiplication", "division", "none"]
  OPERATIONS2 =["added to ", "subtracted from", "multiplied by ", "divided by"]
  PEOPLE = ["Sarita", "Balu", "Raju", "Ameena"]
  RELATIONS1 =["brother", "sister", "cousin", "son", "daughter", "grandson", "granddaughter"]
  RELATIONS2 =["brother", "sister", "cousin", "mother", "father", "grandmother", "grandfather"]
 
  class Try_11 < QuestionWithExplanation
    def self.type
      "Understand Variables 1"
    end
    def initialize
      @var = VARIABLES.sample
      @choose = rand(5)
      @option1value = OPTIONS1[@choose]
      @option2value = OPTIONS2[@choose]
      @option3value = OPTIONS3[@choose]
      @a = rand(10)+2
    end

    def solve
     { 
      "ans1" => "#{@a}#{@var}"
     }
    end
    
    def text
      if @choose ===3
        [TextLabel.new("A bird flies #{@a} #{@option1value}. Can you express the total distance covered by the bird in terms of flying time.(Use #{@var} for flying time in #{@option3value})"), 
        TextField.new("ans1")
        
        ]
      else
        [TextLabel.new("There are #{@a} #{@option1value}. Write the expression for the total number of #{@option2value}.(Use #{@var} for the number of #{@option3value})"), 
        TextField.new("ans1")
        
        ]
      end
    end

    def explain
     if @choose ===3
        [
          SubLabel.new("The bird flies #{@a} #{@option1value}. Therefore the total diastance covered by the bird would be the product of flying time #{@var} and speed #{@a}, which turns out to be #{@a}#{@var}.")
        ]
      else
        [
          SubLabel.new("There are #{@a} #{@option1value}. Therefore for the total number of #{@option2value} would be the product of number of #{@option1value}(#{@a}) times the number of #{@option3value}(#{@var}), which turns out to be #{@a}#{@var}."), 
        ]
      end       
    end
  end

  class Try_12 < QuestionWithExplanation
    def self.type
      "Understand Variables 2"
    end
    def initialize
      @var = VARIABLES.sample
      @choose = rand(3)
      @option1value = OPTIONS1[@choose]
      @option2value = OPTIONS2[@choose]
      @option3value = OPTIONS3[@choose]
      @a = rand(10)+2
      @b = rand(10)+2
       while @b>@a do
        @b = rand(10)+2
      end
    end

    def solve
      {
       "ans1" => "#{@a}#{@var}+#{@b}" 
      }
    end
    def correct?(params)
      solsum = 0
      bool = true
      resps = QuestionBase.vars_from_response( "ans1" , params)
      puts "********\n" + resps.to_s + "********\n"
      (((resps) == "#{@b}+#{@a}#{@var}")or((resps) == "#{@a}#{@var}+#{@b}"))
    end
    def text
      [
        TextLabel.new("Ram puts #{@option1value}. There are #{@a} #{@option1value}. #{@b} extra #{@option2value} remain. Write the expression for the total number of #{@option2value}.(Use #{@var} for the number of #{@option3value})"), 
        TextField.new("ans1")
      ]
    end
    def explain
      [
        SubLabel.new("There are #{@a} #{@option1value}. Therefore  the total number of #{@option2value} in the #{@option3value} would be the product of number of #{@option1value}(#{@a}) times the number of #{@option3value}(#{@var}), which turns out to be #{@a}#{@var}. Now there are #{@b} extra #{@option2value} which are not in #{@option3value}. Therefore  the total number of #{@option2value} is #{@a}#{@var}+#{@b}."), 
      ]       
    end
  end

  class Try_13 < QuestionWithExplanation
    def self.type
      "Perimeter Polygon"
    end
    def initialize
      @var = VARIABLES.sample
      @choose = rand(8)
      @sides = @choose+3
      @option1value = SHAPES[@choose]
    end

    def solve
        {
       "ans1" => "#{@sides}#{@var}" 
        }
    end

    def text
      [
        TextLabel.new(" Write the expression for the perimeter of  a regular #{@option1value}.(Use #{@var} as the side of #{@option1value})"),
        TextLabel.new("Hint: #{@option1value} has #{@sides} sides."), 
        TextField.new("ans1")
      ]
   end

   def explain
      [
        SubLabel.new("There are #{@sides} sides in a  #{@option1value}. Each side is of length #{@var}. Therefore  the total length of all sides is the product of length of one side(#{@var}) times the number of sides(#{@sides}), which turns out to be #{@sides}#{@var}."), 
      ]       
    end
  end

  class Try_20 < QuestionWithExplanation
    def self.type
      "Sum of Sides Algebra"
    end
    def initialize
      @choose = rand(3)+8
      @sides = @choose+3
      @option1value = SHAPES[@choose]
      @variable1 = VARIABLES.sample
      @variable2 = VARIABLES.sample
      while @variable2==@variable1
        @variable2 = VARIABLES.sample
      end
      @variable3 = VARIABLES.sample
      while (@variable3==@variable2)or(@variable3==@variable1)
        @variable3 = VARIABLES.sample
      end
    end

    def solve
      if @choose===8
        {
        "ans1" => "2#{@variable1}+2#{@variable2}"
        }
      elsif @choose ===9
        {
        "ans1" => "12#{@variable1}"
        } 
      elsif @choose ===10
        {
        "ans1" => "4#{@variable1}+4#{@variable2}+4#{@variable3}"
        }
      end
    end

    def text
      if @choose===9
        [
         TextLabel.new(" Write the expression for the sum of sides of  a #{@option1value}.(Use #{@variable1} as the side of #{@option1value})"), 
        TextField.new("ans1") 
        ]
      elsif @choose===8
          [
            TextLabel.new(" Write the expression for the perimeter of  a #{@option1value}.(Use #{@variable1} as the length and #{@variable2} as the breadth)"), 
        TextField.new("ans1")
          ]
      elsif @choose===10
            [
              TextLabel.new(" Write the expression for the sum of sides of  a #{@option1value}.(Use #{@variable1} as the length and #{@variable2} as the breadth and #{@variable3} as the height)"), 
        TextField.new("ans1")
            ]
      end
    end

    def explain
      if @choose===8
        [
          SubLabel.new("There are 2 sides of length #{@variable1} and another two sides of length #{@variable2} in a  #{@option1value}. Therefore  the total length of all sides is 2#{@variable1}+2#{@variable2}.")
        ]
      elsif @choose===9
        [
          SubLabel.new("There are 12 sides each of length #{@variable1} in a cube. Therefore  the total length of all sides is 12#{@variable1}.")
        ]
      elsif @choose===10
        [
          SubLabel.new("There are 4 sides of length #{@variable1}  another 4 sides of length #{@variable2} and 4 more sides of length #{@variable3} in a  #{@option1value}. Therefore  the total length of all sides is 4#{@variable1}+4#{@variable2}+4#{@variable3} .")
        ]
      end
    end

    def correct?(params)
      if @choose===8
          solsum = 0
          bool = true
          resps = QuestionBase.vars_from_response( "ans1" , params)
          puts "********\n" + resps.to_s + "********\n"
          (((resps) == "2#{@variable1}+2#{@variable2}")or((resps) == "2#{@variable2}+2#{@variable1}")or((resps) == "2(#{@variable1}+#{@variable2})")or((resps) == "2(#{@variable2}+#{@variable1})"))
      elsif @choose===10
          
           solsum = 0
            bool = true
            resps = QuestionBase.vars_from_response( "ans1" , params)
            puts "********\n" + resps.to_s + "********\n"
            (((resps) == "4#{@variable1}+4#{@variable2}+4#{@variable3}")or((resps) == "4#{@variable1}+4#{@variable3}+4#{@variable2}")or((resps) == "4#{@variable3}+4#{@variable1}+4#{@variable2}")or((resps) == "4#{@variable3}+4#{@variable2}+4#{@variable1}")or((resps) == "4#{@variable2}+4#{@variable1}+4#{@variable3}")or((resps) == "4#{@variable2}+4#{@variable3}+4#{@variable1}")or((resps) == "4(#{@variable3}+#{@variable1}+#{@variable2})")or((resps) == "4(#{@variable3}+#{@variable2}+#{@variable1})")or((resps) == "4(#{@variable2}+#{@variable1}+#{@variable3})")or((resps) == "4(#{@variable2}+#{@variable3}+#{@variable1})")or((resps) == "4(#{@variable1}+#{@variable2}+#{@variable3})")or((resps) == "4(#{@variable1}+#{@variable3}+#{@variable2})")) 
      end
    end

  end
  

 class Try_14 < QuestionWithExplanation
    def self.type
      "What are the Operations?"
    end

    def initialize
      @choose1 = rand(3)
      @choose2 = rand(3)+2
      # @choose1 = 2
      # @choose2 = 4
      if @choose1===2
       {}
      else
        @option1value = OPERATIONS[@choose1]
      end
      if @choose2===4
        {}
      else
        @option2value = OPERATIONS[@choose2]
      end  
      @a = rand(10)+2
      @b = rand(10)+2
    end

    def solve
      # Get the indices of the correct answers
      indices = []
        if @choose1===0
            indices << 0
        elsif @choose1===1
            indices << 1
        end
         if @choose2===2
           indices << 2
         elsif @choose2===3
            indices << 3
         end
         if (@choose1===2)and(@choose2===4)
            indices << 4
         end

      Hash[
       indices.map{ |i| i.to_s }.zip([true, true]) 
     ]
    end

    def text
      if @choose1===0
        if @choose2===2
          ret = [ TextLabel.new("Identify the operations involved in forming the following expression"),
          TextLabel.new("#{@a}y + #{@b}")
          ]
        elsif @choose2==3
          ret = [ TextLabel.new("Identify the operations involved in forming the following expression"),
          TextLabel.new("y/#{@a} + #{@b}")
          ] 
        else
          ret = [ TextLabel.new("Identify the operations involved in forming the following expression"),
          TextLabel.new("y + #{@b}")
          ]
       end
      elsif @choose1===1
        if @choose2===2
          ret = [ TextLabel.new("Identify the operations involved in forming the following expression"),
          TextLabel.new("#{@a}y - #{@b}")
          ]
        elsif @choose2==3
          ret = [ TextLabel.new("Identify the operations involved in forming the following expression"),
          TextLabel.new("y/#{@a} - #{@b}")
          ] 
        else
          ret = [ TextLabel.new("Identify the operations involved in forming the following expression"),
          TextLabel.new("y - #{@b}")
          ]
        end
      elsif @choose1==2
        if @choose2===2
          ret = [ TextLabel.new("Identify the operations involved in forming the following expression"),
          TextLabel.new("#{@a}y ")
          ]
        elsif @choose2==3
          ret = [ TextLabel.new("Identify the operations involved in forming the following expression"),
          TextLabel.new("y/#{@a} ")
          ] 
        else
          ret = [ TextLabel.new("Identify the operations involved in forming the following expression"),
          TextLabel.new("y ")
          ]
        end
      end

      5.times do |i|
        ret << Checkbox.new("#{i}", "#{OPERATIONS[i]}")
      end

      ret
    end

    def explain
     if @choose1===0
        if @choose2===2
          [
            SubLabel.new("The operations involved are addition and multiplication")
          ]
        elsif @choose2==3
          [
            SubLabel.new("The operations involved are addition and division")
          ] 
        else
          [
            SubLabel.new("The only operation involved is addition ")
          ]
       end
      elsif @choose1===1
        if @choose2===2
          [
            SubLabel.new("The operations involved are subtraction and multiplication")
          ]
        elsif @choose2==3
          [
            SubLabel.new("The operations involved are subtraction and division")
          ] 
        else
          [
            SubLabel.new("The only operation involved is subtraction.")
          ]
        end
      elsif @choose1==2
        if @choose2===2
          [
            SubLabel.new("The only operation involved is multiplication")
          ]
        elsif @choose2==3
          [
            SubLabel.new("The only operation involved is division")
          ] 
        else
          [
            SubLabel.new("There are no operations involved.")
          ]
        end
      end
    end
  end

  class Try_15 < QuestionWithExplanation
    def self.type
      "Give the Expression"
    end
    def initialize
      @var = VARIABLES.sample
      @choose = rand(4)
      @option1value = OPERATIONS2[@choose]
      @a = rand(10)+2
    end

    def solve
      if @choose===0
        { 
        "ans1" => "#{@var}+#{@a}"
        }
      elsif @choose===1
          { 
          "ans1" => "#{@var}-#{@a}"
          }
        elsif @choose===2
          { 
            "ans1" => "#{@a}#{@var}"
          }
        elsif @choose===3
          { 
            "ans1" => "#{@var}/#{@a}"
          }
            
      end
    end

    def correct?(params)
      if @choose===0
          solsum = 0
          bool = true
          resps = QuestionBase.vars_from_response( "ans1" , params)
          puts "********\n" + resps.to_s + "********\n"
          (((resps) == "#{@a}+#{@var}")or((resps) == "#{@var}+#{@a}"))
        end
    end

    def text
      if (@choose ===1)or(@choose===0)
        [
          TextLabel.new("Give expression for"),
          TextLabel.new("#{@a} #{@option1value} #{@var}"),
          TextField.new("ans1")
        
        ]
      else
        [ 
          TextLabel.new("Give expression for"),
          TextLabel.new("#{@var} #{@option1value} #{@a}"),
          TextField.new("ans1")
        
        ]
      end
    end

    def explain
      if @choose===0
        [ 
        SubLabel.new(" The answer would be #{@var}+#{@a}")
        ]
      elsif @choose===1
        [ 
          SubLabel.new("The answer would be #{@var}-#{@a}")
        ]
        elsif @choose===2
        [ 
          SubLabel.new("The answer would be #{@a}#{@var}")
        ]
        elsif @choose===3
        [
          SubLabel.new("The answer would be #{@var}/#{@a}")
        ]
            
      end
    end
  end
  


  class Try_16 < QuestionWithExplanation
    def self.type
      "Relative Ages"
    end
    def initialize
      @var = VARIABLES.sample
      @choose = rand(2)
      @div = rand(3)
      @rel1 = rand(7)
      @rel2 = rand(7)
      @relative1 = RELATIONS1[@rel1]
      @relative2 = RELATIONS2[@rel2]
      @person1 = PEOPLE.sample
      @person2 = PEOPLE.sample
      while @person2===@person1
        @person2 =PEOPLE.sample
      end
     @option1value = OPERATIONS2[@choose]
      @a = rand(10)+2
      @b = rand(3)+2
      @c = rand(20)+25
    end

    def solve
      if @choose===0
        if (@div===0)
          if @rel1<3
            { 
            "ans1" => "#{@var}-#{@a}"
            }
          else
            {
              "ans1" =>"#{@var}-#{@c}"
            }
          end
        elsif @div===1
          { 
          "ans1" => "#{@var}/#{@b}-#{@a}"
          }
        elsif @div===2
          { 
          "ans1" => "#{@var}/#{@b}+#{@a}"
          }
        end

      elsif @choose===1
        if @div===0
          if @rel2<3
            { 
            "ans1" => "#{@var}+#{@a}"
            }
          else
            {
              "ans1" =>"#{@var}+#{@c}"
            }
          end
        elsif @div===1
          { 
          "ans1" => "#{@b}#{@var}-#{@a}"
          }
        elsif @div===2
          { 
          "ans1" => "#{@b}#{@var}+#{@a}"
          }
        end
      end
    end

    def correct?(params)
      if @choose===0
        if @div===2
          solsum = 0
          bool = true
          resps = QuestionBase.vars_from_response( "ans1" , params)
          puts "********\n" + resps.to_s + "********\n"
          (((resps) == "#{@var}/#{@b}+#{@a}")or((resps) == "#{@a}+#{@var}/#{@b}"))
        end
      elsif @choose===1
          if @div===0
           solsum = 0
            bool = true
            resps = QuestionBase.vars_from_response( "ans1" , params)
            puts "********\n" + resps.to_s + "********\n"
            (((resps) == "#{@var}+#{@a}")or((resps) == "#{@a}+#{@var}")) 
          elsif @div===2
            solsum = 0
            bool = true
            resps = QuestionBase.vars_from_response( "ans1" , params)
            puts "********\n" + resps.to_s + "********\n"
            (((resps) == "#{@b}#{@var}+#{@a}")or((resps) == "#{@a}+#{@b}#{@var}")) 
          end
      end
    end

    def text
      if @choose===0
        if @div===0
          if @rel1<3
            [ 
              TextLabel.new("Take #{@person1}'s age as #{@var}"),
              TextLabel.new("#{@person1}'s #{@relative1} is #{@a} years younger than #{@person1}."),
              TextLabel.new("What is #{@person1}'s #{@relative1} age? "),
              TextField.new("ans1")
            ]
          else
            [ 
              TextLabel.new("Take #{@person1}'s age as #{@var}"),
              TextLabel.new("#{@person1}'s #{@relative1} is #{@c} years younger than #{@person1}."),
              TextLabel.new("What is #{@person1}'s #{@relative1} age? "),
              TextField.new("ans1")
            ]
          end
        elsif @div===1
          [ 
            TextLabel.new("Take #{@person1}'s age as #{@var}"),
            TextLabel.new("#{@person1}'s #{@relative1} age is #{@a} years less than 1/#{@b} times the age of #{@person1}."),
            TextLabel.new("What is #{@person1}'s #{@relative1} age? "),
            TextField.new("ans1")
          ]
        elsif @div===2
          [ 
            TextLabel.new("Take #{@person1}'s age as #{@var}"),
            TextLabel.new("#{@person1}'s #{@relative1} age is #{@a} years more than 1/#{@b} times the age of #{@person1}."),
            TextLabel.new("What is #{@person1}'s #{@relative1} age? "),
            TextField.new("ans1")
          ]
        end
      elsif @choose===1
        if @div===0
          if @rel2<3
            [ 
              TextLabel.new("Take #{@person1}'s age as #{@var}"),
              TextLabel.new("#{@person1}'s #{@relative2} is #{@a} years older than #{@person1}."),
              TextLabel.new("What is #{@person1}'s #{@relative2} age? "),
              TextField.new("ans1")
            ]
          else
            [ 
              TextLabel.new("Take #{@person1}'s age as #{@var}"),
              TextLabel.new("#{@person1}'s #{@relative2} is #{@c} years older than #{@person1}."),
              TextLabel.new("What is #{@person1}'s #{@relative2} age? "),
              TextField.new("ans1")
            ]
          end
        elsif @div===1
          [ 
            TextLabel.new("Take #{@person1}'s age as #{@var}"),
            TextLabel.new("#{@person1}'s #{@relative2} age is #{@a} years less than #{@b} times the age of #{@person1}."),
            TextLabel.new("What is #{@person1}'s #{@relative2} age? "),
            TextField.new("ans1")
          ]
        elsif @div===2
          [ 
            TextLabel.new("Take #{@person1}'s age as #{@var}"),
            TextLabel.new("#{@person1}'s #{@relative2} age is #{@a} years more than #{@b} times the age of #{@person1}."),
            TextLabel.new("What is #{@person1}'s #{@relative2} age? "),
            TextField.new("ans1")
          ]
        end
      end
    end

    def explain
      if @choose===0
        if @div===0
          if @rel1<3
            [ 
            SubLabel.new("#{@person1}'s age is #{@var}.#{@person1}'s #{@relative1} is #{@a} years younger than #{@person1}.Therefore #{@person1}'s #{@relative1} age is #{@var}-#{@a}")
            ]
          else
            [ 
            SubLabel.new("#{@person1}'s age is #{@var}.#{@person1}'s #{@relative1} is #{@c} years younger than #{@person1}.Therefore #{@person1}'s #{@relative1} age is #{@var}-#{@c}")
            ]
          end
        elsif @div===1
          [ 
            SubLabel.new("#{@person1}'s age is #{@var}.#{@person1}'s #{@relative1} age is #{@a} years less than 1/#{@b} times the age of #{@person1}. 1/#{@b} times the age of #{@person1} is #{@var}/#{@b}. Therefore #{@person1}'s #{@relative1} age is #{@var}/#{@b}-#{@a}")
          ]
        elsif @div===2
          [ 
            SubLabel.new("#{@person1}'s age is #{@var}.#{@person1}'s #{@relative1} age is #{@a} years more than 1/#{@b} times the age of #{@person1}. 1/#{@b} times the age of #{@person1} is #{@var}/#{@b}. Therefore #{@person1}'s #{@relative1} age is #{@var}/#{@b}+#{@a}")
          ]
        end
      elsif @choose===1
        if @div===0
          if @rel2<3
            [ 
            SubLabel.new("#{@person1}'s age is #{@var}.#{@person1}'s #{@relative2} is #{@a} years younger than #{@person1}.Therefore #{@person1}'s #{@relative2} age is #{@var}+#{@a}")
            ]
          else
            [ 
            SubLabel.new("#{@person1}'s age is #{@var}.#{@person1}'s #{@relative2} is #{@c} years younger than #{@person1}.Therefore #{@person1}'s #{@relative2} age is #{@var}+#{@c}")
            ]
          end
        elsif @div===1
          [             
            SubLabel.new("#{@person1}'s age is #{@var}.#{@person1}'s #{@relative2} age is #{@a} years less than #{@b} times the age of #{@person1}. #{@b} times the age of #{@person1} is #{@b}#{@var}. Therefore #{@person1}'s #{@relative2} age is #{@b}#{@var}-#{@a}")
          ]
        elsif @div===2
          [ 
            SubLabel.new("#{@person1}'s age is #{@var}.#{@person1}'s #{@relative2} age is #{@a} years more than #{@b} times the age of #{@person1}. #{@b} times the age of #{@person1} is #{@b}#{@var}. Therefore #{@person1}'s #{@relative2} age is #{@b}#{@var}+#{@a}")
          ]
        end
      end   
    end
  end




  class Try_17 < QuestionWithExplanation
    def self.type
      "Is this an Equation?"
    end
    def initialize
      @var = VARIABLES.sample
      @choose1 = rand(3)
      @choose2 = rand(8)
      @a = rand(10)+2
      @b = rand(10)+2
      @c = rand(10)+2
    end

    def solve
     { 
      "ans1" => "#{@var}",
      "equation" => (@choose1 == 0) ? "Equation" : "Not Equation"
     }
    end

    def text
      if @choose1 ===0
        if @choose2===0
          [
          TextLabel.new("State whether it is an equation or not. Also specify the variable"),
          TextLabel.new("#{@a}#{@var} + #{@b} = #{@c}"),
          InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===1
         [
            TextLabel.new("State whether it is an equation or not. Also specify the variable"),
            TextLabel.new("#{@a}#{@var} - #{@b} = #{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===2
          [
            TextLabel.new("State whether it is an equation or not. Also specify the variable"),
            TextLabel.new("#{@var} + #{@b} = #{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2==3
          [
            TextLabel.new("State whether it is an equation or not. Also specify the variable"),
            TextLabel.new("#{@var} - #{@b} = #{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2==4
         [
            TextLabel.new("State whether it is an equation or not. Also specify the variable"),
            TextLabel.new("#{@a}#{@var}  = #{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===5
          [
            TextLabel.new("State whether it is an equation or not. Also specify the variable"),
            TextLabel.new("#{@var} + #{@b} = -#{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===6
          [
            TextLabel.new("State whether it is an equation or not. Also specify the variable"),
            TextLabel.new("#{@var} + #{@b} = 0"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===7
          [
            TextLabel.new("State whether it is an equation or not. Also specify the variable"),
            TextLabel.new("-#{@var} + #{@b} = -#{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]     
        end
      elsif @choose1===1
       if @choose2===0
          [
          TextLabel.new("State whether it is an equation or not. Also specify the variable"),
          TextLabel.new("#{@a}#{@var} + #{@b} > #{@c}"),
          InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===1
         [
            TextLabel.new("State whether it is an equation or not. Also specify the variable"),
            TextLabel.new("#{@a}#{@var} - #{@b} > #{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===2
          [
            TextLabel.new("State whether it is an equation or not. Also specify the variable"),
            TextLabel.new("#{@var} + #{@b} > #{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2==3
          [
            TextLabel.new("State whether it is an equation or not. Also specify the variable"),
            TextLabel.new("#{@var} - #{@b} > #{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2==4
         [
            TextLabel.new("State whether it is an equation or not. Also specify the variable"),
            TextLabel.new("#{@a}#{@var}  > #{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===5
          [
            TextLabel.new("State whether it is an equation or not. Also specify the variable"),
            TextLabel.new("#{@var} + #{@b} > -#{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===6
          [
            TextLabel.new("State whether it is an equation or not. Also specify the variable"),
            TextLabel.new("#{@var} + #{@b} > 0"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===7
          [
            TextLabel.new("State whether it is an equation or not. Also specify the variable"),
            TextLabel.new("-#{@var} + #{@b} > -#{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]     
        end
      elsif @choose1==2
        if @choose2===0
          [
          TextLabel.new("State whether it is an equation or not. Also specify the variable"),
          TextLabel.new("#{@a}#{@var} + #{@b} < #{@c}"),
          InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===1
         [
            TextLabel.new("State whether it is an equation or not. Also specify the variable"),
            TextLabel.new("#{@a}#{@var} - #{@b} < #{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===2
          [
            TextLabel.new("State whether it is an equation or not. Also specify the variable"),
            TextLabel.new("#{@var} + #{@b} < #{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2==3
          [
            TextLabel.new("State whether it is an equation or not. Also specify the variable"),
            TextLabel.new("#{@var} - #{@b} < #{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2==4
         [
            TextLabel.new("State whether it is an equation or not. Also specify the variable"),
            TextLabel.new("#{@a}#{@var}  < #{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===5
          [
            TextLabel.new("State whether it is an equation or not. Also specify the variable"),
            TextLabel.new("#{@var} + #{@b} < -#{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===6
          [
            TextLabel.new("State whether it is an equation or not. Also specify the variable"),
            TextLabel.new("#{@var} + #{@b} < 0"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===7
          [
            TextLabel.new("State whether it is an equation or not. Also specify the variable"),
            TextLabel.new("-#{@var} + #{@b} < -#{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]     
        end
      end
    end

  def explain
      if @choose1 ===0
        if @choose2===0
          [
            SubLabel.new("Since it has a = symbol it is an equation. Also the variable involved is #{@var}"),
          ]
        elsif @choose2===1
          [
            SubLabel.new("Since it has a = symbol it is an equation. Also the variable involved is #{@var}"),
          ]
        elsif @choose2===2
          [
            SubLabel.new("Since it has a = symbol it is an equation. Also the variable involved is #{@var}"),
          ]
        elsif @choose2==3
          [
            SubLabel.new("Since it has a = symbol it is an equation. Also the variable involved is #{@var}"),
          ]
        elsif @choose2==4
          [
            SubLabel.new("Since it has a = symbol it is an equation. Also the variable involved is #{@var}"),
          ]
        elsif @choose2===5
          [
            SubLabel.new("Since it has a = symbol it is an equation. Also the variable involved is #{@var}"),
          ]
        elsif @choose2===6
          [
            SubLabel.new("Since it has a = symbol it is an equation. Also the variable involved is #{@var}"),
          ]
        elsif @choose2===7
          [
            SubLabel.new("Since it has a = symbol it is an equation. Also the variable involved is #{@var}"),
          ]     
        end
      elsif @choose1===1
       if @choose2===0
          [
            SubLabel.new("Since it has a > symbol it is an inequation. Also the variable involved is #{@var}"),
          ]
        elsif @choose2===1
         [
            SubLabel.new("Since it has a > symbol it is an inequation. Also the variable involved is #{@var}"),
         ]
        elsif @choose2===2
          [
            SubLabel.new("Since it has a > symbol it is an inequation. Also the variable involved is #{@var}"),
          ]
        elsif @choose2==3
          [
            SubLabel.new("Since it has a > symbol it is an inequation. Also the variable involved is #{@var}"),
          ]
        elsif @choose2==4
         [
            SubLabel.new("Since it has a > symbol it is an inequation. Also the variable involved is #{@var}"),
         ]
        elsif @choose2===5
          [
            SubLabel.new("Since it has a > symbol it is an inequation. Also the variable involved is #{@var}"),
          ]
        elsif @choose2===6
          [
            SubLabel.new("Since it has a > symbol it is an inequation. Also the variable involved is #{@var}"),
          ]
        elsif @choose2===7
          [
            SubLabel.new("Since it has a > symbol it is an inequation. Also the variable involved is #{@var}"),
          ]    
        end
      elsif @choose1==2
        if @choose2===0
          [
            SubLabel.new("Since it has a < symbol it is an inequation. Also the variable involved is #{@var}"),
          ]
        elsif @choose2===1
         [
            SubLabel.new("Since it has a < symbol it is an inequation. Also the variable involved is #{@var}"),
         ]
        elsif @choose2===2
          [
            SubLabel.new("Since it has a < symbol it is an inequation. Also the variable involved is #{@var}"),
          ]
        elsif @choose2==3
          [
            SubLabel.new("Since it has a < symbol it is an inequation. Also the variable involved is #{@var}"),
          ]
        elsif @choose2==4
         [
            SubLabel.new("Since it has a < symbol it is an inequation. Also the variable involved is #{@var}"),
         ]
        elsif @choose2===5
          [
            SubLabel.new("Since it has a < symbol it is an inequation. Also the variable involved is #{@var}"),
          ]
        elsif @choose2===6
          [
            SubLabel.new("Since it has a < symbol it is an inequation. Also the variable involved is #{@var}"),
          ]
        elsif @choose2===7
          [
            SubLabel.new("Since it has a < symbol it is an inequation. Also the variable involved is #{@var}"),
          ]    
        end
      end
    end
end




  class Try_18 < QuestionWithExplanation
    def self.type
      "Find x 1"
    end
    def initialize
      @choose = rand(2)
      @a = rand(100)+1
      @b = rand(100)+1
      @c = rand(5)+2
      @d = rand(10)+2
      @e = rand(10)+2
      @f = rand(10)+1
      @g = (@c*@d) + @f
      @h = (@c*@e) + @f
      @i = @b-@a
      @j = @e-@d
    end
    def solve
      if @choose===0
       { "ans" => @b-@a }
      else
        {"ans" => @e-@d} 
      end
     
    end
    def text
      if @choose===0
        [TextLabel.new("Find the value of x "), TextLabel.new("X  + #{@a} = #{@b}"),InlineBlock.new(TextLabel.new("Answer:"), TextField.new("ans"))]
      else
       [TextLabel.new("Find the value of x "), TextLabel.new("#{@c}X  + #{@g} = #{@h}"),InlineBlock.new(TextLabel.new("Answer:"), TextField.new("ans"))]
     end
    end

    def explain
      if @choose===0
        [
          SubLabel.new("Substitute the value of x equal to (#{@i}) in the equation X  + #{@a} = #{@b} to see that it is satisfied")
        ]
      else
        [
          SubLabel.new("Substitute the value of x equal to (#{@j}) in the equation #{@c}X  + #{@g} = #{@h} to see that it is satisfied")
        ]
     end
    end
  end

  class Try_19 < QuestionWithExplanation
    def self.type
      "Find x 2"
    end
    def initialize(nums = nil)
      if nums.nil?
        @nums = Array.new(5).map { Grade6ops::rand_num(0.4,1,2) }
      else
        @nums = nums
      end
      @choose = rand(2) 
      @location1 = rand(5)
      @location2 = rand(5)
      @a = rand(100)+1
      @b = rand(100)+1
      @c = rand(5)+2
      @d = rand(10)+2
      @e = rand(10)+2
      @f = rand(10)+1
      @g = (@c*@d) + @f
      @h = (@c*@e) + @f
      @i = @b-@a
      @j = @e-@d
      @nums[@location1] = @i
      @nums[@location2] = @j
    end
    def solve
      if @choose===0
       { "ans" => @b-@a }
      else
        {"ans" => @e-@d} 
      end
     
    end
    def text
      if @choose===0
        [TextLabel.new("Select the value of x that satisfies the given equation. "), TextLabel.new("X  + #{@a} = #{@b}"),RadioButton.new("ans", @nums)]
      else
       [TextLabel.new("Select the value of x that satisfies the given equation "), TextLabel.new("#{@c}X  + #{@g} = #{@h}"),RadioButton.new("ans", @nums)]
     end
    end

    def explain
      if @choose===0
        [
          SubLabel.new("Substitute the value of x equal to (#{@i}) in the equation X  + #{@a} = #{@b} to see that it is satisfied")
        ]
      else
        [
          SubLabel.new("Substitute the value of x equal to (#{@j}) in the equation #{@c}X  + #{@g} = #{@h} to see that it is satisfied")
        ]
     end
    end
  end
  
  PROBLEMS = [
    
   Algebra_6::Try_11,
    Algebra_6::Try_12,
    Algebra_6::Try_13,
    Algebra_6::Try_14,
    Algebra_6::Try_15,
    Algebra_6::Try_16,
    Algebra_6::Try_17,
    Algebra_6::Try_18,
    Algebra_6::Try_19,
    Algebra_6::Try_20
   

    ] # //Anurag is module name and dummy is class name
end