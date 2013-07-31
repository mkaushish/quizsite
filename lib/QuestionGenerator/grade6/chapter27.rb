
#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml'
require_relative './preg6'

# TODO override preprocess for the add commas question ( default is now to remove commas )
include ToHTML
include PreG6

module Chapter27
  INDEX = 15
  TITLE = "Power and Exponents"
  class Findpowerexp < QuestionWithExplanation
    def self.type
      "Find Power"
    end
    def initialize
      @numbr=2
      @num=rand(10)+1
    end
    def solve
      {"ans" => @num}
    end
    def text
      [TextLabel.new("Calculate the power of 2 in the number:"), InlineBlock.new(TextLabel.new("#{(@numbr)**@num} = "), TextField.new("ans"))]
    end
    def explain
      [
        Subproblem.new([TextLabel.new("To find the power of 2, find the number of times you multiply 2 with itself to reach the number. For example:- ")]),
        Subproblem.new([TextLabel.new("Find the power of 2 in 16")]),
        Subproblem.new([TextLabel.new("2 x 2 =4, 2 x 2 x 2 = 8, 2 x 2 x 2 x 2 = 16")]),
        Subproblem.new([TextLabel.new("Hence, 2 is multiplied 4 times, therefore power of 2 is 4")])
      ]
    end
  end




  class Valuepowerexp1 < QuestionWithExplanation
    def self.type
      "Value of Power"
    end
    def initialize
      @numbr=rand(4)+1
      @num=rand(10)-5
   
    end
    def solve

      if @num < 0
          @num_ans1 = 1
          @num_ans2= @numbr**(-@num) 
      else
          @num_ans1=@numbr**(@num)
          @num_ans2=1
      end
      {
        "ans1" => @num_ans1,
        "ans2" => @num_ans2
      }
    end
    def text
      [TextLabel.new("Calculate the value:"), InlineBlock.new(Exponent.new(@numbr,@num), TextLabel.new(" = "),Fraction.new("ans1","ans2"))]
    end
    def explain
      [
        Subproblem.new([TextLabel.new("To find the value of power, multiply the number by itself by the number given in power. If the power is negative, then the number becomes a fraction with number being denominator. For example:-")]),
        Subproblem.new([InlineBlock.new(TextLabel.new("Find the value of"),Exponent.new(3,3),TextLabel.new(" and "),Exponent.new(3,-3))]),
        Subproblem.new([InlineBlock.new(Exponent.new(3,3),TextLabel.new(" = 3 x 3 x 3 = 27 and "),Exponent.new(3,-3),TextLabel.new(" = "),Fraction.new(1,Exponent.new(3,3)))]),
        Subproblem.new([InlineBlock.new(Exponent.new(3,3),TextLabel.new("= 27, "),Exponent.new(3,-3),TextLabel.new(" = "),Fraction.new(1,27))])
      ]
    end
  end
