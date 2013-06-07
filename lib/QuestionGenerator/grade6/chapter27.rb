
#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml'
require_relative './preg6'

# TODO override preprocess for the add commas question ( default is now to remove commas )
include ToHTML
include PreG6

module Chapter27
  INDEX = "chapter27"
  TITLE = "Power and Exponents"
  class Findpower < QuestionBase
    def self.type
      "findpower"
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
  end




  class Valuepower < QuestionBase
    def self.type
      "value of power"
    end
    def initialize
      @numbr=rand(4)+1
      @num=rand(10)-5
      @num_ans= @numbr**(@num)
    end
    def solve
      {"ans" => @num_ans}
    end
    def text
      [TextLabel.new("Calculate the value:"), InlineBlock.new(Exponent.new(@numbr,@num), TextField.new("ans"))]
    end
  end
# Exponent.new(TextLabel.new("#{@numbr}"),TextLabel.new("#{@num}"))



  class Comparing < QuestionBase
    def self.type
      "Comparison of two numbers"
    end
    def initialize
      @numbr1=(rand(1000)+1).to_f/100
      @num1 = rand(10)+1
      @numbr2=(rand(1000)+1).to_f/100
      @num2=rand(10)+1
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
    end

  class Simplify < QuestionBase
    def self.type
    "Simplify the equation"
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
   {"ans1" => @num1- @num4,
   "ans2" => @num2 -@num5,
   "ans3" => @num3 -@num6}
   end
    def text
      # [Fraction.new(InlineBlock.new(Exponent.new(2,3), Exponent.new(1,2))]
    [TextLabel.new("Write the power of each number/variable mentioned in the box and write the final answer"),Fraction.new(InlineBlock.new(Exponent.new(@numbr2,@num2),TextLabel.new("X"),Exponent.new(@numbr1,@num1),TextLabel.new("X"),Exponent.new(TextLabel.new("t"),@num3)),
    InlineBlock.new(Exponent.new(TextLabel.new("t"),@num6),TextLabel.new("X"),Exponent.new(@numbr1,@num1),TextLabel.new("X"),Exponent.new(@numbr2,@num5))),
    InlineBlock.new(TextLabel.new("#{@numbr1}"),TextField.new("ans1"),TextLabel.new("#{@numbr2}"),TextField.new("ans2"),TextLabel.new("t"),TextField.new("ans3"))]
    end
  end

class Expansion < QuestionBase
  def self.type
    "Expand and solve"
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
  end

  def solve
    {"ans" => @ans.to_f }
  end
  def text
    [TextLabel.new("Solve the equation"), InlineBlock.new(Exponent.new(@numbr1,@num1),TextLabel.new("+"),
      Exponent.new(@numbr2,@num2),TextLabel.new("+"),Exponent.new(@numbr3,@num3),TextLabel.new("+"),Exponent.new(@numbr4,@num4)),TextLabel.new("Answer"),TextField.new("ans")]
  end
end

    class Standardform < QuestionBase
      def self.type
        "Express in Standard form"
      end
      def initialize
         @numbr1=rand(100000000000000000000000) + 1
         
      end
      def solve
          num_str=@numbr1.to_s
          num_str_len=num_str.length
          num_ans1=(@numbr1/(10**(num_str_len - 2))).to_f
          num_ans1=num_ans1/10.0
          {"ans1" => num_ans1,
            "ans2" => num_str_len-1}

      end
      def text
        [TextLabel.new("Express the number in standard form upto 1 decimal place"), InlineBlock.new(TextLabel.new("#{@numbr1}")),TextLabel.new(""),
          InlineBlock.new(TextLabel.new("Answer"),TextField.new("ans1"),TextLabel.new("x  "),Exponent.new(10,TextField.new("ans2")))]
      end
    end
# InlineBlock.new(TextLabel.new("Answer"),TextField.new("ans1"),TextLabel.new("X   10^"),TextField.new("ans2"))]



    PROBLEMS = [Chapter27::Findpower,
      Chapter27::Valuepower,
      Chapter27::Comparing,
      Chapter27::Simplify,
      Chapter27::Expansion,
      Chapter27::Standardform]                    

    end