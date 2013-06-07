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
  TITLE = "Algebra_6"
  
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
  RELATIONS2 =["brother", "sister", "cousin", "mother", "father", "grandmother", "granfather"]
 
  class Try_1 < QuestionBase
    def self.type
      "Try_1"
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
      "ans1" => "#{@var}#{@a}"
     }
    end
    

    def text
      if @choose ===3
        [TextLabel.new("A bird flies #{@a} #{@option1value}. Can you express the total diastance covered by the bird in terms of flying time.(Use #{@var} for flying time in #{@option3value})"), 
        TextField.new("ans1")
        
        ]
      else
        [TextLabel.new("There are #{@a} #{@option1value}. Write the expression for the total number of #{@option2value}.(Use #{@var} for the number of #{@option3value})"), 
        TextField.new("ans1")
        
        ]
      end
    end
  end

  class Try_2 < QuestionBase
    def self.type
      "Try_2"
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
    # def correct?(params)
    #   solsum = 0
    #   bool = true
    #   resps = QuestionBase.vars_from_response( *( (1...2).map { |i| "ans#{i}" }), params)
    #   puts "********\n" + resps.to_s + "********\n"
    #   (((resps[0]) == "#{@b}+{@a}#{@var}")or((resps[0]) == "#{@a}#{@var}+#{@b}"))
    # end
    def text
      [
          TextLabel.new("Ram puts #{@option1value}. There are #{@a} #{@option1value}. #{@b} extra #{@option2value} remain. Write the expression for the total number of #{@option2value}.(Use #{@var} for the number of #{@option3value})"), 
          TextField.new("ans1")
      ]
    end
  end

  class Try_3 < QuestionBase
    def self.type
      "Try_3"
    end
    def initialize
      @choose = rand(11)
      @sides = @choose+3
      @option1value = SHAPES[@choose]
    end

    def solve
      if @choose <8
        {
       "ans1" => "#{@sides}l" 
        }
      elsif @choose===8
        {
        "ans1" => "2l+2b"
        }
      elsif @choose ===9
        {
        "ans1" => "12l"
        } 
      elsif @choose ===10
        {
        "ans1" => "4l+4b+4h"
        }
      end
    end

    def text
      if @choose<8
        [
          TextLabel.new(" Write the expression for the perimeter of  a #{@option1value}.(Use l as the side of #{@option1value})"), 
        TextField.new("ans1")
        
        ]
      elsif @choose===9
        [
         TextLabel.new(" Write the expression for the perimeter of  a #{@option1value}.(Use l as the side of #{@option1value})"), 
        TextField.new("ans1") 
        ]
      elsif @choose===8
          [
            TextLabel.new(" Write the expression for the perimeter of  a #{@option1value}.(Use l as the length and b as the breadth)"), 
        TextField.new("ans1")
          ]
      elsif @choose===10
            [
              TextLabel.new(" Write the expression for the perimeter of  a #{@option1value}.(Use l as the length and b as the breadth and h as the height)"), 
        TextField.new("ans1")
            ]
      end
    end
  end
  

 class Try_4 < QuestionBase
    def self.type
      "Try_4"
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
  end

  class Try_5 < QuestionBase
    def self.type
      "Try_5"
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
  end
  
    class Try_6 < QuestionBase
    def self.type
      "Try_6"
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
    end

    def solve
      if @choose===0
        if @div===0
          { 
          "ans1" => "#{@var}-#{@a}"
          }
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
          { 
          "ans1" => "#{@var}+#{@a}"
          }
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

    def text
      if @choose===0
        if @div===0
          [ 
            TextLabel.new("Take #{@person1}'s age as #{@var}"),
            TextLabel.new("#{@person1}'s #{@relative1} is #{@a} years younger than #{@person1}."),
            TextLabel.new("What is #{@person1}'s #{@relative1} age? "),
            TextField.new("ans1")
          ]
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
          [ 
            TextLabel.new("Take #{@person1}'s age as #{@var}"),
            TextLabel.new("#{@person1}'s #{@relative1} is #{@a} years older than #{@person1}."),
            TextLabel.new("What is #{@person1}'s #{@relative1} age? "),
            TextField.new("ans1")
          ]
        elsif @div===1
          [ 
            TextLabel.new("Take #{@person1}'s age as #{@var}"),
            TextLabel.new("#{@person1}'s #{@relative1} age is #{@a} years less than #{@b} times the age of #{@person1}."),
            TextLabel.new("What is #{@person1}'s #{@relative1} age? "),
            TextField.new("ans1")
          ]
        elsif @div===2
          [ 
            TextLabel.new("Take #{@person1}'s age as #{@var}"),
            TextLabel.new("#{@person1}'s #{@relative1} age is #{@a} years more than #{@b} times the age of #{@person1}."),
            TextLabel.new("What is #{@person1}'s #{@relative1} age? "),
            TextField.new("ans1")
          ]
        end
          
            
      end
      
    end
  end

  class Try_7 < QuestionBase
    def self.type
      "Try_7"
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
          TextLabel.new("State whwther it is an equation or not. Alsospecify the variable"),
          TextLabel.new("#{@a}#{@var} + #{@b} = #{@c}"),
          InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===1
         [
            TextLabel.new("State whwther it is an equation or not. Alsospecify the variable"),
            TextLabel.new("#{@a}#{@var} - #{@b} = #{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===2
          [
            TextLabel.new("State whwther it is an equation or not. Alsospecify the variable"),
            TextLabel.new("#{@var} + #{@b} = #{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2==3
          [
            TextLabel.new("State whwther it is an equation or not. Alsospecify the variable"),
            TextLabel.new("#{@var} - #{@b} = #{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2==4
         [
            TextLabel.new("State whwther it is an equation or not. Alsospecify the variable"),
            TextLabel.new("#{@a}#{@var}  = #{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===5
          [
            TextLabel.new("State whwther it is an equation or not. Alsospecify the variable"),
            TextLabel.new("#{@var} + #{@b} = -#{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===6
          [
            TextLabel.new("State whwther it is an equation or not. Alsospecify the variable"),
            TextLabel.new("#{@var} + #{@b} = 0"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===7
          [
            TextLabel.new("State whwther it is an equation or not. Alsospecify the variable"),
            TextLabel.new("-#{@var} + #{@b} = -#{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]     
        end
      elsif @choose1===1
       if @choose2===0
          [
          TextLabel.new("State whwther it is an equation or not. Alsospecify the variable"),
          TextLabel.new("#{@a}#{@var} + #{@b} > #{@c}"),
          InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===1
         [
            TextLabel.new("State whwther it is an equation or not. Alsospecify the variable"),
            TextLabel.new("#{@a}#{@var} - #{@b} > #{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===2
          [
            TextLabel.new("State whwther it is an equation or not. Alsospecify the variable"),
            TextLabel.new("#{@var} + #{@b} > #{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2==3
          [
            TextLabel.new("State whwther it is an equation or not. Alsospecify the variable"),
            TextLabel.new("#{@var} - #{@b} > #{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2==4
         [
            TextLabel.new("State whwther it is an equation or not. Alsospecify the variable"),
            TextLabel.new("#{@a}#{@var}  > #{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===5
          [
            TextLabel.new("State whwther it is an equation or not. Alsospecify the variable"),
            TextLabel.new("#{@var} + #{@b} > -#{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===6
          [
            TextLabel.new("State whwther it is an equation or not. Alsospecify the variable"),
            TextLabel.new("#{@var} + #{@b} > 0"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===7
          [
            TextLabel.new("State whwther it is an equation or not. Alsospecify the variable"),
            TextLabel.new("-#{@var} + #{@b} > -#{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]     
        end
      elsif @choose1==2
        if @choose2===0
          [
          TextLabel.new("State whwther it is an equation or not. Alsospecify the variable"),
          TextLabel.new("#{@a}#{@var} + #{@b} < #{@c}"),
          InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===1
         [
            TextLabel.new("State whwther it is an equation or not. Alsospecify the variable"),
            TextLabel.new("#{@a}#{@var} - #{@b} < #{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===2
          [
            TextLabel.new("State whwther it is an equation or not. Alsospecify the variable"),
            TextLabel.new("#{@var} + #{@b} < #{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2==3
          [
            TextLabel.new("State whwther it is an equation or not. Alsospecify the variable"),
            TextLabel.new("#{@var} - #{@b} < #{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2==4
         [
            TextLabel.new("State whwther it is an equation or not. Alsospecify the variable"),
            TextLabel.new("#{@a}#{@var}  < #{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===5
          [
            TextLabel.new("State whwther it is an equation or not. Alsospecify the variable"),
            TextLabel.new("#{@var} + #{@b} < -#{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===6
          [
            TextLabel.new("State whwther it is an equation or not. Alsospecify the variable"),
            TextLabel.new("#{@var} + #{@b} < 0"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]
        elsif @choose2===7
          [
            TextLabel.new("State whwther it is an equation or not. Alsospecify the variable"),
            TextLabel.new("-#{@var} + #{@b} < -#{@c}"),
            InlineBlock.new(TextLabel.new("variable = "),TextField.new("ans1"),Dropdown.new("equation", "Equation", "Not Equation"))
          ]     
        end
      end
    end
  end

  class Try_8 < QuestionBase
    def self.type
      "Try_8"
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
  end

  class Try_9 < QuestionBase
    def self.type
      "Try_9"
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
  end
  
  PROBLEMS = [
    
   Algebra_6::Try_1,
    Algebra_6::Try_2,
    Algebra_6::Try_3,
    Algebra_6::Try_4,
    Algebra_6::Try_5,
    Algebra_6::Try_6,
    Algebra_6::Try_7,
    Algebra_6::Try_8,
    Algebra_6::Try_9
   

    ] # //Anurag is module name and dummy is class name
end