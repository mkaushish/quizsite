#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml'
require_relative './preg6'
require_relative './c6'
require 'prime'

# TODO override preprocess for the add commas question ( default is now to remove commas )
include ToHTML
include PreG6
include Chapter6

module Algebra
  INDEX = "algebra"
  TITLE = "Algebra 2"
  
  class Createkb < QuestionBase
    def self.type
      "Createkb"
    end
    def initialize
      @a=4
      @b=4
      # @amts=[]
      # for i in 0...@act.length
      #   @amts[i]=(rand(9)+1)*5
      # end
    end
    def solve
      {"ans" => @a}
    end
    def text
      
      [
        # TextLabel.new("Translate the given table into a bar graph taking the scale as 5 students per unit of length"), 
         KeyboardAlg.new("ans",2,3)
       ]
    end
  end

  class Createkb2 < QuestionBase
    def self.type
      "Createkb2"
    end
    def initialize
      @a=[]
      @a[0]=1
      @a[1]=0
      @a[2]=0
      @a[3]=1
      @a[4]=0
      @a[5]=0
      @a[6]=0
      @a[7]=0
    end
    def solve
      {"ans" => @a}
    end
    def text
      
      [
        # TextLabel.new("Translate the given table into a bar graph taking the scale as 5 students per unit of length"), 
         # DrawShape.new("ans",'rectangle3',10,10,200,200,80,150)
        # DrawShape5.new('cube',20,20,0,0,500,500,0,2,500,500,1,1,1),
        DrawShape2.new('cylinder',10,10,20,10,1,'cm',500,500,1,1),

       ]
    end
  end
  
  class Coefficient < QuestionBase
    def self.type
      "Coefficient"
    end

    def initialize(a = nil)
      @a =a.nil? ? rand(100)+1 : a 

    end

    def solve
      {
        "ans1" => @a
      }
      end

      def text
        [
          TextLabel.new("Find the Coefficient of x in"),
          InlineBlock.new(TextLabel.new("(#{@a})x")),TextLabel.new(""),
          InlineBlock.new(TextField.new("ans1"))

        ]

        
      end
    end


  class Add_polynomials < QuestionWithExplanation
    def self.type
      "Add Polynomials"
    end
    def initialize
      
      @a = rand(20)-10
      while @a===0 do
        @a = rand(20)-10
      end
      
      @b = rand(20)-10
      while @b===0 do
        @b = rand(20)-10
      end
      
       @c = rand(20)-10
      while @c===0 do
        @c = rand(20)-10
      end
      
      @d = rand(20)-10
      while @d===0 do
        @d = rand(20)-10
      end

      @e = rand(20)-10
      while @e===0 do
        @e = rand(20)-10
      end

      @f = rand(20)-10
      while @f===0 do
        @f = rand(20)-10
      end
      @g = @a+@d
      @h = @b+@e
      @i = @c+@f
    end

    def solve
     { 
      "ans1" => @a+@d,
      "ans2" => @b+@e,
      "ans3" => @c+@f
      }
    end

    def explain
     
     
     [Subproblem.new([InlineBlock.new(TextLabel.new("First we find the coefficient of "),Exponent.new(TextLabel.new("X"),TextLabel.new("2"))),
      TextLabel.new(""),
     InlineBlock.new(TextLabel.new("The Coefficient of"),Exponent.new(TextLabel.new("X"),TextLabel.new("2")),TextLabel.new("in the first polynomial is #{@a}")),
     TextLabel.new(""),
     InlineBlock.new(TextLabel.new("The Coefficient of"),Exponent.new(TextLabel.new("X"),TextLabel.new("2")),TextLabel.new("in the second polynomial is #{@d}")),
     TextLabel.new(""),
     InlineBlock.new(TextLabel.new(" Therefore the Coefficient of"),Exponent.new(TextLabel.new("X"),TextLabel.new("2")),TextLabel.new("in the sum of the two polynomial is "))
     ]),

      PreG6::Addition.new([@a, @d]),
     
     Subproblem.new([InlineBlock.new(TextLabel.new("Now we find the coefficient of x")),
      TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The Coefficient of x in the first polynomial is #{@b}")]),
     TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The Coefficient of x in the second polynomial is #{@e}")]),
     TextLabel.new(""),
     InlineBlock.new([InlineBlock.new(TextLabel.new(" Therefore the Coefficient of x"),TextLabel.new("in the sum of the two polynomial is "))])
     ]),
     PreG6::Addition.new([@b, @e]),

     Subproblem.new([InlineBlock.new(TextLabel.new("Now we find the constant term")),
      TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The constant in the first polynomial is #{@c}")]),
     TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The constant in the second polynomial is #{@f}")]),
     TextLabel.new(""),
     InlineBlock.new([InlineBlock.new(TextLabel.new(" Therefore the constant term "),TextLabel.new("in the sum of the two polynomial is "))])
     ]),

     PreG6::Addition.new([@c, @f]),

     Subproblem.new([InlineBlock.new(TextLabel.new("Therefore the final answer is")),TextLabel.new(""),
     InlineBlock.new(TextLabel.new("Answer:"), TextLabel.new("#{@g}"),Exponent.new(TextLabel.new("X"),TextLabel.new("2")),TextLabel.new("+"),TextLabel.new("#{@h}"),TextLabel.new("X +"),TextLabel.new("#{@i}"))
      ])


   ]
    end
    def text
      [TextLabel.new("Add the two polynomials "), 

        InlineBlock.new(TextLabel.new("(#{@a})"),Exponent.new(TextLabel.new("X"),TextLabel.new("2")),TextLabel.new(" + (#{@b})X + (#{@c}) ")),TextLabel.new(""),
        InlineBlock.new(TextLabel.new("(#{@d})"),Exponent.new(TextLabel.new("X"),TextLabel.new("2")),TextLabel.new(" + (#{@e})X + (#{@f}) ")),TextLabel.new(""),
       InlineBlock.new(TextLabel.new("Answer:"), TextField.new("ans1"),Exponent.new(TextLabel.new("X"),TextLabel.new("2")),TextLabel.new("+"),TextField.new("ans2"),TextLabel.new("X +"),TextField.new("ans3"))
      ]
    end
  end

  


  class Add_polynomials2 < QuestionWithExplanation
    def self.type
      "Add Polynomials 2"
    end
    def initialize
      
      @a = rand(20)-10
      while @a===0 do
        @a = rand(20)-10
      end
      
      @b = rand(20)-10
      while @b===0 do
        @b = rand(20)-10
      end
      
       @c = rand(20)-10
      while @c===0 do
        @c = rand(20)-10
      end
      
      @d = rand(20)-10
      while @d===0 do
        @d = rand(20)-10
      end

      @e = rand(20)-10
      while @e===0 do
        @e = rand(20)-10
      end

      @f = rand(20)-10
      while @f===0 do
        @f = rand(20)-10
      end

      @g = rand(20)-10
      while @g===0 do
        @g = rand(20)-10
      end

      @h = rand(20)-10
      while @h===0 do
        @h = rand(20)-10
      end

      @i = rand(20)-10
      while @i===0 do
        @i = rand(20)-10
      end
      @j = @a+@d+@g
      @k = @b+@e+@h
      @l = @c+@f+@i
    end
     
    def solve
     { 
      "ans1" => @a+@d+@g,
      "ans2" => @b+@e+@h,
      "ans3" => @c+@f+@i
      }
    end
    def explain
     
     
     [Subproblem.new([InlineBlock.new(TextLabel.new("First we find the coefficient of XY")),
      TextLabel.new(""),
     InlineBlock.new(TextLabel.new("The Coefficient of XY in the first polynomial is #{@a}")),
     TextLabel.new(""),
     InlineBlock.new(TextLabel.new("The Coefficient of XY in the second polynomial is #{@d}")),
     TextLabel.new(""),
     InlineBlock.new(TextLabel.new("The Coefficient of XY in the third polynomial is #{@g}")),
     TextLabel.new(""),
     InlineBlock.new(TextLabel.new(" Therefore the Coefficient of XY in the sum of the three polynomial is "))
     ]),

      PreG6::Addition.new([@a, @d, @g]),
     
     Subproblem.new([InlineBlock.new(TextLabel.new("Now we find the coefficient of YZ")),
      TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The Coefficient of YZ in the first polynomial is #{@b}")]),
     TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The Coefficient of YZ in the second polynomial is #{@e}")]),
     TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The Coefficient of YZ in the third polynomial is #{@h}")]),
     TextLabel.new(""),
     InlineBlock.new([InlineBlock.new(TextLabel.new(" Therefore the Coefficient of YZ in the sum of the three polynomial is "))])
     ]),
     PreG6::Addition.new([@b, @e, @h]),

     Subproblem.new([InlineBlock.new(TextLabel.new("Now we find the coefficient of ZX")),
      TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The Coefficient of ZX in the first polynomial is #{@c}")]),
     TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The Coefficient of ZX in the second polynomial is #{@f}")]),
     TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The Coefficient of ZX in the third polynomial is #{@i}")]),
     TextLabel.new(""),
     InlineBlock.new([InlineBlock.new(TextLabel.new(" Therefore the Coefficient of ZX in the sum of the three polynomial is "))])
     ]),
     PreG6::Addition.new([@c, @f, @i]),

     

     Subproblem.new([InlineBlock.new(TextLabel.new("Therefore the final answer is")),TextLabel.new(""),
     InlineBlock.new(TextLabel.new("Answer:"), TextLabel.new("#{@j}"),TextLabel.new("XY"),TextLabel.new("+"),TextLabel.new("#{@k}"),TextLabel.new("YZ"),TextLabel.new("#{@l}"),TextLabel.new("ZX"))
      ])


   ]
    end

    def text
      [TextLabel.new("Add the two polynomials "), 
        InlineBlock.new(TextLabel.new("(#{@a})XY + (#{@b})YZ + (#{@c})ZX ")),TextLabel.new(""),
        InlineBlock.new(TextLabel.new("(#{@d})XY + (#{@e})YZ + (#{@f})ZX ")),TextLabel.new(""),
        InlineBlock.new(TextLabel.new("(#{@g})XY + (#{@h})YZ + (#{@i})ZX ")),TextLabel.new(""),
       InlineBlock.new(TextLabel.new("Answer:"), TextField.new("ans1"),TextLabel.new("XY + "),TextField.new("ans2"),TextLabel.new("YZ +"),TextField.new("ans3"),TextLabel.new("ZX"))
      ]
    end
  end

  class Sub_polynomials < QuestionWithExplanation
    def self.type
      "Subtract Polynomials"
    end
    def initialize
      
      @a = rand(20)-10
      while @a===0 do
        @a = rand(20)-10
      end
      
      @b = rand(20)-10
      while @b===0 do
        @b = rand(20)-10
      end
      
       @c = rand(20)-10
      while @c===0 do
        @c = rand(20)-10
      end
      
      @d = rand(20)-10
      while @d===0 do
        @d = rand(20)-10
      end

      @e = rand(20)-10
      while @e===0 do
        @e = rand(20)-10
      end

      @f = rand(20)-10
      while @f===0 do
        @f = rand(20)-10
      end
      @g = @a-@d
      @h = @b-@e
      @i = @c-@f
    end
      
    def solve
     { 
      "ans1" => @a-@d,
      "ans2" => @b-@e,
      "ans3" => @c-@f
      }
    end

    def explain
     
     
     [
      Subproblem.new([InlineBlock.new(TextLabel.new("First we find the coefficient of "),Exponent.new(TextLabel.new("X"),TextLabel.new("2"))),
      TextLabel.new(""),
     InlineBlock.new(TextLabel.new("The Coefficient of"),Exponent.new(TextLabel.new("X"),TextLabel.new("2")),TextLabel.new("in the first polynomial is #{@a}")),
     TextLabel.new(""),
     InlineBlock.new(TextLabel.new("The Coefficient of"),Exponent.new(TextLabel.new("X"),TextLabel.new("2")),TextLabel.new("in the second polynomial is #{@d}")),
     TextLabel.new(""),
     InlineBlock.new(TextLabel.new(" Therefore the Coefficient of"),Exponent.new(TextLabel.new("X"),TextLabel.new("2")),TextLabel.new("in the difference of the two polynomial is "))
     ]),

      Chapter6::SubtractIntegers.new(@a, @d),
     
     Subproblem.new([InlineBlock.new(TextLabel.new("Now we find the coefficient of x")),
      TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The Coefficient of x in the first polynomial is #{@b}")]),
     TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The Coefficient of x in the second polynomial is #{@e}")]),
     TextLabel.new(""),
     InlineBlock.new([InlineBlock.new(TextLabel.new(" Therefore the Coefficient of x"),TextLabel.new("in the sum of the two polynomial is "))])
     ]),
     Chapter6::SubtractIntegers.new(@b, @e),

     Subproblem.new([InlineBlock.new(TextLabel.new("Now we find the constant term")),
      TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The constant in the first polynomial is #{@c}")]),
     TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The constant in the second polynomial is #{@f}")]),
     TextLabel.new(""),
     InlineBlock.new([InlineBlock.new(TextLabel.new(" Therefore the constant term "),TextLabel.new("in the sum of the two polynomial is "))])
     ]),

     Chapter6::SubtractIntegers.new(@c, @f),

     Subproblem.new([InlineBlock.new(TextLabel.new("Therefore the final answer is")),TextLabel.new(""),
     InlineBlock.new(TextLabel.new("Answer:"), TextLabel.new("#{@g}"),Exponent.new(TextLabel.new("X"),TextLabel.new("2")),TextLabel.new("+"),TextLabel.new("#{@h}"),TextLabel.new("X +"),TextLabel.new("#{@i}"))
      ])
      ]
    end

    def text
      [TextLabel.new("Subtract second polynomial from the first "), 
        InlineBlock.new(TextLabel.new("(#{@a})"),Exponent.new(TextLabel.new("X"),TextLabel.new("2")),TextLabel.new(" + (#{@b})X + (#{@c}) ")),TextLabel.new(""),
        InlineBlock.new(TextLabel.new("(#{@d})"),Exponent.new(TextLabel.new("X"),TextLabel.new("2")),TextLabel.new(" + (#{@e})X + (#{@f}) ")),TextLabel.new(""),
       InlineBlock.new(TextLabel.new("Answer:"), TextField.new("ans1"),Exponent.new(TextLabel.new("X"),TextLabel.new("2")),TextLabel.new("+"),TextField.new("ans2"),TextLabel.new("X +"),TextField.new("ans3"))
      ]
    end
  end


