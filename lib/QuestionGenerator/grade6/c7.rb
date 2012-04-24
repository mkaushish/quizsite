
#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml.rb' 
include ToHTML

module Chapter7
  
#TODO Fraction Formatting

  class ToMixedFractions < QuestionBase
    def self.type
      "To Mixed Fractions"
    end
    def initialize
      @den=rand(8)+1
      @num=rand(60)+10
      while @num/@den==(@num.to_f)/@den
        @num=rand(60)+10
      end
      i=@den
      while i>1
        while (@num/i==(@num.to_f)/i && @den/i==(@den.to_f)/i)
          @num=@num/i
          @den=@den/i
          
        end
        i-=1
      end
    end
    def solve
      intpart=@num/@den
      remainder=@num-(intpart*@den)
      sol={"num" => remainder.to_s, 
           "den" =>  @den.to_s, 
           "intpart" =>  intpart.to_s}
    end
    def explain
      sol=solve
      [Subproblem.new([TextLabel.new("Divide the Numerator by the Denominator. What is the Quotient and what is the Remainder?"), TextField.new("quo", "Quotient"), TextField.new("rem", "Remainder")], {"quo" => @num/@den, "rem" => (@num-(@num/@den)*@den)}),
        Subproblem.new([TextLabel.new("Since the quotient is #{@num/@den} and the remainder is #{@num-(@num/@den)*@den}, the fraction in mixed form is"), Fraction.new(sol["num"], sol["den"], sol["intpart"])])]  
    end
    def  text
      [TextLabel.new("Convert the following into a mixed fraction"), Fraction.new(@num,@den), Fraction.new("num", "den", "intpart")]
    end
  end
  
  class ToImproperFractions < QuestionBase
    def self.type
      "To Improper Fractions"
    end
    def initialize
      @den=rand(8)+1
      @num=rand(60)+10
      while @num/@den==(@num.to_f)/@den
        @num=rand(60)+10
      end
      i=@den
      while i>1
        while (@num/i==(@num.to_f)/i && @den/i==(@den.to_f)/i)
          @num=@num/i
          @den=@den/i
        end
        i-=1
      end
    end
    def solve
      sol={"num" => @num.to_s,
           "den" => @den.to_s}
    end
    def explain
      [Subproblem.new([TextLabel.new("Multiply the denominator, #{@den}, by the integer part, #{@num/@den}, and add the numerator, #{@num-(@num/@den)*@den}."), Fraction.new("numer", "deno")], {"numer" => @num.to_s, "deno" => @den.to_s}),
        Subproblem.new([TextLabel.new("Hence, the Fraction in improper form is"), Fraction.new(@num, @den)])]

    end
    def  text
      intpart=@num/@den
      remainder=@num-(intpart*@den)
      [TextLabel.new("Convert the following into an improper fraction"), Fraction.new(remainder, @den, intpart), Fraction.new("num", "den")]
    end
  end
  
  MAXEQFRAC=60
  class EquivalentFractions < QuestionBase
    def self.type
      "Equivalent Fractions"
    end
    def initialize
      @den1=rand(MAXEQFRAC)+3
      @num1=rand(@den1)+1
      sig=rand(2)
      if sig==0
        mult=rand(10)+2
        @num2=@num1*mult
        @den2=@den1*mult
      else
        @den2=rand(MAXEQFRAC)+3
        @num2=rand(@den2)+1
      end
    end
    def explain
      fr1=Rational(@num1,@den1)
      fr2=Rational(@num2,@den2)
      ter=[Subproblem.new([TextLabel.new("Reduce the first Fraction to its lowest form"), Fraction.new(@num1, @den1), Fraction.new("num1", "den1")], {"num1" => fr1.numerator.to_s, "den1" => fr1.numertor.to_s}),
        Subproblem.new([TextLabel.new("Reduce the second Fraction to its lowest form"), Fraction.new(@num2, @den2), Fraction.new("num2", "den2")], {"num2" => fr2.numerator.to_s, "den2" => fr2.numertor.to_s})]
      ret=[TextLabel.new("If the numerator of the reduced first fraction, #{fr1.numerator}, equals the numerator of the reduced second fraction, #{fr2.numerator}, and the denominator of the reduced first fraction, #{fr1.denominator}, equals the denominator of the reduced second fraction, #{fr2.denominator}, then the fractions are equivalent.")]
      if solve["ans"]=='='
        ret << TextLabel.new("Hence, the Fractions are equivalent.")
      else
        ret << TextLabel.new("Hence, the Fractions are not equivalent")
      end
      ter << Subproblem.new(ret)
      ter
    end

    def solve

      return {"ans" => '='} if Rational(@num1,@den1)==Rational(@num2,@den2)
      return {"ans" => SYMBOL[:notequals]}
    end
  
  
    def text
      [TextLabel.new("Are the following equivalent?"), Fraction.new(@num1, @den1), Dropdown.new("ans", '=', SYMBOL[:notequals]) , Fraction.new(@num2,@den2)] 
    end
  end

  class ReduceFractions < QuestionBase
    def self.type
      "Reduce Fractions"
    end
    def initialize
      com=(rand(9)+2)*(10**(rand(3)))
      @den=rand(30)+2
      @num=rand(@den-1)+1
      @den=@den*com
      @num=@num*com
    end
    def solve
      @com=Grade6ops::euclideanalg(@den,@num)
      return {"num" => (@num/@com).to_s,
              "den"  => (@den/@com).to_s}
    end
    def explain
      [Subproblem.new([TextLabel.new("Find the HCF of the Numerator, #{@num}, and Denominator, #{@den}."), TextField.new("hcf", "HCF")], {"hcf" =>  Grade6ops::euclideanalg(@den,@num)}),
        Subproblem.new([TextLabel.new("Divide the Numerator, #{@num}, by the HCF and the Denominator, #{@den} by the HCF"), TextField.new("numbh", "Numerator divided by HCF"), TextField.new("denbh", "Denominator divided by HCF")], {"numbh" => solve["num"], "denbh" => solve["den"]}),
        Subproblem.new([TextLabel.new("So, the fraction in its lowest form is"), Fraction.new(solve["num"], solve["den"])])]
    end
    def text
      [TextLabel.new("Reduce to its lowest form:"), Fraction.new(@num,@den), Fraction.new("num", "den")] 
    end
  end
  
  class FillFractions < QuestionBase
    def self.type
      "Fill in Fractions"
    end
    def initialize
      com=(rand(9)+2)
      @den=[]
      @num=[]
      @sig=[]
      @den[0]=rand(10)+2
      @num[0]=rand(@den[0]-1)+1
      @den[1]=@den[0]*com
      @num[1]=@num[0]*com
      @sig[0]=rand(2)
      @sig[1]=rand(2)
    end
    def solve
      if @sig[1]==0
        return {"ans" => @den[@sig[0]].to_s}
      end
      return {"ans" => @num[@sig[0]].to_s}
    end
    def text
      str=[]
      str << TextLabel.new("Fill in the blank:")
      str1 = []
      str2 = []
      
      if @sig[0]==0
        str2 << Fraction.new(@num[1], @den[1])
        if @sig[1]==0
          str1 << Fraction.new(@num[0],"den")
        else
          str1 << Fraction.new("num", @den[0])
        end
      else
        str1 << Fraction.new(@num[0], @den[0])
        if @sig[1]==0
          str2 << Fraction.new(@num[1], "den")
        else
          str2 << Fraction.new("num", @den[1])
        end
      end
      wh=rand(2)
      if wh==0
        str+=str1
        str << TextLabel.new('=')
        str += str2
      else
        str+=str2
        str << TextLabel.new('=')
        str+=str1
      end
      str
    end  
  end
                
  class CompareLikeFrac < QuestionBase
    def self.type
      "Compare Like Fractions"
    end
    def initialize
      @den=rand(25)+2
      @num1=rand(@den-1)+1
      @num2=rand(@den-1)+1
    end
    def solve
      return {"ans" => '='} if @num1==@num2
      return {"ans" => '<'} if @num1<@num2
      return {"ans" => '>'} if @num1>@num2
    end
    def explain
      [Subproblem.new([TextLabel.new("To Compare like fractions, all that has to be done is the compare the numerators. Choose the correct symbol"), TextLabel.new(@num1.to_s), Dropdown.new("ans", '=', '<', '>'), TextLabel.new(@num2.to_s)], solve),
       Subproblem.new([TextLabel.new("Since the First numerator, #{@num1}, #{solve["ans"]} Second numerator, #{@num2},"), Fraction.new(@num1,@den), TextLabel.new(solve["ans"]), Fraction.new(@num2, @den)])]  
    end
    def text
      [TextLabel.new("Place the appropriate symbol:"), Fraction.new(@num1, @den), Dropdown.new("ans", '=', '<', '>'), Fraction.new(@num2, @den)]
    end
  end
  
  class CompareUnlikeFrac < QuestionBase
    def self.type
      "Compare Unlike Fractions"
    end
    def initialize
      @den1=rand(25)+2
      @den2=rand(25)+2
      @num1=rand(@den1-1)+1
      @num2=rand(@den2-1)+1
    end
    def solve
      return {"ans" => '='} if Rational(@num1, @den1)==Rational(@num2, @den2)
      return {"ans" => '<'} if Rational(@num1, @den1)<Rational(@num2, @den2)  
      return {"ans" => '>'} if Rational(@num1, @den1)>Rational(@num2, @den2)  
    end
    def explain
      hcf=Grade6ops::euclideanalg(@den1,@den2)
      lcm=(@den1*@den2)/hcf
      [Subproblem.new([TextLabel.new("Find the LCM of the tewo denominators, #{@den1} and #{@den2}. Divide the LCM by the two denominators"), TextField.new("lcm", "LCM"), TextField.new("den1h", "LCM divided by denominator 1"), TextField.new("den2h", "LCM divided by denominator 2")], {"lcm" => lcm, "den1h" => lcm/@den1,  "den2h" => lcm/@den2}),
       Subproblem.new([TextLabel.new("Multiply the first Numerator, #{@num1}, by #{lcm/@den2}. Multiply the second Numerator,  #{@num2}, by #{lcm/@den1}."),  TextField.new("num11", "Numerator 1 multiplied by #{lcm/@den2}"), TextField.new("num22", "Numerator 2 multiplied by #{lcm/@den1}")], {"num11" => @num1*(lcm/@den2), "num22" => @num2*(lcm/@den1)}),
      Subproblem.new([TextLabel.new("Hence,"), Fraction.new(@num1,@den1), TextLabel.new(solve["ans"]), Fraction.new(@num2, @den2)])] 
    end
    def text
      [TextLabel.new("Place the appropriate symbol:"), Fraction.new(@num1,@den1), Dropdown.new("ans",'=','<','>'), Fraction.new(@num2, @den2)]
    end
  end
  
  class ASUnlikeFractions < QuestionBase
    def self.type
      "Operations on Unlike Fractions"
    end
    def initialize(amt=2)
      @den=[]
      @num=[]
      @sig=[]
      for i in 0...amt
        @den[i]=rand(25)+2
        @num[i]=(rand(@den[i]/amt)+1).to_i
        if i>0
          @sig[i-1]=rand(2)
          @sig[i-1]=-1 if @sig[i-1]==0
        end
      end
    end
    def solve
      sol=Grade6ops::asfractions(@num,@den,@sig)
      {"num" => sol.num.to_s,
       "den" => sol.den.to_s}
    end
    def text
      str= [TextLabel.new("Compute the following and reduce to its lowest form:") , Fraction.new(@num[0], @den[0])]
       for i in 0...@sig.length
        if @sig[i]==1
          str << TextLabel.new('+')
          str << Fraction.new(@num[i+1], @den[i+1])
        else
          str << TextLabel.new('-')
          str << Fraction.new(@num[i+1], @den[i+1])
        end
      end
      str << Fraction.new("num", "den")
    end
  end

  class ASLikeFractions < QuestionBase
    def self.type
      "Operations on Like Fractions"
    end
    def initialize(amt=rand(3)+2)
      de=rand(25)+3
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
      puts @num.to_s
      puts @den.to_s
      puts @sig.to_s
      sol=Grade6ops::asfractions(@num,@den,@sig)
      if sol[:num]<0
        @num << -1*sol[:num]+rand(de-2)+1
        @den << de
        @sig << 1
      end
    end
    def solve
      sol=Grade6ops::asfractions(@num,@den,@sig)
      {"num" => sol[:num].to_s,
       "den" => sol[:den].to_s}
    end
    def text
      str= [TextLabel.new("Compute the following and reduce to its lowest form:") , Fraction.new(@num[0], @den[0])]
       for i in 0...@sig.length
        if @sig[i]==1
          str << TextLabel.new('+')
          str << Fraction.new(@num[i+1], @den[i+1])
        else
          str << TextLabel.new('-')
          str << Fraction.new(@num[i+1], @den[i+1])
        end
      end
      str << Fraction.new("num","den")
    end
  end
  
  class ASMixedFractions < QuestionBase
    def self.type
      "Operations on Mixed Fractions"
    end
    def initialize(amt=2)
      @intpart=[]
      @den=[]
      @num=[]
      @sig=[]
      for i in 0...amt
        @intpart[i]=rand(6)+1
        @den[i]=rand(25)+2
        @num[i]=(rand(@den[i]/amt)+1).to_i
        if i>0
          @sig[i-1]=rand(2)
          @sig[i-1]=-1 if @sig[i-1]==0
        end
      end
    end
    def solve
      frac=Grade6ops::asfractions(@num,@den,@sig)
      frac["intpart"]=@intpart.reduce(:+)
      frac
    end
    def text
      str = [TextLabel.new("Compute the following and give the answer in its lowest form:"), Fraction.new(@num[0],@den[0], @intpart[0])]
       for i in 0...@sig.length
        if @sig[i]==1
          str << TextLabel.new('+')
          str << Fraction.new(@num[i+1], @den[i+1], @intpart[i+1])
        else
          str << TextLabel.new('-')
          str << Fraction.new(@num[i+1], @den[i+1], @intpart[i+1])
        end
      end
      str << Fraction.new("num", "den", "intpart")
    end
  end

  PROBLEMS=[Chapter7::ToMixedFractions, Chapter7::ToImproperFractions, Chapter7::EquivalentFractions, Chapter7::ReduceFractions, Chapter7::FillFractions, Chapter7::CompareLikeFrac, Chapter7::CompareUnlikeFrac, Chapter7::ASLikeFractions, Chapter7::ASUnlikeFractions, Chapter7::ASMixedFractions]

end


