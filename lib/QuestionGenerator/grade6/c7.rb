
#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml.rb' 
require_relative './preg6'
include PreG6
include ToHTML

module Chapter7

  #TODO Fraction Formatting

  class ToMixedFractions < QuestionWithExplanation
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
      [SubLabel.new("To convert a fraction to a mixed fraction, first divide the numerator by the denominator and get the Quotient and Remainder. The quotient is the integer part, the remainder is the denominator and the denominator remains the same"), PreG6::Division.new(@den, @num),
        Subproblem.new([TextLabel.new("Since the quotient is #{@num/@den} and the remainder is #{@num-(@num/@den)*@den}, the fraction in mixed form is:"), Fraction.new("num", "den", "intpart")], {"num" => sol["num"], "den" => sol["den"], "intpart" => sol["intpart"]})]  
    end
    def  text
      [TextLabel.new("Convert the following into a mixed fraction"), Fraction.new(@num,@den), Fraction.new("num", "den", "intpart")]
    end
  end

  class ToImproperFractions < QuestionWithExplanation
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
      [TextLabel.new("Convert the following into an improper fraction"), Fraction.new(remainder, @den, intpart), Fraction.new("num", "den")]
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
      [TextLabel.new("Reduce the following fraction to its lowest form:"), Fraction.new(@num, @den), Fraction.new("num", "den")]
    end
  end

  class ReduceFractions < QuestionWithExplanation
    def initialize(nums1=nil, nums2=nil, comm=nil)
      if (nums1!=nil && nums2!=nil && comm!=nil)
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
        Subproblem.new([TextLabel.new("Hence, the fraction in its lowest form is:"), Fraction.new("num", "den")], solve)]
    end
    def text
      [TextLabel.new("Reduce the following fraction to its lowest form"), Fraction.new(@nums1.reduce(:*), @nums2.reduce(:*)), Fraction.new("num", "den")]
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
      [TextLabel.new("Are the following equivalent?"), Fraction.new(@num1.reduce(:*), @den1.reduce(:*)), Dropdown.new("ans", '=', SYMBOL[:notequals]) , Fraction.new(@num2.reduce(:*),@den2.reduce(:*))] 
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
      str=[]
      str << TextLabel.new("Fill in the Numerator:")
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
      str
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
      str << TextLabel.new("Fill in the Denominator:")
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
      str
    end  
  end

  class CompareLikeFrac < QuestionBase
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
        Subproblem.new([TextLabel.new("Since the First numerator, #{@num1}, #{solve["ans"]} Second numerator, #{@num2}, place the appropriate symbol:"), Fraction.new(@num1,@den), Dropdown.new("ans", "=", "<", ">"), Fraction.new(@num2, @den)], {"ans" => solve["ans"]})]  
    end
    def text
      [TextLabel.new("Place the appropriate symbol:"), Fraction.new(@num1, @den), Dropdown.new("ans", '=', '<', '>'), Fraction.new(@num2, @den)]
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
      [TextLabel.new("Place the appropriate symbol:"), Fraction.new(@num1,@den1), Dropdown.new("ans",'=','<','>'), Fraction.new(@num2, @den2)]
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
        Subproblem.new([TextLabel.new("Now add back in the denominator, #{@den}"), Fraction.new(@num.reduce(:+), "den")], {"den" => @den[0]}),
        Chapter7::ReduceFractionsEA.new(@num.reduce(:+), @den)]
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

  PROBLEMS=[Chapter7::ToMixedFractions, Chapter7::ToImproperFractions, Chapter7::EquivalentFractions, Chapter7::ReduceFractions, Chapter7::FillNumerator, Chapter7::FillDenominator, Chapter7::CompareLikeFrac, Chapter7::CompareUnlikeFrac, Chapter7::ASLikeFractions, Chapter7::ASUnlikeFractions, Chapter7::ASMixedFractions]

end


