require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml.rb' 
require_relative './preg6'
require_relative '../modules/names'
require_relative '../modules/units'
require_relative '../modules/items'

require 'prime'

include PreG6
include ToHTML

module RationalNumbers
  INDEX = "rationalnumbers"
  TITLE = "Rationalnumbers"
  ACTIVITIES = ["excercised", "read", "slept", "studied", "played"]
  COEFFICIENTS = [2,3,4,5,6,7,8,9,10,12,15,20,25,50,100, 200, 500, 1000]

  def self.gen_fraction
    a, b =  Array.new(2) { rand(11) + 2 }
    a, b = b, a if a > b
    a -= 1 if a == b
    Rational(a, b)
  end

  def self.gen_reducible_fraction
    c = COEFFICIENTS.sample
    f = RationalNumbers.gen_fraction
    [f.numerator, f.denominator].map { |x| c * x }
  end

  class Try6_2 < QuestionWithExplanation
    def self.type
      "Additive Inverse"
    end
    def initialize
      @num = rand(200)-100
      while @num==0
        @num = rand(200)-100 
      end
      @den = rand(100)+1
      @a = -1*@num
    end
    def solve
      {
        "ans1" => @a,
        "ans2" => @den
      }
    end
    
    def text
        [
          InlineBlock.new(TextLabel.new("Write the additive inverse of the following rational number"),Fraction.new(@num,@den)),
          Fraction.new("ans1", "ans2")
          
        ]
    end
    def explain
      [
        SubLabel.new("The additive inverse of a rational number is a rational number which when added to the rational number fraction results in zero. Therefore to find the answer simply reverse the sign")
      ]
    end
    def correct?(params)
      solsum = 0
      bool = true
      resps = QuestionBase.vars_from_response( *( (1...3).map { |i| "ans#{i}" }), params)
      hcf1=Grade6ops.euclideanalg(resps[0].to_i, resps[1].to_i)
          if hcf1==0
              hcf1=1
          end
      hcf2=Grade6ops.euclideanalg(@a, @den)
      if hcf2==0
        hcf2=1
      end
      puts "********\n" + resps.to_s + "********\n"
      (((resps[0].to_i)/hcf1==@a/hcf2)and((resps[1].to_i)/hcf1==@den/hcf2))
    end
  end

  class Try6_3 < QuestionWithExplanation
    def self.type
      "Multiplicative Inverse"
    end
    def initialize
      @num = rand(200)-100
      while @num==0
        @num = rand(200)-100 
      end
      @den = rand(100)+1
     
    end
    def solve
      if @num<0
        {
          "ans1" => -1*@den,
          "ans2" => -1*@num
        }
      else
        {
          "ans1" => @den,
          "ans2" => @num
        }
      end
      
    end
    
    def text
        [
          InlineBlock.new(TextLabel.new("Write the multiplicative inverse/reciprocal of the following rational number"),Fraction.new(@num,@den)),
          Fraction.new("ans1", "ans2")
          
        ]
    end
    def explain
      [
        SubLabel.new("The multiplicative inverse of a rational number is a rational number which when multiplied to the original rational number results in one. Therefore to find the answer simply reverse the fraction")
      ]
    end
    def correct?(params)
      solsum = 0
      bool = true
      resps = QuestionBase.vars_from_response( *( (1...3).map { |i| "ans#{i}" }), params)
      hcf1=Grade6ops.euclideanalg((resps[0].to_i).abs, (resps[1].to_i).abs)
          if hcf1==0
              hcf1=1
          end
      hcf2=Grade6ops.euclideanalg(@num.abs, @den.abs)
      if hcf2==0
        hcf2=1
      end
      puts "********\n" + resps.to_s + "********\n"
      if @num<0
          bool=(((resps[1].to_i)/hcf1==-1*@num/hcf2)and((resps[0].to_i)/hcf1==-1*@den/hcf2))
      else
          bool=(((resps[1].to_i)/hcf1==@num/hcf2)and((resps[0].to_i)/hcf1==@den/hcf2))
      end
      bool
    end
  end

  class Try6_4 < QuestionWithExplanation
    def self.type
      "Product"
    end
    def initialize
      @num = rand(200)-100
      while @num==0
        @num = rand(200)-100 
      end
      @den = rand(100)+1
      @num1 = rand(100)+1
      @den1 = rand(100)+1
    end
    def solve
        {
          "ans1" => @num*@num1,
          "ans2" => @den*@den1
        }
    end
    
    def text
        [
          InlineBlock.new(TextLabel.new("Write the product of the following rational numbers"),Fraction.new(@num,@den),Fraction.new(@num1,@den1)),
          Fraction.new("ans1", "ans2")
          
        ]
    end
    def explain
      [
        SubLabel.new("The product of two rational numbers is the same as the product of their numerators divided by the product of their denominators")
      ]
    end
    def correct?(params)
      solsum = 0
      bool = true
      resps = QuestionBase.vars_from_response( *( (1...3).map { |i| "ans#{i}" }), params)
      hcf1=Grade6ops.euclideanalg((resps[0].to_i).abs, (resps[1].to_i).abs)
          if hcf1==0
              hcf1=1
          end
      hcf2=Grade6ops.euclideanalg((@num*@num1).abs, (@den*@den1).abs)
      if hcf2==0
        hcf2=1
      end
      puts "********\n" + resps.to_s + "********\n"
      if
          bool=(((resps[0].to_i)/hcf1==@num*@num1/hcf2)and((resps[1].to_i)/hcf1==@den*@den1/hcf2))
      end
      bool
    end
  end

  class Try6_5 < QuestionWithExplanation
    def self.type
      "Product 2"
    end
    def initialize
      @num = rand(20)-10
      while @num==0
        @num = rand(20)-10 
      end
      @den = rand(10)+1
      @num1 = rand(10)+1
     
    end
    def solve
        {
          "ans1" => @num*@num1,
          "ans2" => @den
        }
    end
    
    def text
        [
          InlineBlock.new(TextLabel.new("Write the product of the following "),Fraction.new(@num,@den),TextLabel.new("and #{@num1}")),
          Fraction.new("ans1", "ans2")
          
        ]
    end
    def explain
      [
        SubLabel.new("The product of a rational number with a whole number is the same as the product of the numerator with that whole number divided by the denominator")
      ]
    end
    def correct?(params)
      solsum = 0
      bool = true
      resps = QuestionBase.vars_from_response( *( (1...3).map { |i| "ans#{i}" }), params)
      hcf1=Grade6ops.euclideanalg((resps[0].to_i).abs, (resps[1].to_i).abs)
          if hcf1==0
              hcf1=1
          end
      hcf2=Grade6ops.euclideanalg((@num*@num1).abs, (@den).abs)
      if hcf2==0
        hcf2=1
      end
      puts "********\n" + resps.to_s + "********\n"
      if
          bool=(((resps[0].to_i)/hcf1==@num*@num1/hcf2)and((resps[1].to_i)/hcf1==@den/hcf2))
      end
      bool
    end
  end


  class Try6_7 < QuestionWithExplanation
    def self.type
      "Equivalent Rationals"
    end
    def initialize
      @num = rand(200)-100
      while @num==0 do
        @num = rand(200)-100
      end
      @den = rand(100)+1
    end
    def solve
      {
        "ans1" => @num,
        "ans2" => @den
      }
    end
    
    def text
        [
          InlineBlock.new(TextLabel.new("Write a rational number equivalent but not exactly the same as the following fraction"),Fraction.new(@num,@den)),
          Fraction.new("ans1", "ans2")
        ]
    end
    def correct?(params)
      solsum = 0
        bool = true
        resps = QuestionBase.vars_from_response( *( (1...3).map { |i| "ans#{i}" }), params)
        hcf1=Grade6ops.euclideanalg((resps[0].to_i).abs, (resps[1].to_i).abs)
          if hcf1==0
              hcf1=1
          end
        hcf2=Grade6ops.euclideanalg((@num).abs, (@den).abs)
        if hcf2==0
          hcf2=1
        end
        puts "********\n" + resps.to_s + "********\n"
        if
          bool=(((resps[0].to_i)/hcf1==@num/hcf2)and((resps[1].to_i)/hcf1==@den/hcf2))
        end
        bool 
    end
    def explain
      [
        SubLabel.new("By multiplying the numerator and denominator of a rational number by the same non zero integer, we obtain another rational number equivalent to the given rational number. This is exactly like obtaining equivalent fractions")
      ]
    end
  end

  class Try6_8 < QuestionWithExplanation
    def self.type
      "Rational Numbers Between"
    end
    def initialize
      @choose=0
      @num1 = rand(200)-100
      if @num1==0
        @num1 = rand(200)-100
      end
      @den1 = rand(100)+1
      @num2 = rand(200)-100
      if @num2==0
        @num2 = rand(200)-100
      end
      @den2 = rand(100)+1
      if((@num1*@den2)<(@num2*@den1))
        else
          @choose=1
      end
    end
    def solve
      if @choose==0
        {
        "ans1" => @num1+1,
        "ans2" => @den1
        }
      elsif @choose==1
        {
          "ans1" => @num2+1,
          "ans2" => @den2
        }
      end
      
    end
    
    def text
        [
          InlineBlock.new(TextLabel.new("Write a rational number between "),Fraction.new(@num1,@den1), TextLabel.new("and"), Fraction.new(@num2,@den2)),
          Fraction.new("ans1", "ans2")
        ]
    end
    def correct?(params)
      solsum = 0
        bool = true
        resps = QuestionBase.vars_from_response( *( (1...3).map { |i| "ans#{i}" }), params)
        puts "********\n" + resps.to_s + "********\n"
        if @choose==0
          bool=(((resps[0].to_i)*@den1>@num1*(resps[1].to_i))and((resps[0].to_i)*@den2<@num2*(resps[1].to_i)))
        elsif @choose==1
          bool=(((resps[0].to_i)*@den2>@num2*(resps[1].to_i))and((resps[0].to_i)*@den1<@num1*(resps[1].to_i)))
        end
        bool 
    end
    def explain
      [
        SubLabel.new("By multiplying the numerator and denominator of a rational number by the same non zero integer, we obtain another rational number equivalent to the given rational number. This is exactly like obtaining equivalent fractions")
      ]
    end
  end

  class Try6_9 < QuestionWithExplanation
    def self.type
      "Division of Rationals"
    end
    def initialize
      @num = rand(20)-10
      while @num==0
        @num = rand(20)-10 
      end
      @den = rand(10)+1
      @num1 = rand(10)+1
      @den1 = rand(10)+1
      @choose = rand(3)
    end
    def solve
      if @choose===0
        {
          "ans1" => @num*@den1,
          "ans2" => @den*@num1
        }
      elsif @choose==1
        {
          "ans1" => @num,
          "ans2" => @den*@num1
        }
      else
        if @num>0
         {
          "ans2" => @num,
          "ans1" => @den*@num1
          }
        else
        {
          "ans2" => -1*@num,
          "ans1" => -1*@den*@num1
        } 
        end
      end
    end
    def text
      if @choose==0
        [
          InlineBlock.new(TextLabel.new("Divide the first rational number by the second"),Fraction.new(@num,@den),TextLabel.new(","),Fraction.new(@num1,@den1)),
          Fraction.new("ans1", "ans2")
        ]
      elsif @choose==1
        [
          InlineBlock.new(TextLabel.new("Divide the rational number "),Fraction.new(@num,@den),TextLabel.new("by the number"),TextLabel.new(@num1)),
          Fraction.new("ans1", "ans2")
        ] 
      else
        [
          InlineBlock.new(TextLabel.new("Divide the the number"),TextLabel.new(@num1),TextLabel.new(" by the rational number"),Fraction.new(@num,@den)),
          Fraction.new("ans1", "ans2")
        ]  
      end
    end
    def explain
      if @choose==0
        [
          SubLabel.new("The division of one rational number by another is the same as the product of the first rational number with reciprocal of the second fraction")
        ]
      elsif @choose==1
        [
          SubLabel.new("The division of a rational number by a whole number is the same as the multiplication of the whole number in the denominator")
        ]
      else
        [
          SubLabel.new("The division of a whole number by a rational number is the same as the multiplication of the whole number with the denominator divided by the numerator")
        ]
      end
    end
    def correct?(params)
      if @choose==0
        solsum = 0
        bool = true
        resps = QuestionBase.vars_from_response( *( (1...3).map { |i| "ans#{i}" }), params)
        hcf1=Grade6ops.euclideanalg((resps[0].to_i).abs, (resps[1].to_i).abs)
          if hcf1==0
              hcf1=1
          end
        hcf2=Grade6ops.euclideanalg((@num*@den1).abs, (@den*@num1).abs)
        if hcf2==0
          hcf2=1
        end
        puts "********\n" + resps.to_s + "********\n"
        if
          bool=(((resps[0].to_i)/hcf1==@num*@den1/hcf2)and((resps[1].to_i)/hcf1==@den*@num1/hcf2))
        end
        bool 
      elsif @choose==1
        solsum = 0
        bool = true
        resps = QuestionBase.vars_from_response( *( (1...3).map { |i| "ans#{i}" }), params)
        hcf1=Grade6ops.euclideanalg((resps[0].to_i).abs, (resps[1].to_i).abs)
          if hcf1==0
              hcf1=1
          end
        hcf2=Grade6ops.euclideanalg((@num).abs, (@den*@num1).abs)
        if hcf2==0
          hcf2=1
        end
        puts "********\n" + resps.to_s + "********\n"
        if
          bool=(((resps[0].to_i)/hcf1==@num/hcf2)and((resps[1].to_i)/hcf1==@den*@num1/hcf2))
        end
        bool  
      else
        solsum = 0
        bool = true
        resps = QuestionBase.vars_from_response( *( (1...3).map { |i| "ans#{i}" }), params)
        hcf1=Grade6ops.euclideanalg((resps[0].to_i).abs, (resps[1].to_i).abs)
          if hcf1==0
              hcf1=1
          end
        hcf2=Grade6ops.euclideanalg((@num).abs, (@den*@num1).abs)
        if hcf2==0
        hcf2=1
        end
        puts "********\n" + resps.to_s + "********\n"
        if @num>0
          bool=(((resps[1].to_i)/hcf1==@num/hcf2)and((resps[0].to_i)/hcf1==@den*@num1/hcf2))
        else
          bool=(((resps[1].to_i)/hcf1==-1*@num/hcf2)and((resps[0].to_i)/hcf1==-1*@den*@num1/hcf2))
        end
        bool  
      end
    end
  end

  class Try6_10 < QuestionWithExplanation
    def self.type
      "Rational Number?"
    end
    def initialize
      @num1 = rand(5)-2
      @den1 = rand(5)-2 
    end
    def solve
      return {"ans" => "No"} if @den1==0
      return {"ans" => "Yes"} if @den1!=0
    end
    def explain
      [
        SubLabel.new("A rational number is defined as a number that can be expressed in the form p,where p and q are integers and q is not equal to 0.")
      ]
    end
    def text
      [ 
        TextLabel.new("Is the following number a rational number?"),
        Fraction.new(@num1,@den1),
        Dropdown.new("ans","No","Yes")
      ]
    end
  end

  class Try6_13 < QuestionWithExplanation
    def self.type
      "Lowest Form"
    end
    def initialize(num=nil, den=nil)
      if num!=nil
        @num=num
        @den=den
      else
        @num = rand(200)-100
        while @num==100 do
          @num = rand(200)-100
        end
        @den = rand(100)+1
      end
    end
    def solve
      hcf=Grade6ops.euclideanalg(@num.abs, @den)
      {"num" => @num/hcf,
        "den" => @den/hcf}
    end
    def explain
      [
        SubLabel.new("To reduce the following rational number to its lowest form divide both the numerator and the denominator by their lcm. ")
      ]
    end
    def text
      [TextLabel.new("Reduce the following rational number to its lowest form:"), InlineBlock.new(Fraction.new(@num, @den), TextLabel.new(" = "), Fraction.new("num", "den"))]
    end
  end

  class Try6_6 < QuestionWithExplanation
    def self.type
      "Operations on Rationals"
    end
    def initialize(den=nil, nums=nil, sig=nil)
      if den!=nil
        @den=[]
        for i in 0...nums.length
          @den[i]=den
        end
        @num=nums
        @sig=sig
      else
        amt=rand(3)+2
        de=rand(50)+3
        @den=[]
        @num=[]
        @sig=[]
        for i in 0...amt
          @den[i]=de
          @num[i]=(rand(@den[i]/amt)+1).to_i
          if i>0
            @sig[i-1]=rand(2)
            @sig[i-1]=-1 if @sig[i-1]==0
          end
        end