class Sub_polynomials2 < QuestionWithExplanation
    def self.type
      "Subtract Polynomials 2"
    end
    def initialize
      
      @a = rand(20)-10
      while @a===0 do
        @a = rand(20)-10
      end
      
      @b = rand(20)-10
      while @b===0 do
        @b = rand(20)-10
      end
      
       @c = rand(20)-10
      while @c===0 do
        @c = rand(20)-10
      end
      
      @d = rand(20)-10
      while @d===0 do
        @d = rand(20)-10
      end

      @e = rand(20)-10
      while @e===0 do
        @e = rand(20)-10
      end

      @f = rand(20)-10
      while @f===0 do
        @f = rand(20)-10
      end

      @g = rand(20)-10
      while @g===0 do
        @g = rand(20)-10
      end

      @h = rand(20)-10
      while @h===0 do
        @h = rand(20)-10
      end

      @i = rand(20)-10
      while @i===0 do
        @i = rand(20)-10
      end

      @j = rand(20)-10
      while @j===0 do
        @j = rand(20)-10
      end

      @k = rand(20)-10
      while @k===0 do
        @k = rand(20)-10
      end

      @l = rand(20)-10
      while @l===0 do
        @l = rand(20)-10
      end

      @m = @a-@g
      @n = @b-@h
      @o = @c-@i
      @p = @d-@j
      @q = @e-@k
      @r = @f-@l
    end
      
    def solve
     { 
      "ans1" => @a-@g,
      "ans2" => @b-@h,
      "ans3" => @c-@i,
      "ans4" => @d-@j,
      "ans5" => @e-@k,
      "ans6" => @f-@l
      }
    end

    def explain
     
     
     [
      Subproblem.new([InlineBlock.new(TextLabel.new("First we find the coefficient of "),Exponent.new(TextLabel.new("X"),TextLabel.new("2"))),
      TextLabel.new(""),
     InlineBlock.new(TextLabel.new("The Coefficient of"),Exponent.new(TextLabel.new("X"),TextLabel.new("2")),TextLabel.new("in the first polynomial is #{@a}")),
     TextLabel.new(""),
     InlineBlock.new(TextLabel.new("The Coefficient of"),Exponent.new(TextLabel.new("X"),TextLabel.new("2")),TextLabel.new("in the second polynomial is #{@g}")),
     TextLabel.new(""),
     InlineBlock.new(TextLabel.new(" Therefore the Coefficient of"),Exponent.new(TextLabel.new("X"),TextLabel.new("2")),TextLabel.new("in the difference of the two polynomial is "))
     ]),

      Chapter6::SubtractIntegers.new(@a, @g),
     
     Subproblem.new([InlineBlock.new(TextLabel.new("Now we find the coefficient of x")),
      TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The Coefficient of x in the first polynomial is #{@b}")]),
     TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The Coefficient of x in the second polynomial is #{@h}")]),
     TextLabel.new(""),
     InlineBlock.new([InlineBlock.new(TextLabel.new(" Therefore the Coefficient of x"),TextLabel.new("in the sum of the two polynomial is "))])
     ]),
     Chapter6::SubtractIntegers.new(@b, @h),

     Subproblem.new([InlineBlock.new(TextLabel.new("Now we find the coefficient of "),Exponent.new(TextLabel.new("Y"),TextLabel.new("2"))),
      TextLabel.new(""),
     InlineBlock.new(TextLabel.new("The Coefficient of"),Exponent.new(TextLabel.new("Y"),TextLabel.new("2")),TextLabel.new("in the first polynomial is #{@c}")),
     TextLabel.new(""),
     InlineBlock.new(TextLabel.new("The Coefficient of"),Exponent.new(TextLabel.new("Y"),TextLabel.new("2")),TextLabel.new("in the second polynomial is #{@i}")),
     TextLabel.new(""),
     InlineBlock.new(TextLabel.new(" Therefore the Coefficient of"),Exponent.new(TextLabel.new("Y"),TextLabel.new("2")),TextLabel.new("in the difference of the two polynomial is "))
     ]),

      Chapter6::SubtractIntegers.new(@c, @i),
     
     Subproblem.new([InlineBlock.new(TextLabel.new("Now we find the coefficient of Y")),
      TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The Coefficient of Y in the first polynomial is #{@d}")]),
     TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The Coefficient of Y in the second polynomial is #{@j}")]),
     TextLabel.new(""),
     InlineBlock.new([InlineBlock.new(TextLabel.new(" Therefore the Coefficient of Y"),TextLabel.new("in the sum of the two polynomial is "))])
     ]),
     Chapter6::SubtractIntegers.new(@d, @j),

     Subproblem.new([InlineBlock.new(TextLabel.new("Now we find the coefficient of XY")),
      TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The Coefficient of XY in the first polynomial is #{@e}")]),
     TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The Coefficient of XY in the second polynomial is #{@k}")]),
     TextLabel.new(""),
     InlineBlock.new([InlineBlock.new(TextLabel.new(" Therefore the Coefficient of XY"),TextLabel.new("in the sum of the two polynomial is "))])
     ]),
     Chapter6::SubtractIntegers.new(@e, @k),

     Subproblem.new([InlineBlock.new(TextLabel.new("Now we find the constant term")),
      TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The constant in the first polynomial is #{@f}")]),
     TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The constant in the second polynomial is #{@l}")]),
     TextLabel.new(""),
     InlineBlock.new([InlineBlock.new(TextLabel.new(" Therefore the constant term "),TextLabel.new("in the sum of the two polynomial is "))])
     ]),

     Chapter6::SubtractIntegers.new(@f, @l),

     Subproblem.new([InlineBlock.new(TextLabel.new("Therefore the final answer is")),TextLabel.new(""),
     InlineBlock.new(TextLabel.new("Answer:"), TextLabel.new("(#{@m})"),Exponent.new(TextLabel.new("X"),TextLabel.new("2")),TextLabel.new("+"),TextLabel.new("(#{@n})"),TextLabel.new("X +"),TextLabel.new("(#{@o})"),Exponent.new(TextLabel.new("Y"),TextLabel.new("2")),TextLabel.new("+"),TextLabel.new("(#{@p})"),TextLabel.new("Y +"),TextLabel.new("(#{@q})XY + (#{@r})"))
      ])
      ]
    end

    def text
      [TextLabel.new("Subtract second polynomial from the first "), 
        InlineBlock.new(TextLabel.new("(#{@a})"),Exponent.new(TextLabel.new("X"),TextLabel.new("2")),TextLabel.new(" + (#{@b})X + (#{@c})"),Exponent.new(TextLabel.new("Y"),TextLabel.new("2")),TextLabel.new(" + (#{@d})Y + (#{@e})XY + (#{@f})"),),TextLabel.new(""),
        InlineBlock.new(TextLabel.new("(#{@g})"),Exponent.new(TextLabel.new("X"),TextLabel.new("2")),TextLabel.new(" + (#{@h})X + (#{@i})"),Exponent.new(TextLabel.new("Y"),TextLabel.new("2")),TextLabel.new(" + (#{@j})Y + (#{@k})XY + (#{@l})"),),TextLabel.new(""),
       InlineBlock.new(TextLabel.new("Answer:"), TextField.new("ans1"),Exponent.new(TextLabel.new("X"),TextLabel.new("2")),TextLabel.new("+"),TextField.new("ans2"),TextLabel.new("X +"),TextField.new("ans3"),Exponent.new(TextLabel.new("Y"),TextLabel.new("2")),TextField.new("ans4"),TextLabel.new("Y +"),TextField.new("ans5"),TextLabel.new("XY +"),TextField.new("ans6"))
      ]
    end
  end

  class Mul_monomials < QuestionWithExplanation
    def self.type
      "Multiply Monomials"
    end
    def initialize
      
      @a = rand(20)-10
      while @a===0 do
        @a = rand(20)-10
      end
      
      @b = rand(20)-10
      while @b===0 do
        @b = rand(20)-10
      end
      
       @c = rand(20)-10
      while @c===0 do
        @c = rand(20)-10
      end
      
      @d = rand(20)-10
      while @d===0 do
        @d = rand(20)-10
      end

      @e = rand(20)-10
      while @e===0 do
        @e = rand(20)-10
      end

      @f = rand(20)-10
      while @f===0 do
        @f = rand(20)-10
      end

      @g = rand(20)-10
      while @g===0 do
        @g = rand(20)-10
      end

      @h = rand(20)-10
      while @h===0 do
        @h = rand(20)-10
      end

      @i = rand(20)-10
      while @i===0 do
        @i = rand(20)-10
      end

      @j = rand(20)-10
      while @j===0 do
        @j = rand(20)-10
      end

      @k = rand(20)-10
      while @k===0 do
        @k = rand(20)-10
      end

      @l = rand(20)-10
      while @l===0 do
        @l = rand(20)-10
      end
    
      @m  = @a*@b*@c
      @n  = @d+@g+@j
      @o = @e+@h+@k
      @p = @f+@i+@l
    end
    def solve
     { 
      "ans1" => @a*@b*@c,
      "ans2" => @d+@g+@j,
      "ans3" => @e+@h+@k,
      "ans4" => @f+@i+@l
      }
    end

    def explain
     
     
     [Subproblem.new([InlineBlock.new(TextLabel.new("First we find the Exponent of x")),
      TextLabel.new(""),
     InlineBlock.new(TextLabel.new("The Exponent of X in the first monomial is #{@d}")),
     TextLabel.new(""),
     InlineBlock.new(TextLabel.new("The Exponent of X in the second monomial is #{@g}")),
     TextLabel.new(""),
     InlineBlock.new(TextLabel.new("The Exponent of X in the third monomial is #{@j}")),
     TextLabel.new(""),
     InlineBlock.new(TextLabel.new(" Therefore the Exponent of X in the product of the three monomials is "))
     ]),

      PreG6::Addition.new([@d, @g, @j]),
     
     Subproblem.new([InlineBlock.new(TextLabel.new("Now we find the Exponent of Y")),
      TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The Exponent of Y in the first monomial is #{@e}")]),
     TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The Exponent of Y in the second monomial is #{@h}")]),
     TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The Exponent of Y in the third monomial is #{@k}")]),
     TextLabel.new(""),
     InlineBlock.new([InlineBlock.new(TextLabel.new(" Therefore the Exponent of Y in the product of the three monomials is "))])
     ]),
     PreG6::Addition.new([@e, @h, @k]),

     Subproblem.new([InlineBlock.new(TextLabel.new("Now we find the Exponent of Z")),
      TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The Exponent of Z in the first monomial is #{@f}")]),
     TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The Exponent of Z in the second monomial is #{@i}")]),
     TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The Exponent of Z in the third monomial is #{@l}")]),
     TextLabel.new(""),
     InlineBlock.new([InlineBlock.new(TextLabel.new(" Therefore the Exponent of Z in the product of the three monomials is "))])
     ]),
     PreG6::Addition.new([@f, @i, @l]),

     Subproblem.new([InlineBlock.new(TextLabel.new("Now we find the Coefficient")),
      TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The Coefficient  in the first monomial is #{@f}")]),
     TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The Coefficient  in the second monomial is #{@i}")]),
     TextLabel.new(""),
     InlineBlock.new([TextLabel.new("The Coefficient  in the third monomial is #{@l}")]),
     TextLabel.new(""),
     InlineBlock.new([InlineBlock.new(TextLabel.new(" Therefore the Coefficient  in the product of the three monomials is "))])
     ]),
     PreG6::Multiplication2.new([@a, @b, @c]),

     Subproblem.new([InlineBlock.new(TextLabel.new("Therefore the final answer is")),TextLabel.new(""),
     InlineBlock.new(TextLabel.new("Answer:"), TextLabel.new("#{@m}"),Exponent.new(TextLabel.new("X"),@n),Exponent.new(TextLabel.new("Y"),@o),Exponent.new(TextLabel.new("Z"),@p))
      ])


   ]
    end
    def text
      [TextLabel.new("Multiply the given polynomial "), 
        InlineBlock.new(TextLabel.new("(#{@a}"),Exponent.new(TextLabel.new("x"),@d),Exponent.new(TextLabel.new("y"),@e),Exponent.new(TextLabel.new("z"),@f),TextLabel.new(")"),TextLabel.new("(#{@b}"),Exponent.new(TextLabel.new("x"),@g),Exponent.new(TextLabel.new("y"),@h),Exponent.new(TextLabel.new("z"),@i),TextLabel.new(")"),TextLabel.new("(#{@c}"),Exponent.new(TextLabel.new("x"),@j),Exponent.new(TextLabel.new("y"),@k),Exponent.new(TextLabel.new("z"),@l),TextLabel.new(")")),TextLabel.new(""),
        InlineBlock.new(TextLabel.new("Answer:"), TextField.new("ans1"),Exponent.new(TextLabel.new("x"),TextField.new("ans2")),Exponent.new(TextLabel.new("y"),TextField.new("ans3")),Exponent.new(TextLabel.new("z"),TextField.new("ans4")))
      ]
    end
  end




  class Mul_mono_bi < QuestionWithExplanation
    def self.type
      "Multiply Monomial & Binomial"
    end
    def initialize
      
      @a = rand(20)-10
      while @a===0 do
        @a = rand(20)-10
      end
      
      @b = rand(20)-10
      while @b===0 do
        @b = rand(20)-10
      end
      
       @c = rand(20)-10
      while @c===0 do
        @c = rand(20)-10
      end
      
      @d = rand(20)-10
      while @d===0 do
        @d = rand(20)-10
      end

      @e = rand(20)-10
      while @e===0 do
        @e = rand(20)-10
      end

      @f = rand(20)-10
      while @f===0 do
        @f = rand(20)-10
      end

      @g = rand(20)-10
      while @g===0 do
        @g = rand(20)-10
      end

      @h = rand(20)-10
      while @h===0 do
        @h = rand(20)-10
      end

      @i = rand(20)-10
      while @i===0 do
        @i = rand(20)-10
      end

      @j = rand(20)-10
      while @j===0 do
        @j = rand(20)-10
      end

      @k = rand(20)-10
      while @k===0 do
        @k = rand(20)-10
      end

      @l = rand(20)-10
      while @l===0 do
        @l = rand(20)-10
      end

      @choose = rand(3)

    
      @m = @a*@b
      @n = @a*@c
      @o = @d+@e
      @p = @d+@g
      @q = @f+@i
      @r = @h+@i
    end
    def solve
      if @choose === 0
     { 
      "ans1" => @a*@b,
      "ans2" => @a*@c,
      
      }
    elsif @choose ===1
      {
        "ans1" => @a*@b,
      "ans2" => @a*@c,
      "ans3" => @d+@e,
      "ans4" => @d+@g,
      "ans5" => @f,
      "ans6" => @h

      }
    elsif @choose ===2
      
      {
        "ans1" => @a*@b,
      "ans2" => @a*@c,
      "ans3" => @d+@e,
      "ans4" => @d+@g,
      "ans5" => @f+@i,
      "ans6" => @h+@i

      }

    end

    end
    def explain
      if @choose===0
        [
          Subproblem.new([InlineBlock.new(TextLabel.new(" The coefficient of "),Exponent.new(TextLabel.new("x"),@d),TextLabel.new("y is")),TextLabel.new("")]),
          PreG6::Multiplication2.new([@a, @b]),
          Subproblem.new([InlineBlock.new(TextLabel.new(" The coefficient of "),Exponent.new(TextLabel.new("x"),@d),TextLabel.new(" is")),TextLabel.new("")]),
          PreG6::Multiplication2.new([@a, @c]),

          Subproblem.new([InlineBlock.new(TextLabel.new("Therefore the final answer is")),TextLabel.new(""),
          InlineBlock.new(TextLabel.new("Answer:"), TextLabel.new("#{@m}"),Exponent.new(TextLabel.new("X"),@d),TextLabel.new("y +"),TextLabel.new("#{@n}"),Exponent.new(TextLabel.new("X"),@d))
          ])
        ]
      elsif @choose===1
        [
          Subproblem.new([InlineBlock.new(TextLabel.new(" The coefficient of "),Exponent.new(TextLabel.new("x"),@o),Exponent.new(TextLabel.new("y"),@f)),TextLabel.new("")]),
          PreG6::Multiplication2.new([@a, @b]),
          Subproblem.new([InlineBlock.new(TextLabel.new(" The coefficient of "),Exponent.new(TextLabel.new("x"),@p),Exponent.new(TextLabel.new("y"),@h),TextLabel.new(" is")),TextLabel.new("")]),
          PreG6::Multiplication2.new([@a, @c]),

          Subproblem.new([InlineBlock.new(TextLabel.new("Therefore the final answer is")),TextLabel.new(""),
          InlineBlock.new(TextLabel.new("Answer:"), TextLabel.new("#{@m}"),Exponent.new(TextLabel.new("x"),@o),Exponent.new(TextLabel.new("y"),@f),TextLabel.new(" +"),TextLabel.new("#{@n}"),Exponent.new(TextLabel.new("x"),@p),Exponent.new(TextLabel.new("y"),@h))
          ])
        ]
      elsif @choose===2
        [
          Subproblem.new([InlineBlock.new(TextLabel.new(" The coefficient of "),Exponent.new(TextLabel.new("x"),@o),Exponent.new(TextLabel.new("y"),@q))]),
          PreG6::Multiplication2.new([@a, @b]),
          Subproblem.new([InlineBlock.new(TextLabel.new(" The coefficient of "),Exponent.new(TextLabel.new("x"),@p),Exponent.new(TextLabel.new("y"),@r),TextLabel.new(" is")),TextLabel.new("")]),
          PreG6::Multiplication2.new([@a, @c]),

          Subproblem.new([InlineBlock.new(TextLabel.new("Therefore the final answer is")),TextLabel.new(""),
          InlineBlock.new(TextLabel.new("Answer:"), TextLabel.new("#{@m}"),Exponent.new(TextLabel.new("x"),@o),Exponent.new(TextLabel.new("y"),@q),TextLabel.new(" +"),TextLabel.new("#{@n}"),Exponent.new(TextLabel.new("x"),@p),Exponent.new(TextLabel.new("y"),@r))
          ])
        ]
      end
          
          
    end
    def text
      if @choose===0
      [TextLabel.new("Multiply "), 
        InlineBlock.new(TextLabel.new("#{@a}"),Exponent.new(TextLabel.new("x"),@d),TextLabel.new("(#{@b}y + #{@c})")),TextLabel.new(""),
        InlineBlock.new(TextLabel.new("Answer:  ("), TextField.new("ans1"),Exponent.new(TextLabel.new("x"),@d),TextLabel.new("y) + ("),TextField.new("ans2"),Exponent.new(TextLabel.new("x"),@d),TextLabel.new(")"))
      ]
     elsif @choose===1
      [TextLabel.new("Multiply "), 
        InlineBlock.new(TextLabel.new("#{@a}"),Exponent.new(TextLabel.new("x"),@d),TextLabel.new("(#{@b}"),Exponent.new(TextLabel.new("x"),@e),Exponent.new(TextLabel.new("y"),@f),TextLabel.new(" +  #{@c}"),Exponent.new(TextLabel.new("x"),@g),Exponent.new(TextLabel.new("y"),@h),TextLabel.new(")")),TextLabel.new(""),
        InlineBlock.new(TextLabel.new("Answer:"),TextLabel.new("("), TextField.new("ans1"),Exponent.new(TextLabel.new("x"),TextField.new("ans3")),Exponent.new(TextLabel.new("y"),TextField.new("ans5")),TextLabel.new(") +  ("),TextField.new("ans2"),Exponent.new(TextLabel.new("x"),TextField.new("ans4")),Exponent.new(TextLabel.new("y"),TextField.new("ans6")),TextLabel.new(")"))
      ]
      elsif @choose===2
      
      [TextLabel.new("Multiply "), 
        InlineBlock.new(TextLabel.new("#{@a}"),Exponent.new(TextLabel.new("x"),@d),Exponent.new(TextLabel.new("y"),@i),TextLabel.new("(#{@b}"),Exponent.new(TextLabel.new("x"),@e),Exponent.new(TextLabel.new("y"),@f),TextLabel.new(" +  #{@c}"),Exponent.new(TextLabel.new("x"),@g),Exponent.new(TextLabel.new("y"),@h),TextLabel.new(")")),TextLabel.new(""),
        InlineBlock.new(TextLabel.new("Answer:"),TextLabel.new("("), TextField.new("ans1"),Exponent.new(TextLabel.new("x"),TextField.new("ans3")),Exponent.new(TextLabel.new("y"),TextField.new("ans5")),TextLabel.new(") +  ("),TextField.new("ans2"),Exponent.new(TextLabel.new("x"),TextField.new("ans4")),Exponent.new(TextLabel.new("y"),TextField.new("ans6")),TextLabel.new(")"))
      ]
     end  
          
    end
  end

  class Mul_mono_tri < QuestionWithExplanation
    def self.type
      "Multiply Monomial with Trinomial"
    end
    def initialize
      
      @a = rand(20)-10
      while @a===0 do
        @a = rand(20)-10
      end
      
      @b = rand(20)-10
      while @b===0 do
        @b = rand(20)-10
      end
      
       @c = rand(20)-10
      while @c===0 do
        @c = rand(20)-10
      end
      
      @d = rand(20)-10
      while @d===0 do
        @d = rand(20)-10
      end

      @e = rand(20)-10
      while @e===0 do
        @e = rand(20)-10
      end

      @f = rand(20)-10
      while @f===0 do
        @f = rand(20)-10
      end

      @g = rand(20)-10
      while @g===0 do
        @g = rand(20)-10
      end

      @h = rand(20)-10
      while @h===0 do
        @h = rand(20)-10
      end

      @i = rand(20)-10
      while @i===0 do
        @i = rand(20)-10
      end

      @j = rand(20)-10
      while @j===0 do
        @j = rand(20)-10
      end

      @k = rand(20)-10
      while @k===0 do
        @k = rand(20)-10
      end

      @l = rand(20)-10
      while @l===0 do
        @l = rand(20)-10
      end

      @m = @e+2
      @n = @e+1
      @o = @a*@b
      @p = @a*@c
      @q = @a*@d
    end
    def solve
      
      {
        "ans1" =>@a*@b,
        "ans2" =>@a*@c,
        "ans3" =>@a*@d,
        "ans4" =>@e+2,
        "ans5" =>@e+1,
        "ans6" =>@e
      }
    end

    def explain
      [
          Subproblem.new([InlineBlock.new(TextLabel.new(" The coefficient of "),Exponent.new(TextLabel.new("y"),@m),TextLabel.new("y is")),TextLabel.new("")]),
          PreG6::Multiplication2.new([@a, @b]),
          Subproblem.new([InlineBlock.new(TextLabel.new(" The coefficient of "),Exponent.new(TextLabel.new("y"),@n),TextLabel.new(" is")),TextLabel.new("")]),
          PreG6::Multiplication2.new([@a, @c]),
          Subproblem.new([InlineBlock.new(TextLabel.new(" The coefficient of "),Exponent.new(TextLabel.new("y"),@e),TextLabel.new("y is")),TextLabel.new("")]),
          PreG6::Multiplication2.new([@a, @d]),

          Subproblem.new([InlineBlock.new(TextLabel.new("Therefore the final answer is")),TextLabel.new(""),
          InlineBlock.new(TextLabel.new("Answer:"), TextLabel.new("(#{@o})"),Exponent.new(TextLabel.new("y"),@m),TextLabel.new(" +"),TextLabel.new("(#{@p})"),Exponent.new(TextLabel.new("y"),@n),TextLabel.new("(#{@q})"),Exponent.new(TextLabel.new("y"),@e))
          ])
        ]
    end

    def text
      [
        TextLabel.new("Multiply "), 
        InlineBlock.new(TextLabel.new("#{@a}"),Exponent.new(TextLabel.new("y"),@e),TextLabel.new("(#{@b}"),Exponent.new(TextLabel.new("y"),TextLabel.new("2")),TextLabel.new("+ #{@c}y + "),TextLabel.new("#{@d})")),TextLabel.new(""),
        InlineBlock.new(TextLabel.new("Answer:"), TextField.new("ans1"),Exponent.new(TextLabel.new("y"),TextField.new("ans4")),TextLabel.new(" + "),TextField.new("ans2"),Exponent.new(TextLabel.new("y"),TextField.new("ans5")),TextLabel.new(" + "),TextField.new("ans3"),Exponent.new(TextLabel.new("y"),TextField.new("ans6")),TextLabel.new(""))
     

      ]
        
    end
  end

  class Mul_bi_bi < QuestionWithExplanation
    def self.type
      "Multiply Binomials"
    end
    def initialize
      
      @a = rand(20)-10
      while @a===0 do
        @a = rand(20)-10
      end
      
      @b = rand(20)-10
      while @b===0 do
        @b = rand(20)-10
      end
      
       @c = rand(20)-10
      while @c===0 do
        @c = rand(20)-10
      end
      
      @d = rand(20)-10
      while @d===0 do
        @d = rand(20)-10
      end

      @e = rand(10)+2
      @f = rand(10)+2
      @g = rand(10)+2
      @h = rand(10)+2
      @choose = rand(3)
      @i = @a*@c
      @j = (@b*@c)+(@a*@d)
      @k = @b*@d
      @l = @e+@g
      @m = @f+@h
      @n = @b*@c
      @o = @a*@d
    end
    

    def solve
      {
        "ans1" =>@a*@c,
        "ans2" =>(@b*@c)+(@a*@d),
        "ans3" =>@b*@d,
        "ans4" =>@e+@g,
        "ans5" =>@f+@h,
        "ans6" =>@b*@c,
        "ans7" =>@a*@d
      }  
      
    end

    def explain
      if @choose===0
        [
          Subproblem.new([InlineBlock.new(TextLabel.new(" The coefficient of "),Exponent.new(TextLabel.new("x"),TextLabel.new("2")),TextLabel.new(" is")),TextLabel.new("")]),
          PreG6::Multiplication2.new([@a, @c]),
          Subproblem.new([InlineBlock.new(TextLabel.new(" The coefficient of x"),TextLabel.new(" is")),TextLabel.new("")]),
          PreG6::Addition.new([@b*@c, @a*@d]),

          Subproblem.new([InlineBlock.new(TextLabel.new(" The constant term is of ")),TextLabel.new("")]),
          PreG6::Multiplication2.new([@b, @d]),

          Subproblem.new([InlineBlock.new(TextLabel.new("Therefore the final answer is")),TextLabel.new(""),
          InlineBlock.new(TextLabel.new("Answer:"), TextLabel.new("#{@i}"),Exponent.new(TextLabel.new("x"),TextLabel.new("2")),TextLabel.new(" +"),TextLabel.new("(#{@j})"),TextLabel.new("x + "),TextLabel.new("(#{@k})"))
          ])
        ]
      elsif @choose===1
        [
          Subproblem.new([InlineBlock.new(TextLabel.new(" The coefficient of "),Exponent.new(TextLabel.new("x"),TextLabel.new("2")),TextLabel.new("y is")),TextLabel.new("")]),
          PreG6::Multiplication2.new([@a, @c]),
          Subproblem.new([InlineBlock.new(TextLabel.new(" The coefficient of xy"),TextLabel.new(" is")),TextLabel.new("")]),
          PreG6::Addition.new([@b*@c, @a*@d]),

          Subproblem.new([InlineBlock.new(TextLabel.new(" The coefficient of "),Exponent.new(TextLabel.new("y"),TextLabel.new("2"))),TextLabel.new("")]),
          PreG6::Multiplication2.new([@b, @d]),

          Subproblem.new([InlineBlock.new(TextLabel.new("Therefore the final answer is")),TextLabel.new(""),
          InlineBlock.new(TextLabel.new("Answer:"), TextLabel.new("(#{@i})"),Exponent.new(TextLabel.new("x"),TextLabel.new("2")),TextLabel.new(" +"),TextLabel.new("(#{@j})"),TextLabel.new("xy + "),TextLabel.new("(#{@k})"),Exponent.new(TextLabel.new("y"),TextLabel.new("2")))
          ])
        ]
      elsif @choose===2
        [
          Subproblem.new([InlineBlock.new(TextLabel.new(" The coefficient of "),Exponent.new(TextLabel.new("x"),@e+@g),TextLabel.new("y is")),TextLabel.new("")]),
          PreG6::Multiplication2.new([@a, @c]),
          Subproblem.new([InlineBlock.new(TextLabel.new(" The coefficient of "),Exponent.new(TextLabel.new("x"),@g),Exponent.new(TextLabel.new("y"),@f),TextLabel.new(" is")),TextLabel.new("")]),
          PreG6::Multiplication2.new([@b,@c]),
          Subproblem.new([InlineBlock.new(TextLabel.new(" The coefficient of "),Exponent.new(TextLabel.new("x"),@e),Exponent.new(TextLabel.new("y"),@h),TextLabel.new(" is")),TextLabel.new("")]),
          PreG6::Multiplication2.new([@a,@d]),

          Subproblem.new([InlineBlock.new(TextLabel.new(" The coefficient of "),Exponent.new(TextLabel.new("y"),@f+@h)),TextLabel.new("")]),
          PreG6::Multiplication2.new([@b, @d]),

          Subproblem.new([InlineBlock.new(TextLabel.new("Therefore the final answer is")),TextLabel.new(""),
          InlineBlock.new(TextLabel.new("Answer:"), TextLabel.new("(#{@i})"),Exponent.new(TextLabel.new("x"),@e+@g),TextLabel.new(" +"),TextLabel.new("(#{@n})"),Exponent.new(TextLabel.new("x"),@g),Exponent.new(TextLabel.new("y"),@f),TextLabel.new(" + "),TextLabel.new("(#{@o})"),Exponent.new(TextLabel.new("x"),@e),Exponent.new(TextLabel.new("y"),@h),TextLabel.new("(#{@k})"),Exponent.new(TextLabel.new("y"),@f+@h))
          ])
        ]

      end
    end

    def text
      if @choose===0
        [
        TextLabel.new("Multiply "), 
        InlineBlock.new(TextLabel.new("(#{@a}x +"),TextLabel.new("#{@b})"),TextLabel.new("(#{@c}x +"),TextLabel.new("#{@d})")),TextLabel.new(""),
        InlineBlock.new(TextLabel.new("Answer:"), TextField.new("ans1"),Exponent.new(TextLabel.new("x"),TextLabel.new("2")),TextLabel.new(" + "),TextField.new("ans2"),TextLabel.new("x + "),TextField.new("ans3"),TextLabel.new(")"))
        ]
      elsif @choose===1
        [
        TextLabel.new("Multiply "), 
        InlineBlock.new(TextLabel.new("(#{@a}x +"),TextLabel.new("#{@b}y)"),TextLabel.new("(#{@c}x +"),TextLabel.new("#{@d}y)")),TextLabel.new(""),
        InlineBlock.new(TextLabel.new("Answer:"), TextField.new("ans1"),Exponent.new(TextLabel.new("x"),TextLabel.new("2")),TextLabel.new(" + "),TextField.new("ans2"),TextLabel.new("xy + "),TextField.new("ans3"),Exponent.new(TextLabel.new("y"),TextLabel.new("2")),TextLabel.new(")"))
        ]
      elsif @choose===2
        [
        TextLabel.new("Multiply "), 
        InlineBlock.new(TextLabel.new("(#{@a}"),Exponent.new(TextLabel.new("x"),@e),TextLabel.new(" + #{@b}"),Exponent.new(TextLabel.new("y"),@f),TextLabel.new(").(#{@c}"),Exponent.new(TextLabel.new("x"),@g),TextLabel.new(" + #{@d}"),Exponent.new(TextLabel.new("y"),@h),TextLabel.new(")")),TextLabel.new(""),
        InlineBlock.new(TextLabel.new("Answer:"), TextField.new("ans1"),Exponent.new(TextLabel.new("x"),@e+@g),TextLabel.new(" + "),TextField.new("ans6"),Exponent.new(TextLabel.new("x"),@g),Exponent.new(TextLabel.new("y"),@f),TextField.new("ans7"),Exponent.new(TextLabel.new("x"),@e),Exponent.new(TextLabel.new("y"),@h),TextLabel.new(" + "),TextField.new("ans3"),Exponent.new(TextLabel.new("y"),@f+@h),TextLabel.new(""))
        ]
       end
    end
  end


  class Mul_bi_tri < QuestionWithExplanation
    def self.type
      "Multiply Binomial & Trinomial"
    end
    def initialize
      
      @a = rand(20)-10
      while @a===0 do
        @a = rand(20)-10
      end
      
      @b = rand(20)-10
      while @b===0 do
        @b = rand(20)-10
      end
      
       @c = rand(20)-10
      while @c===0 do
        @c = rand(20)-10
      end
      
      @d = rand(20)-10
      while @d===0 do
        @d = rand(20)-10
      end

      @e = rand(10)+2
      @f = rand(10)+2
      @g = rand(10)+2
      @h = rand(10)+2
      @choose = rand(3)
      @i = @a*@c
      @j = (@b*@c)+(@a*@d)
      @k = (@b*@d)+(@a*@e)
      @l = @b*@e
      @m = @b*@d
      @n = @a*@e
    end
    

    def solve
      if @choose===0
        {
         "ans1" =>@a*@c,
          "ans2" =>(@b*@c)+(@a*@d),
          "ans3" =>(@b*@d)+(@a*@e),
          "ans4" =>@b*@e
        }  
      else 
        {
          "ans1" =>@a*@c,
          "ans2" =>@b*@d,
          "ans3" =>(@b*@c)+(@a*@d),
          "ans4" =>@a*@e,
          "ans5" =>@b*@e

        }
      end
      
    end
    def explain
      if @choose===0
       [
          Subproblem.new([InlineBlock.new(TextLabel.new(" The coefficient of "),Exponent.new(TextLabel.new("x"),TextLabel.new("3")),TextLabel.new(" is")),TextLabel.new("")]),
          PreG6::Multiplication2.new([@a, @c]),
          Subproblem.new([InlineBlock.new(TextLabel.new(" The coefficient of "),Exponent.new(TextLabel.new("x"),TextLabel.new("2")),TextLabel.new(" is")),TextLabel.new("")]),
          PreG6::Addition.new([@a*@d, @c*@b]),
          Subproblem.new([InlineBlock.new(TextLabel.new(" The coefficient of x"),TextLabel.new(" is")),TextLabel.new("")]),
          PreG6::Addition.new([@b*@d, @a*@c]),

          Subproblem.new([InlineBlock.new(TextLabel.new(" The constant term is of ")),TextLabel.new("")]),
          PreG6::Multiplication2.new([@b, @e]),

          Subproblem.new([InlineBlock.new(TextLabel.new("Therefore the final answer is")),TextLabel.new(""),
          InlineBlock.new(TextLabel.new("Answer:"), TextLabel.new("#{@i}"),Exponent.new(TextLabel.new("x"),TextLabel.new("3")),TextLabel.new(" +"),TextLabel.new("#{@j}"),Exponent.new(TextLabel.new("x"),TextLabel.new("2")),TextLabel.new(" +"),TextLabel.new("(#{@k})"),TextLabel.new("x + "),TextLabel.new("(#{@l})"))
          ])
        ]
        else
         [
          
          Subproblem.new([InlineBlock.new(TextLabel.new(" The coefficient of "),Exponent.new(TextLabel.new("a"),TextLabel.new("2")),TextLabel.new(" is")),TextLabel.new("")]),
          PreG6::Multiplication2.new([@a, @c]),
          
          Subproblem.new([InlineBlock.new(TextLabel.new(" The coefficient of "),Exponent.new(TextLabel.new("b"),TextLabel.new("2")),TextLabel.new(" is")),TextLabel.new("")]),
          PreG6::Multiplication2.new([@d, @b]),
          Subproblem.new([InlineBlock.new(TextLabel.new(" The coefficient of ab"),TextLabel.new(" is")),TextLabel.new("")]),
          PreG6::Addition.new([@b*@c, @a*@d]),
          Subproblem.new([InlineBlock.new(TextLabel.new(" The coefficient of ac"),TextLabel.new(" is")),TextLabel.new("")]),
          PreG6::Multiplication2.new([@e, @a]),
          Subproblem.new([InlineBlock.new(TextLabel.new(" The coefficient of bc"),TextLabel.new(" is")),TextLabel.new("")]),
          PreG6::Addition.new([@b, @e]),
          Subproblem.new([InlineBlock.new(TextLabel.new("Therefore the final answer is")),TextLabel.new(""),
          InlineBlock.new(TextLabel.new("Answer:"), TextLabel.new("#{@i}"),Exponent.new(TextLabel.new("a"),TextLabel.new("2")),TextLabel.new(" +"),TextLabel.new("#{@m}"),Exponent.new(TextLabel.new("b"),TextLabel.new("2")),TextLabel.new(" +"),TextLabel.new("(#{@j})"),TextLabel.new(" ab + "),TextLabel.new("(#{@n})"),TextLabel.new(" ac + "),TextLabel.new("(#{@l})"),TextLabel.new(" bc + "))
          ])
        ]
      end

      
    end
    def text
       if @choose===0
        [
        TextLabel.new("Multiply "), 
        InlineBlock.new(TextLabel.new("(#{@a}x +"),TextLabel.new("#{@b})."),TextLabel.new("(#{@c}"),Exponent.new(TextLabel.new("x"),TextLabel.new("2")),TextLabel.new("+ #{@d}x + #{@e})")),
        TextLabel.new(""),
        InlineBlock.new(TextLabel.new("Answer:"), TextField.new("ans1"),Exponent.new(TextLabel.new("x"),TextLabel.new("3")),TextLabel.new(" + "),TextField.new("ans2"),Exponent.new(TextLabel.new("x"),TextLabel.new("2")),TextLabel.new(" + "),TextField.new("ans3"),TextLabel.new("x + "),TextField.new("ans4"),TextLabel.new(""))
        ]
       else 
        [
        TextLabel.new("Multiply "), 
        InlineBlock.new(TextLabel.new("(#{@a}a +"),TextLabel.new("#{@b}b)."),TextLabel.new("(#{@c}a +"),TextLabel.new("#{@d}b + "),TextLabel.new("#{@e}c)")),TextLabel.new(""),
        TextLabel.new("Answer:"), 
        InlineBlock.new(TextField.new("ans1"),Exponent.new(TextLabel.new("a"),TextLabel.new("2")),TextLabel.new("+"),TextField.new("ans2"),Exponent.new(TextLabel.new("b"),TextLabel.new("2")),TextField.new("ans3"),TextLabel.new("ab+"),TextField.new("ans4"),TextLabel.new("ac+"),TextField.new("ans5"),TextLabel.new("bc"))
        ]
      
        end
    end
  end

  class Mul_tri_tri < QuestionBase
    def self.type
      "Multiply Trinomials"
    end
    def initialize
      
      @a = rand(20)-10
      while @a===0 do
        @a = rand(20)-10
      end
      
      @b = rand(20)-10
      while @b===0 do
        @b = rand(20)-10
      end
      
       @c = rand(20)-10
      while @c===0 do
        @c = rand(20)-10
      end
      
      @d = rand(20)-10
      while @d===0 do
        @d = rand(20)-10
      end

       @e = rand(20)-10
      while @e===0 do
        @e = rand(20)-10
      end

      @f = rand(20)-10
      while @f===0 do
        @f = rand(20)-10
      end
      
      

      @choose = rand(3)
    
    end
    

    def solve
      if @choose===0
        {
         "ans1" =>@a*@d,
          "ans2" =>(@b*@d)+(@a*@e),
          "ans3" =>(@b*@e)+(@a*@f)+(@d*@c),
          "ans4" =>(@b*@f)+(@e*@c),
          "ans5" =>@c*@f
        }  
      else 
        {
          "ans1" =>@a*@d,
          "ans2" =>@b*@e,
          "ans3" =>@c*@f,
          "ans4" =>(@b*@d)+(@a*@e),
          "ans5" =>(@b*@f)+(@c*@e),
          "ans6" =>(@c*@d)+(@a*@f)

        }
      end
      
    end

    def text
      # [TextLabel.new("futre vu")]
       if @choose===0
          [
           TextLabel.new("Multiply "), 
          InlineBlock.new(TextLabel.new("(#{@a}"),Exponent.new(TextLabel.new("x"),TextLabel.new("2")),TextLabel.new("+ #{@b}x + #{@c})"),TextLabel.new("(#{@d}"),Exponent.new(TextLabel.new("x"),TextLabel.new("2")),TextLabel.new("+ #{@e}x + #{@f})")),
          TextLabel.new(""),
          InlineBlock.new(TextLabel.new("Answer:"), TextField.new("ans1"),Exponent.new(TextLabel.new("x"),TextLabel.new("4")),TextLabel.new(" + "),TextField.new("ans2"),Exponent.new(TextLabel.new("x"),TextLabel.new("3")),TextLabel.new(" + "),TextField.new("ans3"),Exponent.new(TextLabel.new("x"),TextLabel.new("2")),TextField.new("ans4"),TextLabel.new("x + "),TextField.new("ans5"))
          ]
       else 
          [
          TextLabel.new("Multiply "), 
          InlineBlock.new(TextLabel.new("(#{@a}a +"),TextLabel.new("#{@b}b+ #{@c}c)"),TextLabel.new("(#{@d}a +"),TextLabel.new("#{@e}b + "),TextLabel.new("#{@f}c)")),TextLabel.new(""),
          TextLabel.new("Answer:"), 
          InlineBlock.new(TextField.new("ans1"),Exponent.new(TextLabel.new("a"),TextLabel.new("2")),TextLabel.new("+"),TextField.new("ans2"),Exponent.new(TextLabel.new("b"),TextLabel.new("2")),TextField.new("ans3"),Exponent.new(TextLabel.new("c"),TextLabel.new("2")),TextField.new("ans4"),TextLabel.new("ab+"),TextField.new("ans5"),TextLabel.new("bc+"),TextField.new("ans6"),TextLabel.new("ac"))
          ]
        end
    end
  end

  

  class Evaluate < QuestionWithExplanation
    def self.type
      "Evaluate Polynomial"
    end
    def initialize
      
      @a = rand(20)-10
      while @a===0 do
        @a = rand(20)-10
      end
      
      @b = rand(20)-10
      while @b===0 do
        @b = rand(20)-10
      end
      
       @c = rand(20)-10
      while @c===0 do
        @c = rand(20)-10
      end
      
      @d = rand(20)-10
      while @d===0 do
        @d = rand(20)-10
      end

       @e = rand(20)-10
      while @e===0 do
        @e = rand(20)-10
      end

      @f = rand(20)-10
      while @f===0 do
        @f = rand(20)-10
      end

      @g = rand(20)-10
      while @g===0 do
        @g = rand(20)-10
      end
      
      @x = rand(3)+1

      @choose = rand(3)
    
    end
    

    def solve
      if @choose===0
        {
         "ans1" =>@a*@x*(@b*@x +@c)+@d,
          
        }  
      else 
        {
          "ans1" =>@a*@x*(@b*@x +@c)+@d*(@e*@x +@f) +@g,

        }
      end
      
    end

    def explain
      [
        Subproblem.new([TextLabel.new(" Simply subsitute the value of x in  the given expression")])
     ]
      
    end
    def text
       if @choose===0
        [
        TextLabel.new("Evaluate the expression for x = #{@x} "), 
        InlineBlock.new(TextLabel.new("#{@a}x(#{@b}x + #{@c}) + #{@d}")),
        TextLabel.new(""),
        InlineBlock.new(TextLabel.new("Answer:"), TextField.new("ans1"))
        ]
       else 
        [
        TextLabel.new("Evaluate the expression for x = #{@x}  "), 
        InlineBlock.new(TextLabel.new("#{@a}x(#{@b}x + #{@c}) + #{@d}(#{@e}x +#{@f}) +#{@g}")),TextLabel.new(""),
        TextLabel.new("Answer:"), 
        InlineBlock.new(TextField.new("ans1"))
        ]
      
        end
    end
  end


  PROBLEMS = [
    Algebra::Coefficient,
   Algebra::Add_polynomials,
   Algebra::Sub_polynomials,
   Algebra::Add_polynomials2,
   Algebra::Sub_polynomials2,
   Algebra::Mul_monomials,
   Algebra::Mul_mono_bi,
   Algebra::Mul_mono_tri,
   Algebra::Mul_bi_bi,
   Algebra::Mul_bi_tri,
   Algebra::Mul_tri_tri,
   Algebra::Evaluate,
   Algebra::Createkb,
   Algebra::Createkb2

    ] # //Anurag is module name and dummy is class name
end