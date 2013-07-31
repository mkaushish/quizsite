
#!/usr/bin/env ruby
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

module Chapter7
  INDEX = 7
  TITLE = "Fractions"
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
    f = Chapter7.gen_fraction
    [f.numerator, f.denominator].map { |x| c * x }
  end

  class ToMixedFractions < QuestionWithExplanation
    def self.type
      "To Mixed Fractions"
    end

    def initialize(frac = nil)
      f = frac || Chapter7.gen_fraction + 1 + rand(5)
      @num, @den = [f.numerator, f.denominator]
    end

    def solve
      {
        "num" => @num % @den,
        "den" => @den, 
        "intpart" => @num / @den
      }
    end
    def explain
      q = soln["intpart"].to_i
      r = soln["num"].to_i
      [
        SubLabel.new("Mixed fractions and improper fractions are two ways of representing the same number. " +
                     "To convert a fraction to a mixed fraction, first divide the numerator by the denominator " +
                    "to get the Quotient and Remainder."),
        PreG6::Division.new(@den, @num),
        Subproblem.new(
          [ TextLabel.new("We can now rewrite our improper fraction into the mixed fraction below"),
            InlineBlock.new( Fraction.new(@num, @den), "=", Fraction.new(r, @den, q) ),
          ], {}),
        Subproblem.new(
          [ TextLabel.new("While you're filling in the blank in the equation below, try to think why that " + 
                          "number matters for both types of fractions"),
            InlineBlock.new( Fraction.new(@num, @den), " = ", Fraction.new(r, @den, q), 
                             " = ", Fraction.new("ans", @den), " + ", Fraction.new(r, @den) )
          ], {"ans" => q * @den})
      ]
    end
    def  text
      [TextLabel.new("Convert the following into a mixed fraction with the same denominator"), InlineBlock.new(Fraction.new(@num,@den), TextLabel.new(" = "), Fraction.new("num", "den", "intpart"))]
    end
  end

  class ToImproperFractions < QuestionWithExplanation
    def self.type
      "To Improper Fractions"
    end
    def initialize
      @den=rand(8)+2
      @num=rand(60)+10
      while @num/@den==(@num.to_f)/@den
        @num=rand(60)+10
      end
      hcf=Grade6ops.euclideanalg(@num, @den)
      @num /= hcf
      @den /= hcf
    end
    def solve
      sol={"num" => @num,
        "den" => @den}
    end
    def explain
      [SubLabel.new("To convert a mixed fraction into an improper fraction, multiply the integer part by the denominator. Then add the numerator of the mixed fraction to the product. This gives the numerator of the improper fraction. The denominator remains the same. The integer part in this case is #{@num/@den}. The denominator is #{@den} and the numerator is #{@num-@num/@den}"), 
        PreG6::Multiplication.new(@num/@den , @den),
        PreG6::Addition.new([(@num/@den)*@den, solve["num"]-(@num/@den)*@den]), 
        Subproblem.new([TextLabel.new("The denominator of the mixed fraction is #{@den}. Hence, the Fraction in improper form is:"), Fraction.new("num", "den")], {"num" => solve["num"], "den" => solve["den"]})]

    end
    def  text
      intpart=@num/@den
      remainder=@num-(intpart*@den)
      [TextLabel.new("Convert the following into an improper fraction with the same denominator"), InlineBlock.new(Fraction.new(remainder, @den, intpart), TextLabel.new(" = "), Fraction.new("num", "den"))]
    end
  end

  class ReduceFractionsEA < QuestionBase
    def initialize(num=nil, den=nil)
      if num!=nil
        @num=num
        @den=den
      else
        @den=rand(200)+10
        @num=rand(@den)+2
      end
    end
    def solve
      hcf=Grade6ops.euclideanalg(@num, @den)
      {"num" => @num/hcf,
        "den" => @den/hcf}
    end
    def explain
      hcf=Grade6ops.euclideanalg(@num, @den)
      [Chapter3::HCFEA.new(@num, @den),
        PreG6::Division.new(hcf, @num, true),
        PreG6::Division.new(hcf, @den, true)]
    end
    def text
      [TextLabel.new("Reduce the following fraction to its lowest form:"), InlineBlock.new(Fraction.new(@num, @den), TextLabel.new(" = "), Fraction.new("num", "den"))]
    end
  end

  class ReduceFractions < QuestionWithExplanation
    # 
    # The variables here:
    #   nums1 is an array of prime factors
    #   nums2 is an array of prime factors
    #   comm is just the prime factors they have in common
    #
    # not sure why we used this bizarre system instead of just using two numbers 
    # to represent the numerator and denominator
    #
    # ReduceFractions.new(num, denom) will work, where num is the numerator and denom 
    # denominator, both are Fixnums
    def initialize(nums1=nil, nums2=nil, comm=nil)
      if !nums1.nil? && !nums2.nil? && comm.nil?
        @nums1 = nums1.prime_division.map { |p| [p[0]] * p[1] }.flatten
        @nums2 = nums2.prime_division.map { |p| [p[0]] * p[1] }.flatten
        @comm  = nums1.gcd(nums2).prime_division.map { |p| [p[0]] * p[1] }.flatten

      elsif (nums1!=nil && nums2!=nil && comm!=nil)
        @nums1=nums1
        @nums2=nums2
        @comm=comm
      else
        @nums1=[1]
        @nums2=[1]
        while @nums1.reduce(:*).to_f/@nums2.reduce(:*)==1
          nms=Grade6ops.chCommPF
          @nums1=nms[0]
          @nums2=nms[1]
          @comm=nms[2]
        end
      end

      puts "#{@nums1}, #{@nums2}, #{@comm}"
    end
    def solve
      {"num" => @nums1.reduce(:*)/@comm.reduce(:*),
        "den" => @nums2.reduce(:*)/@comm.reduce(:*)}
    end
    def explain
      [SubLabel.new("To reduce a fraction to its lowest form, you have to divide the numerator and denominator by their HCF"),
        Chapter3::HCF.new(@nums1, @nums2, @comm),
        PreG6::Division.new(@comm.reduce(:*), @nums1.reduce(:*), true),
        PreG6::Division.new(@comm.reduce(:*), @nums2.reduce(:*), true),
        Subproblem.new([TextLabel.new("Hence, the fraction in its lowest form is:"), Fraction.new(TextLabel.new(solve["num"]), TextLabel.new(solve["den"]))])]
    end
    def text
      [TextLabel.new("Reduce the following fraction to its lowest form"), InlineBlock.new(Fraction.new(@nums1.reduce(:*), @nums2.reduce(:*)), TextLabel.new(" = "), Fraction.new("num", "den"))]
    end
  end


  MAXEQFRAC=60
  class EquivalentFractions < QuestionWithExplanation
    def self.type
      "Equivalent Fractions"
    end
    def initialize
      nm1=Grade6ops.chCommPF
      @den1=nm1[1]
      @num1=nm1[0]
      @comm1=nm1[2]
      sig=rand(2)
      if sig==0
        mult=rand(2)+1
        for i in 0...mult
          pr=[2,2,2,3,3,5,7].sample
          @num2=Array.new(@num1)
          @den2=Array.new(@den1)
          @num2 << pr
          @den2 << pr
        end
      else
        nm2=Grade6ops.chCommPF
        @den2=nm2[1]
        @num2=nm2[0]
        @comm2=nm2[2]
      end
    end
    def explain
      [Chapter7::ReduceFractions.new(@num1, @den1, @comm1),
        Chapter7::ReduceFractions.new(@num2, @den2, @comm2),
        Subproblem.new([TextLabel.new("If the numerator of the reduced first fraction, #{@num1.reduce(:*)}, equals the numerator of the reduced second fraction, #{@num2.reduce(:*)}, and the denominator of the reduced first fraction, #{@den1.reduce(:*)}, equals the denominator of the reduced second fraction, #{@den2.reduce(:*)}, then the fractions are equivalent. Are the fractions equivalent?"), Dropdown.new("tr", "=", SYMBOL[:notequals])], {"tr" => solve["ans"]})]
    end

    def solve
      return {"ans" => '='} if Rational(@num1.reduce(:*),@den1.reduce(:*))==Rational(@num2.reduce(:*),@den2.reduce(:*))
      {"ans" => SYMBOL[:notequals]}
    end


    def text
      [TextLabel.new("Are the following equivalent?"), InlineBlock.new(Fraction.new(@num1.reduce(:*), @den1.reduce(:*)), Dropdown.new("ans", '=', SYMBOL[:notequals]) , Fraction.new(@num2.reduce(:*),@den2.reduce(:*)))] 
    end
  end


  class FillNumerator < QuestionBase
    def self.type
      "Fill in Numerators"
    end
    def initialize(den=nil, num=nil, sig=nil, wh=nil)
      if(den!=nil)
        @den=den
        @num=num
        @sig=sig
        @wh=wh
      else
        com=(rand(9)+2)
        @den=[]
        @num=[]
        @sig=[]
        @den[0]=rand(10)+2
        @num[0]=rand(@den[0]-1)+1
        @den[1]=@den[0]*com
        @num[1]=@num[0]*com
        @sig=rand(2)
        @wh=rand(2)
      end
    end
    def solve
      return {"ans" => @num[@sig]}
    end
    def text
      stro=[]
      str=[]
      stro << TextLabel.new("Fill in the Numerator:")
      str1 = []
      str2 = []

      if @sig==0
        str2 << Fraction.new(@num[1], @den[1])
        str1 << Fraction.new("ans", @den[0])
      else
        str1 << Fraction.new(@num[0], @den[0])
        str2 << Fraction.new("ans", @den[1])
      end
      if @wh==0
        str+=str1
        str << TextLabel.new('=')
        str += str2
      else
        str+=str2
        str << TextLabel.new('=')
        str+=str1
      end
      stro << InlineBlock.new(str)
      stro
    end  
  end

  class FillDenominator < QuestionBase
    def self.type
      "Fill in Denominators"
    end
    def initialize(den=nil, num=nil, sig=nil, wh=nil)
      if(den!=nil)
        @den=den
        @num=num
        @sig=sig
        @wh=wh
      else
        com=(rand(9)+2)
        @den=[]
        @num=[]
        @sig=[]
        @den[0]=rand(10)+2
        @num[0]=rand(@den[0]-1)+1
        @den[1]=@den[0]*com
        @num[1]=@num[0]*com
        @sig=rand(2)
        @wh=rand(2)
      end
    end
    def solve
      return {"ans" => @den[@sig]}
    end
    def text
      str=[]
      stro=[]
      stro << TextLabel.new("Fill in the Denominator:")
      str1 = []
      str2 = []

      if @sig==0
        str2 << Fraction.new(@num[1], @den[1])
        str1 << Fraction.new(@num[0], "ans")
      else
        str1 << Fraction.new(@num[0], @den[0])
        str2 << Fraction.new(@num[1], "ans")
      end
      if @wh==0
        str+=str1
        str << TextLabel.new('=')
        str += str2
      else
        str+=str2
        str << TextLabel.new('=')
        str+=str1
      end
      stro << InlineBlock.new(str)
      stro
    end  
  end

  class CompareLikeFrac < QuestionWithExplanation
    def self.type
      "Compare Like Fractions"
    end
    def initialize(den=nil, num1=nil, num2=nil)
      if(den!=nil && num1!=nil && num2!=nil)
        @den=den
        @num1=num1
        @num2=num2
      else
        @den=rand(25)+2
        @num1=rand(@den-1)+1
        @num2=rand(@den-1)+1
      end
    end
    def solve
      return {"ans" => '='} if @num1==@num2
      return {"ans" => '<'} if @num1<@num2
      return {"ans" => '>'} if @num1>@num2
    end
    def explain
      [SubLabel.new("To Compare like fractions, all that has to be done is to compare the numerators."), PreG6::CompareNumbers.new(@num1, @num2),
        Subproblem.new([TextLabel.new("Since the First numerator, #{@num1}, #{solve["ans"]} Second numerator, #{@num2}, place the appropriate symbol:"), InlineBlock.new(Fraction.new(@num1,@den), Dropdown.new("ans", "=", "<", ">"), Fraction.new(@num2, @den))], {"ans" => solve["ans"]})]  
    end
    def text
      [ TextLabel.new("Place the appropriate symbol:"), 
        InlineBlock.new( Fraction.new(@num1, @den), 
                         Dropdown.new("ans", '=', '<', '>'), 
                         Fraction.new(@num2, @den)
        ) ]
    end
  end

  class CompareUnlikeFrac < QuestionWithExplanation
    def self.type
      "Compare Unlike Fractions"
    end
    def initialize
      dens=Grade6ops.chCommPF
      @dens1=dens[0]
      @den1=@dens1.reduce(:*)
      @dens2=dens[1]
      @den2=@dens2.reduce(:*)
      @comm=dens[2]
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
      [SubLabel.new("To compare two unlike fractions, we have to make them into like fractions. We do this by finding the LCM of the two denominators and making that the new denominator. Then, we have to appropriately scale up the numerators"),
        Chapter3::LCM.new(@dens1, @dens2, @comm),
        Chapter7::FillNumerator.new([@den1, lcm], [@num1, @num1*(lcm/@den1)], 1, 0),
        Chapter7::FillNumerator.new([@den2, lcm], [@num2, @num2*(lcm/@den2)], 1, 0),
        SubLabel.new("Now they are like fractions, which we can easily compare"),
        Chapter7::CompareLikeFrac.new(lcm, @num1*(lcm/@den1), @num2*(lcm/@den2))]
    end
    def text
      [TextLabel.new("Place the appropriate symbol:"), InlineBlock.new(Fraction.new(@num1,@den1), Dropdown.new("ans",'=','<','>'), Fraction.new(@num2, @den2))]
    end
  end

  class ASUnlikeFractions < QuestionWithExplanation
    def self.type
      "Operations on Unlike Fractions"
    end
    def initialize(nums=nil, dens=nil, comm=nil, sig=nil)
      if nums!=nil
        @num=nums
        @dens=dens
        @comm=comm
        @den=[]
        for i in 0...@dens.length
          @den[i]=@dens[i].reduce(:*)
        end
        @sig=sig
      else
        @num=[]
        @sig=[]
        @dens=[]
        @den=[]
        @comm=[]
        ln=rand(2)+2
        nms=Grade6ops.chCommPF(250)
        @dens[0]=nms[0]
        @dens[1]=nms[1]
        @comm[0]=nms[2]
        @tmp=Chapter3::LCM.new(@dens[0], @dens[1], @comm[0])
        for i in 2...ln
          @tmp=Chapter3::LCM.new(@tmp.lcm, @dens[i-1], @comm[i-2])
          nms=Grade6ops.chCommPF(250, @tmp.lcm)
          @dens[i]=nms[1]
          @comm[i-1]=nms[2]
        end
        @tmp=Chapter3::LCM.new(@tmp.lcm, @dens[@dens.length-1], @comm[@dens.length-2])
        for i in 0...ln
          @den[i]=@dens[i].reduce(:*)
          @num[i]=(rand((@den[i]/ln).to_i)+1)
          if i>0
            @sig[i-1]=rand(2)
            @sig[i-1]=-1 if @sig[i-1]==0
          end
        end
      end
    end
    def solve
      sol=Grade6ops::asfractions(@num,@den,@sig)
      {"num" => sol[:num],
        "den" => sol[:den]}
    end
    def explain
      ret=[SubLabel.new("First, we find the LCM of all the denominators. Then, we scale up the numerators to have the LCM as their denominator. Then, we perform operations on these new fractions as we would on like fractions.")]
      lcm = Chapter3::MultLCM.new(@dens, @comm)
      ret << lcm
      nums=[]
      for i in 0...@num.length
        nums[i] = @num[i]*(lcm.solve["lcm"]/@den[i])
        ret << Chapter7::FillNumerator.new([@den[i], lcm.solve["lcm"]], [@num[i], nums[i]], 1, 0)
      end
      ret << Chapter7::ASLikeFractions.new(lcm.solve["lcm"], nums, @sig)
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
      str << Fraction.new("num", "den")
      stro << InlineBlock.new(str)
      stro
    end
  end

  class ASLikeFractions < QuestionWithExplanation
    def self.type
      "Operations on Like Fractions"
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

  class ASMixedFractions < ASUnlikeFractions
    def self.type
      "Operations on Mixed Fractions"
    end
    def initialize(amt=2)
      super()
      @intpart=[]
      for i in 0...@num.length
        @intpart[i]=rand(6)+1
      end
      tm=solve["num"]
      tm2=solve["intpart"]
      while tm < 0 || tm2 < 0
        super()
        @intpart=[]
        for i in 0...@num.length
          @intpart[i]=rand(6)+1
        end
        tm=solve["num"]
        tm2=solve["intpart"]
      end
    end
    def solve
      ints=[@intpart[0]]
      for i in 1...@intpart.length
        ints[i]=@intpart[i]*@sig[i-1]
      end
      frac=Grade6ops::asfractions(@num,@den,@sig)
      {"intpart" => ints.reduce(:+),
        "num" => frac[:num],
        "den" => frac[:den]}
    end
    def explain
      ret=[SubLabel.new("First we perform the operations on the integer parts and then on the fraction parts.")]
      ints=[@intpart[0]]
      sig=[1]
      for i in 1...@intpart.length
        ints[i]=@intpart[i]*@sig[i-1]
        sig[i]=1
      end
      ret+=[Chapter6::AddSubIntegers.new(ints, sig, sig),
      ASUnlikeFractions.new(@num, @dens, @comm, @sig),
      Subproblem.new([TextLabel.new("Hence the result is: "), Fraction.new("num", "den", "intpart")], solve)]
    end 
    def text
      stro = [TextLabel.new("Compute the following and give the answer in its lowest form:")]
      str = [Fraction.new(@num[0],@den[0], @intpart[0])]
      for i in 0...@sig.length
        if @sig[i]==1
          str << TextLabel.new('+')
          str << Fraction.new(@num[i+1], @den[i+1], @intpart[i+1])
        else
          str << TextLabel.new('-')
          str << Fraction.new(@num[i+1], @den[i+1], @intpart[i+1])
        end
      end
      str << TextLabel.new("=")
      str << Fraction.new("num", "den", "intpart")
      stro << InlineBlock.new(str)
      stro
    end
  end
  ITEMSUSED=["pensils", "notebooks", "pens", "batteries", "crayons"]
  class Try5_1 < QuestionWithExplanation
    def self.type
      "Largest Fraction"
    end
    def initialize
      @person1 , @person2, @person3 = Names.generate(3)
      @a = rand(4)+2
      @b = rand(4)+2
      @c = rand(4)+2
      @d = @a*10
      @e = @b*10
      @f = @c*10
      @g = @a*@b*10
      @h = @b*@c*10
      @i = @c*@a*10
      @choose1 = @a-@b
      @num = 1
      @den =1
      @item=ITEMSUSED.sample
    end

    def solve
      if (@a==@b)and(@b==@c)
        { 
          "num" => 1,
          "den" => @a,
          "sign" => "Equal"
        }
      elsif @a<@b
        if @a<@c
         { 
          "num" => 1,
          "den" => @a,
          "sign" => "#{@person3}"
          } 
        elsif @a>@c
          { 
          "num" => 1,
          "den" => @c,
          "sign" => "#{@person2}"
          }
        elsif @a==@c
           { 
          "num" => 1,
          "den" => @a,
          "sign" => "#{@person3}"
          }        
        end
      elsif @a>@b
        if @b<@c
         { 
          "num" => 1,
          "den" => @b,
          "sign" => "#{@person1}"
          } 
        elsif @b>@c
          { 
          "num" => 1,
          "den" => @c,
          "sign" => "#{@person2}"
          }
        elsif @b==@c
           { 
          "num" => 1,
          "den" => @b,
          "sign" => "#{@person1}"
          }        
        end
      elsif (@a==@b)
        if @a<@c
         { 
          "num" => 1,
          "den" => @a,
          "sign" => "#{@person3}"
          } 
        elsif @a>@c
          { 
          "num" => 1,
          "den" => @c,
          "sign" => "#{@person2}"
          }
        elsif @a==@c
           { 
          "num" => 1,
          "den" => @a,
          "sign" => "Equal"
          }        
        end
      end
    end

    def correct?(params)
      if (@a<=@b)and(@a<=@c)
        if @a==@b
          solsum = 0
          bool = true
          resps = QuestionBase.vars_from_response( "sign" , params)
          puts "********\n" + resps.to_s + "********\n"
          (((resps) == "#{@person3}")or((resps) == "#{@person1}"))
        elsif @a==@c
          solsum = 0
          bool = true
          resps = QuestionBase.vars_from_response( "sign" , params)
          puts "********\n" + resps.to_s + "********\n"
          (((resps) == "#{@person3}")or((resps) == "#{@person2}"))  
        end
      elsif (@b<=@a)and(@b<=@c)
        if @a==@b
          solsum = 0
          bool = true
          resps = QuestionBase.vars_from_response( "sign" , params)
          puts "********\n" + resps.to_s + "********\n"
          (((resps) == "#{@person3}")or((resps) == "#{@person1}"))
        elsif @b==@c
          solsum = 0
          bool = true
          resps = QuestionBase.vars_from_response( "sign" , params)
          puts "********\n" + resps.to_s + "********\n"
          (((resps) == "#{@person1}")or((resps) == "#{@person2}"))  
        end
      elsif (@c<=@b)and(@c<=@a)
        if @a==@b
          solsum = 0
          bool = true
          resps = QuestionBase.vars_from_response( "sign" , params)
          puts "********\n" + resps.to_s + "********\n"
          (((resps) == "#{@person3}")or((resps) == "#{@person1}"))
        elsif @a==@c
          solsum = 0
          bool = true
          resps = QuestionBase.vars_from_response( "sign" , params)
          puts "********\n" + resps.to_s + "********\n"
          (((resps) == "#{@person3}")or((resps) == "#{@person2}"))  
        end
      end
    end

    def text
      [
        TextLabel.new("#{@person1} had #{@g} #{@item}, #{@person2} had #{@h} #{@item} and #{@person3} had #{@i} #{@item}. After 4 months, #{@person1} used up #{@d} #{@item}, #{@person2} used up #{@e} #{@item} and #{@person3} used up #{@f} #{@item}. Who used up the greatest fraction of her/his #{@item}?. Also specify the largest fraction used in the lowest form"),
        TextLabel.new("Largest fraction of #{@item} used = "),
        Fraction.new("num", "den"),
      
        TextLabel.new("The largest fraction of #{@item} was used by"),
        Dropdown.new("sign", "#{@person1}", "#{@person2}","#{@person3}","Equal")
      ]
    end

   def explain
     if (@a==@b)and(@b==@c)
        [ 
          SubLabel.new("The fraction used all three of them is 1/#{@a}")
        ]
      elsif (@a<=@b)and(@a<=@c)
        [ 
          SubLabel.new("#{@person3} used the largest fraction equal to 1/#{@a}")
        ]
      elsif (@b<=@a)and(@b<=@c)
        [ 
          SubLabel.new("#{@person1} used the largest fraction equal to 1/#{@b}")
        ]
      elsif (@c<=@b)and(@c<=@a)
        [ 
          SubLabel.new("#{@person2} used the largest fraction equal to 1/#{@c}")
        ] 
      end
    end
  end

  
  class Try5_3 < QuestionWithExplanation
    def self.type
      "Which is Larger?"
    end
    def initialize
      @person1 , @person2 = Names.generate(2)
      @activity = ACTIVITIES.sample
      dens=Grade6ops.chCommPF
      @dens1=dens[0]
      @den1=@dens1.reduce(:*)
      @dens2=dens[1]
      @den2=@dens2.reduce(:*)
      @comm=dens[2]
      @num1=rand(@den1-1)+1
      @num2=rand(@den2-1)+1
    end
    def solve
      return {"ans" => "Equal"} if Rational(@num1, @den1)==Rational(@num2, @den2)
      return {"ans" => "#{@person2}"} if Rational(@num1, @den1)<Rational(@num2, @den2)  
      return {"ans" => "#{@person1}"} if Rational(@num1, @den1)>Rational(@num2, @den2)  
    end
    def explain
      hcf=Grade6ops::euclideanalg(@den1,@den2)
      lcm=(@den1*@den2)/hcf
      [SubLabel.new("To compare two unlike fractions, we have to make them into like fractions. We do this by finding the LCM of the two denominators and making that the new denominator. Then, we have to appropriately scale up the numerators"),
        Chapter3::LCM.new(@dens1, @dens2, @comm),
        Chapter7::FillNumerator.new([@den1, lcm], [@num1, @num1*(lcm/@den1)], 1, 0),
        Chapter7::FillNumerator.new([@den2, lcm], [@num2, @num2*(lcm/@den2)], 1, 0),
        SubLabel.new("Now they are like fractions, which we can easily compare"),
        Chapter7::CompareLikeFrac.new(lcm, @num1*(lcm/@den1), @num2*(lcm/@den2))]
    end
    def text
      [ 
        InlineBlock.new(TextLabel.new("#{@person1} #{@activity} for"),Fraction.new(@num1,@den1),TextLabel.new("hours"), TextLabel.new("#{@person2} #{@activity} for"), Fraction.new(@num2, @den2),TextLabel.new("hours")),
        TextLabel.new("Who #{@activity} more?"),
         Dropdown.new("ans","Equal","#{@person1}","#{@person2}")
      ]
    end
  end

  class Try5_2 < QuestionWithExplanation
    def self.type
      "Try5_2"
    end
    def initialize
      @den1 = rand(50)+20
      @den2 = rand(50)+20 
      @num1 = rand(@den1)
      @num2 = rand(@den2)
    end
    def solve
      return {"ans" => "Equal"} if @num1*@den2==@num2*@den1
      return {"ans" => "A"} if  @num1*@den2>@num2*@den1
      return {"ans" => "B"} if @num1*@den2<@num2*@den1
    end
    def explain
      hcf=Grade6ops::euclideanalg(@den1,@den2)
      lcm=(@den1*@den2)/hcf
      [SubLabel.new("To compare two unlike fractions, we have to make them into like fractions. We do this by finding the LCM of the two denominators and making that the new denominator. Then, we have to appropriately scale up the numerators"),
        Chapter3::LCM.new(@dens1, @dens2, @comm),
        Chapter7::FillNumerator.new([@den1, lcm], [@num1, @num1*(lcm/@den1)], 1, 0),
        Chapter7::FillNumerator.new([@den2, lcm], [@num2, @num2*(lcm/@den2)], 1, 0),
        SubLabel.new("Now they are like fractions, which we can easily compare"),
        Chapter7::CompareLikeFrac.new(lcm, @num1*(lcm/@den1), @num2*(lcm/@den2))]
    end
    def text
      [ 
        TextLabel.new("In a class A of #{@den1} students, #{@num1} passed in first class; in another class B of #{@den2} students, #{@num2} passed in first class. In which class was a greater fraction of students getting first class?"),
        Dropdown.new("ans","Equal","A","B")
      ]
    end
  end

  class Try5_4 < QuestionWithExplanation
    def self.type
      "Fraction Remaining"
    end
    def initialize
      @person, @person2 = Names.generate(2)
      @choose=rand(2)
      @a = rand(3)+1
      @num = []
      @den = []
      @sig =[]
      @num[0] = (@a)*9
      @den[0] = @a*10
      @sig[0] = -1
      @sig[1] = -1
      @sig[2] = -1
      @num[1] =rand(5)+1
      @var = @num[0]-@num[1]-1
      @num[2] = rand(@var)+1
      @var = @var- @num[2]
      @num[3] = rand(@var)+1
      @den[1] = @a*10
      @den[2] = @a*10
      @den[3] = @a*10

    end
    def solve
       sol=Grade6ops::asfractions(@num,@den,@sig)
      {"num" => sol[:num],
        "den" => sol[:den]}
    end
    def explain
      if @choose==0
        [
          SubLabel.new("Subtract the lengths of the three pieces from the length of the wire to get the length of the last piece")
        ]
      else
        [
          SubLabel.new("Subtract the lengths of the distance covered by the three modes of transportation from the total distance to get the distance travelled on foot")
        ]
      end
      end
    def text
      if @choose==0
        [
          InlineBlock.new(TextLabel.new("A piece of wire"),Fraction.new(@num[0],@den[0]),TextLabel.new("metre long broke into 4 pieces. The lengths of the first three pieces were"),Fraction.new(@num[1],@den[1]),Fraction.new(@num[2],@den[2]),Fraction.new(@num[3],@den[3]), TextLabel.new("metres long. How long is the other piece? Express it in lowest fractional form.")),
          Fraction.new("num", "den")
        ]
      else
        [
          InlineBlock.new(TextLabel.new("#{@person}'s house is "),Fraction.new(@num[0],@den[0]),TextLabel.new("kilometers from the mall. #{@person} travelled the first"),Fraction.new(@num[1],@den[1]),TextLabel.new("kilometers by bus,"),Fraction.new(@num[2],@den[2]),TextLabel.new("kilometers by cab and"),Fraction.new(@num[3],@den[3]),TextLabel.new("kilometers by cycle. #{@person} walked for the remaining distance. How much did #{@person} walk? Express it in lowest fractional form.")),
          Fraction.new("num", "den")
        ]
      end
    end


  end

 
