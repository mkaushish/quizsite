#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml'
require_relative './preg6'
require 'prime'

# TODO override preprocess for the add commas question ( default is now to remove commas )
include ToHTML
include PreG6

module Anurag
  INDEX = "anurag"
  TITLE = "Anurag"
  


  class Level_1 < QuestionBase
    def self.type
      "Level_1"
    end
    def initialize
      # @prod=rand(6)
      @a = rand(100)+1
      
        
      @b = rand(100)+1
    end
    def solve
     { "ans" => @b-@a }
    end
    def text
      [TextLabel.new("Find the value of x "), TextLabel.new("X  + #{@a} = #{@b}"),InlineBlock.new(TextLabel.new("Answer:"), TextField.new("ans"))]
    end
  end

  class Level_2 < QuestionBase
    def self.type
      "Level_2"
    end
    def initialize
      # @prod=rand(6)
      @a = rand(10)+1
      
      @b = rand(100)+1
      @d = rand(100)+1
      @num = @d-@b
      @den = @a
    end
    def solve
      

      hcf=Grade6ops.euclideanalg(@num, @den)
      {"num" => @num/hcf,
        "den" => @den/hcf}
    end
    def text
      [TextLabel.new("Find the value of x in lowest fractional form:"), TextLabel.new("#{@a}X  + #{@b} = #{@d}"),InlineBlock.new(TextLabel.new("Answer:"), Fraction.new("num", "den"))]
    end
  end
  class Level_3 < QuestionBase
    def self.type
      "Level_3"
    end
    def initialize
      # @prod=rand(6)
      @a = rand(10)+1
      @c = rand(10)+1
      if @c === @a
        @c=rand(10)
      end
        
      @b = rand(100)+1
      @d = rand(100)+1
      @num = @d-@b
      @den = @a-@c
      if @den < 0 
        @den = (-1)*@den
        @num = (-1)*@num
      end
    end
    def solve
      

      hcf=Grade6ops.euclideanalg(@num, @den)
      {"num" => @num/hcf,
        "den" => @den/hcf}
    end
    def text
      [TextLabel.new("Find the value of x in lowest fractional form:"), TextLabel.new("#{@a}X  + #{@b} = #{@c}X  + #{@d}"),InlineBlock.new(TextLabel.new("Answer:"), Fraction.new("num", "den"))]
    end
  end

  class Level_4 < QuestionBase
    def self.type
      "Level_4"
    end
    def initialize
      # @prod=rand(6)
      @a = rand(10)+1
      @c = rand(10)+1
      @e = rand(10)+1
      @f = rand(10)+1
      @g = rand(10)+1
      @b = @e*@f
      
      @d = @e*@g
      if(@a*@d)-(@b*@c)===0
        @c=rand(10)+1
      end
        
      
      @num = (@a*@d)-(@b*@c)
      @den = @b*@d
      
    end
    def solve
      

      hcf=Grade6ops.euclideanalg(@num, @den)
      {"num" => @num/hcf,
        "den" => @den/hcf,
        "a" => @a,
        "b" => @b,
        "c" => @c,
        "d" => @d
      }
    end
    def text
      [TextLabel.new("Find the value of x in lowest fractional form:"), 
        InlineBlock.new(TextLabel.new("X  + "),Fraction.new(TextLabel.new(@a), TextLabel.new(@b)),TextLabel.new(" = "),Fraction.new(TextLabel.new(@c), TextLabel.new(@d))),
          InlineBlock.new(TextLabel.new("Answer:"), Fraction.new("num", "den"))
        ]
    end
  end


  class Level_5 < QuestionBase
    def self.type
      "Level_5"
    end
    def initialize
      # @prod=rand(6)
      @a = rand(15)+1
      @c = rand(15)+1
      @k = rand(10)+1
      @l = rand(10)+1
      @m = rand(10)+1
      @n = rand(5)+1
      @o = 1
      if @l<@m
        @o = @m
      else
        @o = @l
      end
        
      @b = @k*@l
      @d = @k*@m
      @e = rand(5)+1
      @f = @n*@o
      if(@a*@d)-(@b*@c)===0
        @c=rand(10)+1
      end
        
      
      @num1 = -(@a*@d)+(@b*@c)
      @den1 = @b*@d
      @num = @num1*@f
      @den = @den1*@e 
    end
    def solve
      

      hcf=Grade6ops.euclideanalg(@num, @den)
      {"num" => @num/hcf,
        "den" => @den/hcf,
        "a" => @a,
        "b" => @b,
        "c" => @c,
        "d" => @d
      }
    end
    def text
      [TextLabel.new("Find the value of x in lowest fractional form:"), 
        InlineBlock.new(Fraction.new(TextLabel.new(@e), TextLabel.new(@f)),TextLabel.new("X  + "),Fraction.new(TextLabel.new(@a), TextLabel.new(@b)),TextLabel.new(" = "),Fraction.new(TextLabel.new(@c), TextLabel.new(@d))),
          InlineBlock.new(TextLabel.new("Answer:"), Fraction.new("num", "den"))
        ]
    end
  end


  class Level_6 < QuestionBase
    def self.type
      "Level_6"
    end
    def initialize
      # @prod=rand(6)
      @a = rand(15)+1
      @c = rand(15)+1
      @k = rand(10)+1
      @l = rand(10)+1
      @m = rand(10)+1
      @n = rand(5)+1
      @p = rand(6)+1
      @o = 1
      if @l<@m
        @o = @m
      else
        @o = @l
      end
      
      
      @b = @k*@l
      @d = @k*@m
      @e = rand(5)+1
      @f = @n*@o
      
      
      @g = rand(15)+1
      @h = @p*@o

      if(@a*@d)-(@b*@c)===0
        @c=rand(15)+1
      end
        
      if(@e*@h)-(@f*@g)===0
        @g=rand(15)+1
      end
      
      @num1 = -(@a*@d)+(@b*@c)
      @den1 = @b*@d

      @num2 = (@e*@h)-(@f*@g)
      @den2 = @f*@h

      @num =  @num1*@den2
      @den =  @den1*@num2

      if @den < 0 
        @den = (-1)*@den
        @num = (-1)*@num
      end
    end
    def solve
      

      hcf=Grade6ops.euclideanalg(@num, @den)
      {"num" => @num/hcf,
        "den" => @den/hcf,
        "a" => @a,
        "b" => @b,
        "c" => @c,
        "d" => @d
      }
    end
    def text
      [TextLabel.new("Find the value of x in lowest fractional form:"), 
        InlineBlock.new(Fraction.new(TextLabel.new(@e), TextLabel.new(@f)),TextLabel.new("X  + "),Fraction.new(TextLabel.new(@a), TextLabel.new(@b)),TextLabel.new(" = "),Fraction.new(TextLabel.new(@g), TextLabel.new(@h)),TextLabel.new("X  + "),Fraction.new(TextLabel.new(@c), TextLabel.new(@d))),
          InlineBlock.new(TextLabel.new("Answer:"), Fraction.new("num", "den"))
        ]
    end
  end

  PROBLEMS = [
   Anurag::Level_1, 
    Anurag::Level_2,
    Anurag::Level_3,
    Anurag::Level_4,
    Anurag::Level_5,
    Anurag::Level_6] # //Anurag is module name and dummy is class name
end