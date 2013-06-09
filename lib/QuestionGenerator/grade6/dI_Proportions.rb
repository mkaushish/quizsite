
#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml'
require_relative './preg6'
require 'prime'

# TODO override preprocess for the add commas question ( default is now to remove commas )
include ToHTML
include PreG6

module DI_Proportions
  INDEX = "dI_Proportions" 
  TITLE = "DI_Proportions"
  

  class DirectProportionEasy < QuestionBase
    def self.type
      "Direct Proportion Level 1"
    end
    def initialize
      @num1=rand(99)+1
      @num2=rand(99)+1
      @mult =rand(50)+1
    end
    def solve
      {"ans" => @num2*@mult}
    end
    def text
      [TextLabel.new("Fill in the blanks(Direct Proportion):"), InlineBlock.new(TextLabel.new("#{@num1} : #{@num1*@mult} = "),  TextLabel.new(" #{@num2} : "), TextField.new("ans"))]
    end
  end

class IndirectProportionEasy < QuestionBase
    def self.type
      "Indirect Proportion Level 1"
    end
    def initialize
      @num1=rand(99)+1
      @mult2=rand(99)+1
      @comm = rand(50)+1
    end
    def solve
      {"ans" => @mult2}
    end
    def text
      [TextLabel.new("Fill in the blanks(Indirect Proportion):"), InlineBlock.new(TextLabel.new("#{@num1} : #{@mult2*@comm} = "),  TextLabel.new(" #{@num1*@comm} : "), TextField.new("ans"))]
    end
  end

class MixedEasy < QuestionBase
    def self.type
      "Mixed Level 1"
    end
    def initialize
      @choose = rand(2)      
      if @choose === 0
      @num1=rand(99)+1
      @num2=rand(99)+1
      @mult =rand(20)+1
      @mult2 = @num2*@mult
      @num3 =rand(50)+1
      if @num1 === @num3
        @num3 =rand(50)+1
      end
      if @num1 === @num2
        @num2 =rand(50)+1
      end        
      @resp1 = @num1*@mult
      @resp3 = @num3*@mult
      else
      @num1=rand(99)+1
      @mult2=rand(99)+1
      @comm = rand(10)+1
      @comm2 = rand(10)+2

      end
    end
    def solve
      {
        "ans" => @mult2 
      }
    end
    def text
      if @choose === 1
        [TextLabel.new("Fill in the blanks:"), InlineBlock.new(TextLabel.new("#{@num1} : #{@mult2*@comm*@comm2} :: "),TextLabel.new("#{@num1*@comm2} : #{@mult2*@comm} = ") , TextLabel.new(" #{@num1*@comm*@comm2} : "), TextField.new("ans"))]
      else
        [TextLabel.new("Fill in the blanks:"),
         InlineBlock.new(TextLabel.new("#{@num1} : #{@resp1} :: #{@num3} : #{@resp3} =   #{@num2} : "),TextField.new("ans"))]
      end
    end
  end


  class DirectProportion < QuestionBase
    def self.type
      "Direct Proportion Level 2"
    end
    def initialize
      @num1=rand(9)+1
      @num2=rand(99)+1
      @resp1 = rand(99)+1
      @num = @num2*@resp1
      @den = @num1
    end
    def solve
      hcf=Grade6ops.euclideanalg(@num, @den)
      {"num" => @num/hcf,
       "den" => @den/hcf}
    end
    def text
      [TextLabel.new("Fill in the blanks(Direct Proportion):"), InlineBlock.new(TextLabel.new("#{@num1} : #{@resp1} = "),  TextLabel.new(" #{@num2} : "), Fraction.new("num", "den"))]
    end
  end
class IndirectProportion < QuestionBase
    def self.type
      "Indirect Proportion Level 2"
    end
    def initialize
      @num1=rand(9)+1
      @num2=rand(99)+1
      @resp1 = rand(99)+1
      @num = @num1*@resp1
      @den = @num2
    end
    def solve
      hcf=Grade6ops.euclideanalg(@num, @den)
      {"num" => @num/hcf,
       "den" => @den/hcf}
    end
    def text
      [TextLabel.new("Fill in the blanks(Indirect Proportion):"), InlineBlock.new(TextLabel.new("#{@num1} : #{@resp1} = "),  TextLabel.new(" #{@num2} : "), Fraction.new("num", "den"))]
    end
  end
class Mixed < QuestionBase
    def self.type
      "Mixed Level 2"
    end
    def initialize
      @choose = rand(2)
      @num1=rand(9)+1
      @num2=rand(99)+1
      @resp1 = rand(99)+1
      @mult = rand(30)+1
      if @choose === 0
        @num = @num2*@resp1
        @den = @num1 
        @num3 = @num1*@mult
        @resp3 = @resp1*@mult
      else  
        @num = @num1*@resp1
        @den = @num2
        @num3 = @num1*@mult
        @resp3 = @resp1/@mult
      end
    end
    def solve
      hcf=Grade6ops.euclideanalg(@num, @den)
      {"num" => @num/hcf,
       "den" => @den/hcf}
    end
    def text
      if @choose === 1
        [TextLabel.new("Fill in the blanks:"), InlineBlock.new(TextLabel.new("#{@num1} : #{@resp1} :: "),TextLabel.new("#{@num3} :"), Fraction.new( TextLabel.new(@resp1), TextLabel.new(@mult)),  TextLabel.new(" = #{@num2} : "), Fraction.new("num", "den"))]
      else
        [TextLabel.new("Fill in the blanks:"), InlineBlock.new(TextLabel.new("#{@num1} : #{@resp1} :: "),TextLabel.new("#{@num3} :"),TextLabel.new("#{@resp3}"),  TextLabel.new(" = #{@num2} : "), Fraction.new("num", "den"))]
      end
    end
  end



  PROBLEMS = [   DI_Proportions::DirectProportionEasy, DI_Proportions::IndirectProportionEasy, DI_Proportions::MixedEasy, DI_Proportions::DirectProportion, DI_Proportions::IndirectProportion, DI_Proportions::Mixed ] 
end