#   class Try5_5 < QuestionWithExplanation
#     def self.type
#       "Try5_5"
#     end
#     def initialize
#       @num = rand(100)+1
#       @den = rand(100)+1
#       @choose = rand(3)+2

#     end
#     def solve
#       blah =2
#       hsh={}
#       for i in 0...@choose
#           j = 2*i
#           k = j+1
#           hsh["ans#{j}"] = @num
#           hsh["ans#{k}"] = @den
#       end
#       hsh
#     end
    
#     def text

#         [
#           InlineBlock.new(TextLabel.new("Write #{@choose} fractions equivalent to the following fraction"),Fraction.new(@num,@den)),
#           # for i in 0...@choose
#           #     j = 2*1
#           #     k = j+1
#           #     TextLabel.new("blah")
#           #   Fraction.new("ans#{j}", "ans#{k}")
#           # end
# ]
#           @i = 0 
#           while @i<@choose do
#             # j = 2*1
#             # k = j+1
#             TextLabel.new("blah")
#             @i = @i+1
#           end
#         # ]
#     end
#     def correct?(params)
#       solsum = 0
#       bool = true
#       resps = QuestionBase.vars_from_response( *( (0...(2*choose-1)).map { |i| "ans#{i}" }), params)
#       hcf=[]
#       for i in 0...@choose
#               j = 2*1
#               k = j+1
#           hcf[i]=Grade6ops.euclideanalg(resps[j].to_i, resps[k].to_i)
#           if hcf[i]==0
#               hcf[i]=1
#           end
#       end
        
      
#       hcf2=Grade6ops.euclideanalg(@num, @den)
#       if hcf2==0
#         hcf2=1
#       end
#       puts "********\n" + resps.to_s + "********\n"
#       for i in 0...@choose
#               j = 2*1
#               k = j+1
#           bool=(((resps[j].to_i)/hcf[i]==@num/hcf2)and((resps[k].to_i)/hcf[i]==@den/hcf2))
#       end
      