# Exponent.new(TextLabel.new("#{@numbr}"),TextLabel.new("#{@num}"))



  class Comparingexp < QuestionWithExplanation
    def self.type
      "Comparison of two Exponents"
    end
    def initialize
      @numbr1=(rand(100)+1).to_f/10
      @num1 = rand(10)+1
      @numbr2=(rand(100)+1).to_f/10
      @num2=rand(10)+1
      @randeq=rand(25)+1
      if @randeq%5 == 0
        @numbr1=@numbr2
        @num1=@num2
      end
    end
    def solve
      if @numbr1**(@num1) > @numbr2**(@num2)
        {"ans" => '>' } 
    elsif @numbr1**(@num1) < @numbr2**(@num2)
        {"ans" =>  '<' } 
      else
        {"ans" => '=' }
      end
    end
    def text
      [TextLabel.new("Choose if the 1st number is greater than,equal or less than 2nd number. "),Exponent.new(TextLabel.new("#{@numbr1}"),TextLabel.new("#{@num1}")),
      Dropdown.new("ans",'<','=','>'),Exponent.new(TextLabel.new("#{@numbr2}"),TextLabel.new("#{@num2}"))]
      end
      def explain
        [
        SubLabel.new("Calculate both the numbers with powers and compare the result. You can also do it by observation. If a bigger number and smaller number has same power, then it's obvious that the bigger number has a larger value.
          A number less than 0 with power greater than 2 always decreases in value")
        ]
      end
    end

  class Simplifyexp < QuestionWithExplanation
    def self.type
    "Simplify the Equation"
    end
    def initialize
    @numbr1=rand(20)+1
    @numbr2=rand(20)+1
    @numbr3="t"
    @num1=rand(15)+1
    @num2=rand(10)+1
    @num3=rand(10)+1
    @num4=rand(10)+1
    @num5=rand(10)+1
    @num6=rand(10)+1
    end

    def solve
   {"ans1" => @num1 -@num4,
   "ans2" => @num2 -@num5,
   "ans3" => @num3 -@num6}
   end
    def text
      # [Fraction.new(InlineBlock.new(Exponent.new(2,3), Exponent.new(1,2))]
    [TextLabel.new("Write the power of each number/variable mentioned in the box and write the final answer"),Fraction.new(InlineBlock.new(Exponent.new(@numbr2,@num2),TextLabel.new("X"),Exponent.new(@numbr1,@num1),TextLabel.new("X"),Exponent.new(TextLabel.new("t"),@num3)),
    InlineBlock.new(Exponent.new(TextLabel.new("t"),@num6),TextLabel.new("X"),Exponent.new(@numbr1,@num4),TextLabel.new("X"),Exponent.new(@numbr2,@num5))),
    InlineBlock.new(Exponent.new(TextLabel.new("#{@numbr1}"),TextField.new("ans1")),TextLabel.new(" x "),Exponent.new(TextLabel.new("#{@numbr2}"),TextField.new("ans2")),TextLabel.new(" x "),Exponent.new(TextLabel.new("t"),TextField.new("ans3")))]
    end
    def explain
      [
        Subproblem.new([TextLabel.new("When the power are given in denominator, then they can be rewritten as numerator with negative power and then we can directly add the powers")]),
        Subproblem.new([InlineBlock.new(TextLabel.new("Suppose a fraction is given "),Fraction.new(Exponent.new(2,7),Exponent.new(2,4)),TextLabel.new("Find the power of 2"))]),
        Subproblem.new([InlineBlock.new(Exponent.new(2,7),TextLabel.new(" x "),Exponent.new(2,-4))]),
        Subproblem.new([InlineBlock.new(Exponent.new(2,TextLabel.new("7+(-4)")),TextLabel.new(" = "),Exponent.new(2,3),TextLabel.new(" Hence,The power of 2 is 3"))])
      ]
    end
  end

class Expansionexp < QuestionWithExplanation
  def self.type
    "Expand and Solve"
  end
  def initialize
    @numbr1=rand(10) + 1
    @numbr2=rand(10) - 8
    @numbr3=rand(20) + 1
    @numbr4=rand(5)  - 5
    @num1=rand(5) - 8
    @num2=rand(5)
    @num3=rand(5)
    @num4=rand(5) 
    @ans = @numbr1**(@num1) + @numbr2**(@num2) + @numbr3**(@num3) + @numbr4**(@num4)
    if @numbr1 < 0
      @numbr11="(#{@numbr1})"
    else
      @numbr11="#{@numbr1}"
    end
    if @numbr2 < 0
      @numbr22="(#{@numbr2})"
    else
      @numbr22="#{@numbr2}"
    end
    if @numbr3 < 0
      @numbr33="(#{@numbr3})"
    else
      @numbr33="#{@numbr3}"
    end
    if @numbr4 < 0
      @numbr44="(#{@numbr4})"
    else
      @numbr44="#{@numbr4}"
    end

  end

  def solve
    {"ans" => @ans.to_f }
  end
  def text
    [TextLabel.new("Find the value"), InlineBlock.new(Exponent.new(TextLabel.new(@numbr11),TextLabel.new(@num1)),TextLabel.new("+"),
      Exponent.new(TextLabel.new(@numbr22),TextLabel.new(@num2)),TextLabel.new("+"),Exponent.new(TextLabel.new(@numbr33),TextLabel.new(@num3)),TextLabel.new("+"),Exponent.new(TextLabel.new(@numbr44),TextLabel.new(@num4))),TextLabel.new("Answer"),TextField.new("ans")]
  end
  def explain
    [
      SubLabel.new("Calculate the value of each term with power and find the value of the expression.")
    ]
  end
end

    class Standardformexp < QuestionWithExplanation
      def self.type
        "Express in Standard Form"
      end
      def initialize
         
         @rand1=rand(3)
         if(@rand1 == 1)
         @numbr1=rand(100000000000000) + 1
         elsif (@rand1 == 2)
           @numbr1=rand(1000000000) + 1 
         else
          @numbr1=rand(1000000) + 1
        end
         @num_str=@numbr1.to_s
          
          @num_str_len=@num_str.length
          @num_ans1=(@numbr1/(10**(@num_str_len - 2))).to_f
          @num_ans1=@num_ans1/10.0
          @numstr = ""

          for i in 0..@num_str_len - 1
            if i%3 == 0 && i >0
              @numstr=@numstr + "," + @num_str.reverse[i]
            else
              @numstr=@numstr + @num_str.reverse[i]
            end
          
          end
          @numstr=@numstr.reverse
          @num_str_len=@num_str_len - 1 
      end
      def solve
          {"ans1" => @num_ans1,
           "ans2" => @num_str_len}
      end
      def text
        [
          TextLabel.new("Express the number in standard form upto 1 decimal place"), 
          TextLabel.new("#{@numstr}"),
          InlineBlock.new(TextLabel.new("Answer"),TextField.new("ans1"),TextLabel.new("x  "),Exponent.new(10,TextField.new("ans2")))
        ]
      end
      def explain
        [
          Subproblem.new([TextLabel.new("To express the number in standard form, the number is written into its decimal form and powers of 10")]),
          Subproblem.new([TextLabel.new("Here for example, You have to write upto one decimal place, so you have to put decimal after first digit and then count the number of digits after the decimal point which will be the power of 10")]),
          Subproblem.new([InlineBlock.new(TextLabel.new("eg:- If a number is 5,367, then it can be written as 5.367 x "),Exponent.new(10,3),TextLabel.new("which is equal to 5.367 x 1000 = 5367"))])
        ]
      end
    end
# InlineBlock.new(TextLabel.new("Answer"),TextField.new("ans1"),TextLabel.new("X   10^"),TextField.new("ans2"))]



    PROBLEMS = [Chapter27::Findpowerexp,
      Chapter27::Valuepowerexp1,
      Chapter27::Comparingexp,
      Chapter27::Simplifyexp,
      Chapter27::Expansionexp,
      Chapter27::Standardformexp]                    

    end