#        puts @num.to_s
#        puts @den.to_s
#        puts @sig.to_s
        sol=Grade6ops::asfractions(@num,@den,@sig)
        if sol[:num]<0
          @num << -1*sol[:num]+rand(de-2)+1
          @den << de
          @sig << 1
        end
      end
    end
    def solve
      sol=Grade6ops::asfractions(@num,@den,@sig)
      {"num" => sol[:num],
        "den" => sol[:den]}
    end
    def explain
      signs=[]
      for i in 0...@num.length
        signs[i]=1
      end
      [SubLabel.new("To perform addition and subtraction on like fractions, ignore the denominators and perform the given operations on the numerators"),
        Chapter6::AddSubIntegers.new(@num, signs, [1] + @sig),
        Subproblem.new([TextLabel.new("Now add back in the denominator"), Fraction.new(@num.reduce(:+), "den")], {"den" => @den[0]}),
        Subproblem.new([TextLabel.new("Hence the fraction in its lowest form is:"), Fraction.new(@num.reduce(:+), @den[0])],{})]
    end
    def text
      stro= [TextLabel.new("Compute the following and reduce to its lowest form:")] 
      str= [Fraction.new(@num[0], @den[0])]
      for i in 0...@sig.length
        if @sig[i]==1
          str << TextLabel.new('+')
          str << Fraction.new(@num[i+1], @den[i+1])
        else
          str << TextLabel.new('-')
          str << Fraction.new(@num[i+1], @den[i+1])
        end
      end
      str << TextLabel.new("=")
      str << Fraction.new("num","den")
      stro << InlineBlock.new(str)
      stro
    end
  end


  PROBLEMS=
  [
    
    RationalNumbers::Try6_13,
    RationalNumbers::Try6_2,
    RationalNumbers::Try6_3,
    RationalNumbers::Try6_4,
    RationalNumbers::Try6_5,
    RationalNumbers::Try6_6,
    RationalNumbers::Try6_7,
    RationalNumbers::Try6_8,
    RationalNumbers::Try6_9,
    RationalNumbers::Try6_10,
    # RationalNumbers::Try6_11,
    ]
end