#       bool
#     end
#   end

  

  # class Try5_6 < QuestionWithExplanation
  #   def self.type
  #     "Try5_6"
  #   end
  #   def initialize
  #     @num = rand(200)-100
  #     while @num==0
  #       @num = rand(200)-100 
  #     end
  #     @den = rand(100)+1
  #     @a = -1*@num
  #   end
  #   def solve
  #     {
  #       "ans1" => @a,
  #       "ans2" => @den
  #     }
  #   end
    
  #   def text
  #       [
  #         InlineBlock.new(TextLabel.new("Write the additive inverse of the following rational number"),Fraction.new(@num,@den)),
  #         Fraction.new("ans1", "ans2")
          
  #       ]
  #   end
  #   def explain
  #     [
  #       SubLabel.new("The additive inverse of a rational number is a rational number which when added to the rational number fraction results in zero. Therefore to find the answer simply reverse the sign")
  #     ]
  #   end
  #   def correct?(params)
  #     solsum = 0
  #     bool = true
  #     resps = QuestionBase.vars_from_response( *( (1...3).map { |i| "ans#{i}" }), params)
  #     hcf1=Grade6ops.euclideanalg(resps[0].to_i, resps[1].to_i)
  #         if hcf1==0
  #             hcf1=1
  #         end
  #     hcf2=Grade6ops.euclideanalg(@a, @den)
  #     if hcf2==0
  #       hcf2=1
  #     end
  #     puts "********\n" + resps.to_s + "********\n"
  #     (((resps[0].to_i)/hcf1==@a/hcf2)and((resps[1].to_i)/hcf1==@den/hcf2))
  #   end
  # end

  # class Try5_7 < QuestionWithExplanation
  #   def self.type
  #     "Try5_7"
  #   end
  #   def initialize
  #     @num = rand(200)-100
  #     while @num==0
  #       @num = rand(200)-100 
  #     end
  #     @den = rand(100)+1
     
  #   end
  #   def solve
  #     if @num<0
  #       {
  #         "ans1" => -1*@den,
  #         "ans2" => -1*@num
  #       }
  #     else
  #       {
  #         "ans1" => @den,
  #         "ans2" => @num
  #       }
  #     end
      
  #   end
    
  #   def text
  #       [
  #         InlineBlock.new(TextLabel.new("Write the multiplicative inverse/reciprocal of the following rational number"),Fraction.new(@num,@den)),
  #         Fraction.new("ans1", "ans2")
          
  #       ]
  #   end
  #   def explain
  #     [
  #       SubLabel.new("The multiplicative inverse of a rational number is a rational number which when multiplied to the original rational number results in one. Therefore to find the answer simply reverse the fraction")
  #     ]
  #   end
  #   def correct?(params)
  #     solsum = 0
  #     bool = true
  #     resps = QuestionBase.vars_from_response( *( (1...3).map { |i| "ans#{i}" }), params)
  #     hcf1=Grade6ops.euclideanalg((resps[0].to_i).abs, (resps[1].to_i).abs)
  #         if hcf1==0
  #             hcf1=1
  #         end
  #     hcf2=Grade6ops.euclideanalg(@num.abs, @den.abs)
  #     if hcf2==0
  #       hcf2=1
  #     end
  #     puts "********\n" + resps.to_s + "********\n"
  #     if @num<0
  #         bool=(((resps[1].to_i)/hcf1==-1*@num/hcf2)and((resps[0].to_i)/hcf1==-1*@den/hcf2))
  #     else
  #         bool=(((resps[1].to_i)/hcf1==@num/hcf2)and((resps[0].to_i)/hcf1==@den/hcf2))
  #     end
  #     bool
  #   end
  # end

  # class Try5_9 < QuestionWithExplanation
  #   def self.type
  #     "Try5_9"
  #   end
  #   def initialize
  #     @num = rand(200)-100
  #     while @num==0
  #       @num = rand(200)-100 
  #     end
  #     @den = rand(100)+1
  #     @num1 = rand(100)+1
  #     @den1 = rand(100)+1
  #   end
  #   def solve
  #       {
  #         "ans1" => @num*@num1,
  #         "ans2" => @den*@den1
  #       }
  #   end
    
  #   def text
  #       [
  #         InlineBlock.new(TextLabel.new("Write the product of the following rational numbers"),Fraction.new(@num,@den),Fraction.new(@num1,@den1)),
  #         Fraction.new("ans1", "ans2")
          
  #       ]
  #   end
  #   def explain
  #     [
  #       SubLabel.new("The product of two rational numbers is the same as the product of their numerators divided by the product of their denominators")
  #     ]
  #   end
  #   def correct?(params)
  #     solsum = 0
  #     bool = true
  #     resps = QuestionBase.vars_from_response( *( (1...3).map { |i| "ans#{i}" }), params)
  #     hcf1=Grade6ops.euclideanalg((resps[0].to_i).abs, (resps[1].to_i).abs)
  #         if hcf1==0
  #             hcf1=1
  #         end
  #     hcf2=Grade6ops.euclideanalg((@num*@num1).abs, (@den*@den1).abs)
  #     if hcf2==0
  #       hcf2=1
  #     end
  #     puts "********\n" + resps.to_s + "********\n"
  #     if
  #         bool=(((resps[0].to_i)/hcf1==@num*@num1/hcf2)and((resps[1].to_i)/hcf1==@den*@den1/hcf2))
  #     end
  #     bool
  #   end
  # end

  class Try5_16 < QuestionWithExplanation
    def self.type
      "Product of Fractions"
    end
    def initialize
      @num = rand(100)+1
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
          InlineBlock.new(TextLabel.new("Write the product of the following fractions"),Fraction.new(@num,@den),Fraction.new(@num1,@den1)),
          Fraction.new("ans1", "ans2")
          
        ]
    end
    def explain
      [
        SubLabel.new("The product of two fractions is the same as the product of their numerators divided by the product of their denominators")
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


  class Try5_14 < QuestionWithExplanation
    def self.type
      "Try5_14"
    end
    def initialize
      @person, @person2 = Names.generate(2)
      @num = rand(20)+1
      @den = rand(@num/2)+1
      @num1 = rand(20)+1
      @den1 = rand(20)+1
      @choose=rand(3)
    end
    def solve
        {
          "ans1" => @num*@num1,
          "ans2" => @den*@den1
        }
    end
    
    def text
      if @choose==0
        [
          InlineBlock.new(TextLabel.new("#{@person} reads"),Fraction.new(@num,@den),TextLabel.new("part of a book in an hour. How much part of the book will he read in "),Fraction.new(@num1,@den1),TextLabel.new("hours?")),
          Fraction.new("ans1", "ans2")
        ]
      elsif @choose==1
        [
          InlineBlock.new(TextLabel.new("#{@person} eats"),Fraction.new(@num,@den),TextLabel.new("part of a pie in an hour. How much part of the pie will he read in "),Fraction.new(@num1,@den1),TextLabel.new("hours?")),
          Fraction.new("ans1", "ans2")
        ]
      else
        [
          InlineBlock.new(TextLabel.new("#{@person} walks"),Fraction.new(@num,@den),TextLabel.new("kilometers in an hour. How many kilometers will he travel in "),Fraction.new(@num1,@den1),TextLabel.new("hours?")),
          Fraction.new("ans1", "ans2")
        ]   
      end
        
    end
    def explain
      [
        SubLabel.new("The product of two fractions is the same as the product of their numerators divided by the product of their denominators")
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

  class Try5_15 < QuestionWithExplanation
    def self.type
      "Fraction from Part"
    end
    def initialize
      @person, @person2 = Names.generate(2)
      @a = rand(5)+1
      @b = rand(10)+1
      @c = rand(5)+1
      @d = rand(5)+1
      @num = @a*@b
      @den = @c
      @num1 = @a
      @den1 = @c*@d
      @choose=rand(2)
    end
    def solve
      if @choose==0
        {
          "ans1" =>@b*@c*@d
        }
      else
        {
          "ans1" =>@b*@d
        }
      end
    end
    
    def text
      if @choose==0
        [
          InlineBlock.new(TextLabel.new("#{@person} cuts a strip of length #{@num}cm into smaller strips of length"),Fraction.new(@num1,@den1),TextLabel.new("How many strips will he get now?")),
          TextField.new("ans1")
        ]
      elsif @choose==1
        [
          InlineBlock.new(TextLabel.new("#{@person} cuts a strip of length"),Fraction.new("@num,@den"),TextLabel.new("cm into smaller strips of length"),Fraction.new(@num1,@den1),TextLabel.new("How many strips will he get now?")),
          TextField.new("ans1")
        ]   
      end
    end
    def explain
      [
        SubLabel.new("The product of two fractions is the same as the product of their numerators divided by the product of their denominators")
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

  # class Try5_10 < QuestionWithExplanation
  #   def self.type
  #     "Try5_10"
  #   end
  #   def initialize
  #     @num = rand(20)-10
  #     while @num==0
  #       @num = rand(20)-10 
  #     end
  #     @den = rand(10)+1
  #     @num1 = rand(10)+1
     
  #   end
  #   def solve
  #       {
  #         "ans1" => @num*@num1,
  #         "ans2" => @den
  #       }
  #   end
    
  #   def text
  #       [
  #         InlineBlock.new(TextLabel.new("Write the product of the following "),Fraction.new(@num,@den),TextLabel.new("and #{@num1}")),
  #         Fraction.new("ans1", "ans2")
          
  #       ]
  #   end
  #   def explain
  #     [
  #       SubLabel.new("The product of a rational number with a whole number is the same as the product of the numerator with that whole number divided by the denominator")
  #     ]
  #   end
  #   def correct?(params)
  #     solsum = 0
  #     bool = true
  #     resps = QuestionBase.vars_from_response( *( (1...3).map { |i| "ans#{i}" }), params)
  #     hcf1=Grade6ops.euclideanalg((resps[0].to_i).abs, (resps[1].to_i).abs)
  #         if hcf1==0
  #             hcf1=1
  #         end
  #     hcf2=Grade6ops.euclideanalg((@num*@num1).abs, (@den).abs)
  #     if hcf2==0
  #       hcf2=1
  #     end
  #     puts "********\n" + resps.to_s + "********\n"
  #     if
  #         bool=(((resps[0].to_i)/hcf1==@num*@num1/hcf2)and((resps[1].to_i)/hcf1==@den/hcf2))
  #     end
  #     bool
  #   end
  # end

  class Try5_17 < QuestionWithExplanation
    def self.type
      "Product of Fraction and Whole Number"
    end
    def initialize
      @num = rand(10)+1
      
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
        SubLabel.new("The product of a fraction with a whole number is the same as the product of the numerator with that whole number divided by the denominator")
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

  # class Try5_12 < QuestionWithExplanation
  #   def self.type
  #     "Try5_12"
  #   end
  #   def initialize
  #     @num = rand(200)-100
  #     while @num==0 do
  #       @num = rand(200)-100
  #     end
  #     @den = rand(100)+1
  #   end
  #   def solve
  #     {
  #       "ans1" => @num,
  #       "ans2" => @den
  #     }
  #   end
    
  #   def text
  #       [
  #         InlineBlock.new(TextLabel.new("Write a rational number equivalent to the following fraction"),Fraction.new(@num,@den)),
  #         Fraction.new("ans1", "ans2")
  #       ]
  #   end
  #   def correct?(params)
  #     solsum = 0
  #       bool = true
  #       resps = QuestionBase.vars_from_response( *( (1...3).map { |i| "ans#{i}" }), params)
  #       hcf1=Grade6ops.euclideanalg((resps[0].to_i).abs, (resps[1].to_i).abs)
  #         if hcf1==0
  #             hcf1=1
  #         end
  #       hcf2=Grade6ops.euclideanalg((@num).abs, (@den).abs)
  #       if hcf2==0
  #         hcf2=1
  #       end
  #       puts "********\n" + resps.to_s + "********\n"
  #       if
  #         bool=(((resps[0].to_i)/hcf1==@num/hcf2)and((resps[1].to_i)/hcf1==@den/hcf2))
  #       end
  #       bool 
  #   end
  #   def explain
  #     [
  #       SubLabel.new("By multiplying the numerator and denominator of a rational number by the same non zero integer, we obtain another rational number equivalent to the given rational number. This is exactly like obtaining equivalent fractions")
  #     ]
  #   end
  # end

  class Try5_18 < QuestionWithExplanation
    def self.type
      "Find Equivalent Fraction"
    end
    def initialize
      @num = rand(100)+1
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
          InlineBlock.new(TextLabel.new("Write a fraction equivalent to the following fraction"),Fraction.new(@num,@den)),
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
        SubLabel.new("By multiplying the numerator and denominator of a fraction by the same non zero integer, we obtain another rational number equivalent to the given rational number. This is exactly like obtaining equivalent fractions")
      ]
    end
  end

  # class Try5_13 < QuestionWithExplanation
  #   def self.type
  #     "Try5_13"
  #   end
  #   def initialize
  #     @choose=0
  #     @num1 = rand(200)-100
  #     if @num1==0
  #       @num1 = rand(200)-100
  #     end
  #     @den1 = rand(100)+1
  #     @num2 = rand(200)-100
  #     if @num2==0
  #       @num2 = rand(200)-100
  #     end
  #     @den2 = rand(100)+1
  #     if((@num1*@den2)<(@num2*@den1))
  #       else
  #         @choose=1
  #     end
  #   end
  #   def solve
  #     if @choose==0
  #       {
  #       "ans1" => @num1+1,
  #       "ans2" => @den1
  #       }
  #     elsif @choose==1
  #       {
  #         "ans1" => @num2+1,
  #         "ans2" => @den2
  #       }
  #     end
      
  #   end
    
  #   def text
  #       [
  #         InlineBlock.new(TextLabel.new("Write a rational number between "),Fraction.new(@num1,@den1), TextLabel.new("and"), Fraction.new(@num2,@den2)),
  #         Fraction.new("ans1", "ans2")
  #       ]
  #   end
  #   def correct?(params)
  #     solsum = 0
  #       bool = true
  #       resps = QuestionBase.vars_from_response( *( (1...3).map { |i| "ans#{i}" }), params)
  #       puts "********\n" + resps.to_s + "********\n"
  #       if @choose==0
  #         bool=(((resps[0].to_i)*@den1>@num1*(resps[1].to_i))and((resps[0].to_i)*@den2<@num2*(resps[1].to_i)))
  #       elsif @choose==1
  #         bool=(((resps[0].to_i)*@den2>@num2*(resps[1].to_i))and((resps[0].to_i)*@den1<@num1*(resps[1].to_i)))
  #       end
  #       bool 
  #   end
  #   def explain
  #     [
  #       SubLabel.new("By multiplying the numerator and denominator of a rational number by the same non zero integer, we obtain another rational number equivalent to the given rational number. This is exactly like obtaining equivalent fractions")
  #     ]
  #   end
  # end

  class Try5_19 < QuestionWithExplanation
    def self.type
      "Fraction Between"
    end
    def initialize
      @choose=0
      @num1 = rand(100)+1
      @den1 = rand(100)+1
      @num2 = rand(100)+1
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
          InlineBlock.new(TextLabel.new("Write a fraction between "),Fraction.new(@num1,@den1), TextLabel.new("and"), Fraction.new(@num2,@den2)),
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
        SubLabel.new("By multiplying the numerator and denominator of a fraction by the same non zero integer, we obtain another fraction equivalent to the given rational number.")
      ]
    end
  end

  # class Try5_11 < QuestionWithExplanation
  #   def self.type
  #     "Try5_11"
  #   end
  #   def initialize
  #     @num = rand(20)-10
  #     while @num==0
  #       @num = rand(20)-10 
  #     end
  #     @den = rand(10)+1
  #     @num1 = rand(10)+1
  #     @den1 = rand(10)+1
  #     @choose = rand(3)
  #   end
  #   def solve
  #     if @choose===0
  #       {
  #         "ans1" => @num*@den1,
  #         "ans2" => @den*@num1
  #       }
  #     elsif @choose==1
  #       {
  #         "ans1" => @num,
  #         "ans2" => @den*@num1
  #       }
  #     else
  #       if @num>0
  #        {
  #         "ans2" => @num,
  #         "ans1" => @den*@num1
  #         }
  #       else
  #       {
  #         "ans2" => -1*@num,
  #         "ans1" => -1*@den*@num1
  #       } 
  #       end
  #     end
  #   end
  #   def text
  #     if @choose==0
  #       [
  #         InlineBlock.new(TextLabel.new("Divide the first rational number by the second"),Fraction.new(@num,@den),TextLabel.new(","),Fraction.new(@num1,@den1)),
  #         Fraction.new("ans1", "ans2")
  #       ]
  #     elsif @choose==1
  #       [
  #         InlineBlock.new(TextLabel.new("Divide the rational number "),Fraction.new(@num,@den),TextLabel.new("by the number"),TextLabel.new(@num1)),
  #         Fraction.new("ans1", "ans2")
  #       ] 
  #     else
  #       [
  #         InlineBlock.new(TextLabel.new("Divide the the given number"),TextLabel.new(@num1),TextLabel.new(" by the rational number"),Fraction.new(@num,@den)),
  #         Fraction.new("ans1", "ans2")
  #       ]  
  #     end
  #   end
  #   def explain
  #     if @choose==0
  #       [
  #         SubLabel.new("The division of one rational number by another is the same as the product of the first rational number with reciprocal of the second fraction")
  #       ]
  #     elsif @choose==1
  #       [
  #         SubLabel.new("The division of a rational number by a whole number is the same as the multiplication of the whole number in the denominator")
  #       ]
  #     else
  #       [
  #         SubLabel.new("The division of a whole number by a rational number is the same as the multiplication of the whole number with the denominator divided by the numerator")
  #       ]
  #     end
  #   end
  #   def correct?(params)
  #     if @choose==1
  #       solsum = 0
  #       bool = true
  #       resps = QuestionBase.vars_from_response( *( (1...3).map { |i| "ans#{i}" }), params)
  #       hcf1=Grade6ops.euclideanalg((resps[0].to_i).abs, (resps[1].to_i).abs)
  #         if hcf1==0
  #             hcf1=1
  #         end
  #       hcf2=Grade6ops.euclideanalg((@num*@den1).abs, (@den*@num1).abs)
  #       if hcf2==0
  #         hcf2=1
  #       end
  #       puts "********\n" + resps.to_s + "********\n"
  #       if
  #         bool=(((resps[0].to_i)/hcf1==@num*@den1/hcf2)and((resps[1].to_i)/hcf1==@den*@num1/hcf2))
  #       end
  #       bool 
  #     elsif @choose==1
  #       solsum = 0
  #       bool = true
  #       resps = QuestionBase.vars_from_response( *( (1...3).map { |i| "ans#{i}" }), params)
  #       hcf1=Grade6ops.euclideanalg((resps[0].to_i).abs, (resps[1].to_i).abs)
  #         if hcf1==0
  #             hcf1=1
  #         end
  #       hcf2=Grade6ops.euclideanalg((@num).abs, (@den*@num1).abs)
  #       if hcf2==0
  #         hcf2=1
  #       end
  #       puts "********\n" + resps.to_s + "********\n"
  #       if
  #         bool=(((resps[0].to_i)/hcf1==@num/hcf2)and((resps[1].to_i)/hcf1==@den*@num1/hcf2))
  #       end
  #       bool  
  #     else
  #       solsum = 0
  #       bool = true
  #       resps = QuestionBase.vars_from_response( *( (1...3).map { |i| "ans#{i}" }), params)
  #       hcf1=Grade6ops.euclideanalg((resps[0].to_i).abs, (resps[1].to_i).abs)
  #         if hcf1==0
  #             hcf1=1
  #         end
  #       hcf2=Grade6ops.euclideanalg((@num).abs, (@den*@num1).abs)
  #       if hcf2==0
  #       hcf2=1
  #       end
  #       puts "********\n" + resps.to_s + "********\n"
  #       if @num>0
  #         bool=(((resps[1].to_i)/hcf1==@num/hcf2)and((resps[0].to_i)/hcf1==@den*@num1/hcf2))
  #       else
  #         bool=(((resps[1].to_i)/hcf1==-1*@num/hcf2)and((resps[0].to_i)/hcf1==-1*@den*@num1/hcf2))
  #       end
  #       bool  
  #     end
  #   end
  # end

  # class Try5_21 < QuestionWithExplanation
  #   def self.type
  #     "Try5_21"
  #   end
  #   def initialize
  #     @num1 = rand(5)-2
  #     @den1 = rand(5)-2 
  #   end
  #   def solve
  #     return {"ans" => "No"} if @den1==0
  #     return {"ans" => "Yes"} if @den1!=0
  #   end
  #   def explain
  #     hcf=Grade6ops::euclideanalg(@den1,@den2)
  #     lcm=(@den1*@den2)/hcf
  #     [SubLabel.new("To compare two unlike fractions, we have to make them into like fractions. We do this by finding the LCM of the two denominators and making that the new denominator. Then, we have to appropriately scale up the numerators"),
  #       Chapter3::LCM.new(@dens1, @dens2, @comm),
  #       Chapter7::FillNumerator.new([@den1, lcm], [@num1, @num1*(lcm/@den1)], 1, 0),
  #       Chapter7::FillNumerator.new([@den2, lcm], [@num2, @num2*(lcm/@den2)], 1, 0),
  #       SubLabel.new("Now they are like fractions, which we can easily compare"),
  #       Chapter7::CompareLikeFrac.new(lcm, @num1*(lcm/@den1), @num2*(lcm/@den2))]
  #   end
  #   def text
  #     [ 
  #       TextLabel.new("Is the following number a rational number?")
  #       Fraction.new(@num1,@den1)
  #       Dropdown.new("ans","Equal","A","B")
  #     ]
  #   end
  # end

  # class Try5_22 < QuestionBase
  #   def self.type
  #     "Try5_22"
  #   end
  #   def initialize(num=nil, den=nil)
  #     if num!=nil
  #       @num=num
  #       @den=den
  #     else
  #       @num = rand(200)-100
  #       while @num==100 do
  #         @num = rand(200)-100
  #       end
  #       @den = rand(100)+1
  #     end
  #   end
  #   def solve
  #     hcf=Grade6ops.euclideanalg(@num.abs, @den)
  #     {"num" => @num/hcf,
  #       "den" => @den/hcf}
  #   end
  #   def explain
  #     hcf=Grade6ops.euclideanalg(@num.abs, @den)
  #     [Chapter3::HCFEA.new(@num, @den),
  #       PreG6::Division.new(hcf, @num, true),
  #       PreG6::Division.new(hcf, @den, true)]
  #   end
  #   def text
  #     [TextLabel.new("Reduce the following rational number to its lowest form:"), InlineBlock.new(Fraction.new(@num, @den), TextLabel.new(" = "), Fraction.new("num", "den"))]
  #   end
  # end

#    class Try5_23 < QuestionWithExplanation
#     def self.type
#       "Operations on Rational numbers"
#     end
#     def initialize(den=nil, nums=nil, sig=nil)
#       if den!=nil
#         @den=[]
#         for i in 0...nums.length
#           @den[i]=den
#         end
#         @num=nums
#         @sig=sig
#       else
#         amt=rand(3)+2
#         de=rand(25)+3
#         @den=[]
#         @num=[]
#         @sig=[]
#         for i in 0...amt
#           @den[i]=de
#           @num[i]=(rand(@den[i]/amt)+1).to_i
#           if i>0
#             @sig[i-1]=rand(2)
#             @sig[i-1]=-1 if @sig[i-1]==0
#           end
#         end
# #        puts @num.to_s
# #        puts @den.to_s
# #        puts @sig.to_s
#         sol=Grade6ops::asfractions(@num,@den,@sig)
#         if sol[:num]<0
#           @num << -1*sol[:num]+rand(de-2)+1
#           @den << de
#           @sig << 1
#         end
#       end
#     end
#     def solve
#       sol=Grade6ops::asfractions(@num,@den,@sig)
#       {"num" => sol[:num],
#         "den" => sol[:den]}
#     end
#     def explain
#       signs=[]
#       for i in 0...@num.length
#         signs[i]=1
#       end
#       [SubLabel.new("To perform addition and subtraction on like fractions, ignore the denominators and perform the given operations on the numerators"),
#         Chapter6::AddSubIntegers.new(@num, signs, [1] + @sig),
#         Subproblem.new([TextLabel.new("Now add back in the denominator"), Fraction.new(@num.reduce(:+), "den")], {"den" => @den[0]}),
#         Subproblem.new([TextLabel.new("Hence the fraction in its lowest form is:"), Fraction.new(@num.reduce(:+), @den[0])],{})]
#     end
#     def text
#       stro= [TextLabel.new("Compute the following and reduce to its lowest form:")] 
#       str= [Fraction.new(@num[0], @den[0])]
#       for i in 0...@sig.length
#         if @sig[i]==1
#           str << TextLabel.new('+')
#           str << Fraction.new(@num[i+1], @den[i+1])
#         else
#           str << TextLabel.new('-')
#           str << Fraction.new(@num[i+1], @den[i+1])
#         end
#       end
#       str << TextLabel.new("=")
#       str << Fraction.new("num","den")
#       stro << InlineBlock.new(str)
#       stro
#     end
#   end


  class Try5_20 < QuestionWithExplanation
    def self.type
      "Divide Fractions"
    end
    def initialize
      @num = rand(10)+1
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
          InlineBlock.new(TextLabel.new("Divide the first fraction by the second"),Fraction.new(@num,@den),TextLabel.new(","),Fraction.new(@num1,@den1)),
          Fraction.new("ans1", "ans2")
        ]
      elsif @choose==1
        [
          InlineBlock.new(TextLabel.new("Divide the fraction "),Fraction.new(@num,@den),TextLabel.new("by the number"),TextLabel.new(@num1)),
          Fraction.new("ans1", "ans2")
        ] 
      else
        [
          InlineBlock.new(TextLabel.new("Divide the the given number"),TextLabel.new(@num1),TextLabel.new(" by the fraction"),Fraction.new(@num,@den)),
          Fraction.new("ans1", "ans2")
        ]  
      end
    end
    def explain
      if @choose==0
        [
          SubLabel.new("The division of one fraction by another is the same as the product of the first rational number with reciprocal of the second fraction")
        ]
      elsif @choose==1
        [
          SubLabel.new("The division of a fraction by a whole number is the same as the multiplication of the whole number in the denominator")
        ]
      else
        [
          SubLabel.new("The division of a whole number by a fraction is the same as the multiplication of the whole number with the denominator divided by the numerator")
        ]
      end
    end
    def correct?(params)
      if @choose==1
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


  PROBLEMS=[
    Chapter7::ToMixedFractions, 
    Chapter7::ToImproperFractions,
    Chapter7::ReduceFractions,
    Chapter7::EquivalentFractions,
    Chapter7::FillNumerator,
    Chapter7::FillDenominator,
    Chapter7::CompareLikeFrac,
    Chapter7::CompareUnlikeFrac,
    Chapter7::ASLikeFractions,
    Chapter7::ASUnlikeFractions,
    Chapter7::ASMixedFractions,
    Chapter7::Try5_1,
    Chapter7::Try5_3,
    #Chapter7::Try5_2,
    Chapter7::Try5_4,
    # Chapter7::Try5_5,
    # Chapter7::Try5_6,
    # Chapter7::Try5_7,
    # Chapter7::Try5_9,
    # Chapter7::Try5_10,
    # Chapter7::Try5_11,
    # Chapter7::Try5_12,
    # Chapter7::Try5_13,
    Chapter7::Try5_14,
    Chapter7::Try5_15,
    Chapter7::Try5_16,
    Chapter7::Try5_17,
    Chapter7::Try5_18,
    Chapter7::Try5_19,
    Chapter7::Try5_20

  ]
end
