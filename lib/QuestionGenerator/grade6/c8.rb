
#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml.rb' 
include ToHTML
include Grade6ops

module Chapter8

  NPVALUE=["Tenths", "Hundredths", "Thousandths", "Ten Thousandths"]
  PPVALUE=["Ones", "Tens", "Hundreds", "Thousands"]
  POS={"Tenths" => PPVALUE.length, "Hundredths" => PPVALUE.length+1, "Thousandths" => PPVALUE.length+2, "Ten Thousandths" => PPVALUE.length+3, "Thousands" => PPVALUE.length-PPVALUE.index("Thousands")-1, "Hundreds" => PPVALUE.length-PPVALUE.index("Hundreds")-1, "Tens" => PPVALUE.length-PPVALUE.index("Tens")-1,"Ones" => PPVALUE.length-PPVALUE.index("Ones")-1}


  class DecSigDigits < QuestionBase
    def initialize(num=nil, sig=nil)
      if num!=nil
        @num=num
        @sig=sig
      else
        @num=10
        while @num % 10 == 0
          @num=rand(10000)
        end
        @sig=rand(5)
      end
      @ze=rand(2)
    end
    def explain
      [SubLabel.new("The digits in a number are called significant digits apart from leading zeroes before the number or trailing 0s after the decimal point. Hence both 0234.0450, 234532 and 0456.5040 have 6 significant digits. To count the significant digits after the decimal point, start from the decimal point and count towards the end. However, remember to exclude any trailing 0s.")]
    end
    def solve 
      {"ans" => @sig}
    end
    def text
      [TextLabel.new("How many significant digits are there after the decimal point in #{@num.to_f/10**@sig}#{"0"*@ze}"), TextField.new("ans")]
    end
  end

  class MaxDecSigDigits < QuestionWithExplanation
    def initialize(nums=nil, sigs=nil)
      if nums!=nil
        @nums=nums
        @sigs=sigs
      else
        @nums=[]
        @sigs=[]
        for i in 0...5
          @nums[i]=10
          @sigs[i]=rand(5)+1
          while @nums[i] % 10 == 0
            @nums[i]=rand(10000)
          end
        end
      end
    end
    def solve
      {"ans" => @sigs.max}
    end
    def explain
      ret=[SubLabel.new("First, find the number of digits after the decimal point for each of the numbers")]
      for i in 0...@nums.length
        ret << Chapter8::DecSigDigits.new(@nums[i], @sigs[i])
      end
      ret << SubLabel.new("Now, find the largest of these numbers")
      ret << Chapter1::FindMaxNumber.new(@sigs)
    end
    def text
      nms=[]
      for i in 0...@nums.length
        nms[i]=Rational(@nums[i], 10**@sigs[i]).to_f
      end
      [TextLabel.new("What is the largest number of digits after the decimal point in the following list of numbers: #{nms.join(", ")}"), TextField.new("ans")]
    end
  end

  class PlaceValueTable < QuestionBase
    def initialize
      @num=10
      while @num % 10==0
        @num=(rand(10000).to_f + 100)
      end
      @div=rand(3)+1
      @num=@num.to_f/(10**@div)
    end

    def solve
      posdot=@num.to_s.index('.')
      i=posdot-1
      pp={}
      np={}
      while i>=0
        pp["ans_"+PPVALUE[posdot-i-1].to_s] = @num.to_s[i]
        i-=1
      end
      i=posdot
      for j in i...(@num.to_s.length-1)
        np["ans_"+ NPVALUE[j-i].to_s ] = @num.to_s[j+1]
      end
      @pp=pp
      @np=np
      ret=pp.merge(np)
      ret
    end   
    
    def preprocess(name, response)
      if response =~ /^[0-9, ]+$/
        return response.to_i.to_s
      end
     # return "invalid"
    end


    def text
      solve
      ret=[TextLabel.new("Write the following in the place value table"), TextLabel.new(@num.to_s)]
      tab=TableField.new("ans", 2, PPVALUE.length)
      tab2=TableField.new("ans", 2, NPVALUE.length)
      for i in 0...PPVALUE.length
        tab.set_field(0, i, TextLabel.new(PPVALUE[PPVALUE.length-i-1]))
      end

      for i in 0...NPVALUE.length
        tab2.set_field(0, i, TextLabel.new(NPVALUE[i]))
      end
      for i in 0...(PPVALUE.length)
        tab.set_field(1, PPVALUE.length-1-i, TextField.new("ans_"+PPVALUE[i]))
      end
      for i in 0...NPVALUE.length
        tab2.set_field(1, i, TextField.new("ans_"+NPVALUE[i]))
      end
      ret << tab
      ret << tab2
      ret
    end

  end

  class DecimalsToFractions < QuestionWithExplanation
    def self.type
      "Convert Decimal to Fraction"
    end

    def initialize
      @num=10
      while @num % 10==0
        @num=(rand(10000) + 100)
      end
      puts @num
      @div=rand(3)+1
    end
    def solve
      intpart=@num/(10**@div)
      puts rem=(@num-intpart*(10**@div))
      hcf=Grade6ops::euclideanalg(rem , 10**@div)
      { "intpart" => intpart.to_s,
        "num" => (rem/hcf).to_s,
        "den" => ((10**@div)/hcf).to_s}
    end
    def explain
      rat=Rational(@num,10**@div).to_f
      rem=(@num-(@num/(10**@div))*(10**@div))
      orat=rem.to_f/(10**@div)
        [Subproblem.new([TextLabel.new("The integer part of the fraction is the part to the left of the decimal point."), TextField.new("intpart", "Integer Part")], {"intpart" => solve["intpart"]}),
          Chapter8::DecSigDigits.new(@num, @div),
        Subproblem.new([TextLabel.new("Now multiply the decimal part of the number, #{orat} by 1 followed #{@div} zeroes. This is the numerator. 1 followed by #{@div} zeros is the denominator. Fill this in"), Fraction.new("num", "den")], {"num" => rem, "den" => 10**@div}),
        Chapter7::ReduceFractionsEA.new(@num, 10**@div),
        Subproblem.new([TextLabel.new("Hence the decimal in the form of a mixed fraction is:"), Fraction.new("num", "den", "intpart")], solve)]
    end
    def text
      ret=[TextLabel.new("Convert the following Decimal into a Mixed Fraction in its lowest form:"), TextLabel.new(Rational(@num, 10**@div).to_f.to_s), Fraction.new("num", "den", "intpart")]
    end
  end  

  class FractionsToDecimals < QuestionBase
    def self.type
      "Convert Fraction to Decimal"
    end
    def initialize
      @num=10
      while@num % 10 == 0
        @num=(rand(10000).to_f + 100)
      end
      @div=rand(3)+1
      @num=@num/(10**@div)
    end
    def solve
      {"ans" => @num.to_s}
    end
    def text
      nu=(@num*(10**@div)).to_i
      intpart=((nu/(10**@div))*(10**@div))
      rem=nu-intpart      
      hcf=Grade6ops::euclideanalg(10**@div,rem)
      [TextLabel.new("Convert the following Fraction into a Decimal:"), Fraction.new(rem/hcf,(10**@div)/hcf, intpart/(10**@div)), TextField.new("ans")]
    end
  end  
  SUNIT=["mm", "grams", "ml", "cm", "meters", "paise"]
  LUNIT=["cm", "kg", "liter", "meters", "km", "rupees"]
  UCON={"mm" => 10,
    "grams" => 1000,
    "ml" => 1000,
    "cm" => 100,
    "meters" => 1000,
    "paise" => 100}

  class UnitsDecIncrease < QuestionWithExplanation
    def self.type
      "Convert Units 1"
    end
    def initialize
      @wh=rand(SUNIT.length-1)+1
      @num=rand(UCON[SUNIT[@wh]]*100)
    end
    def solve
      {"ans" => (@num.to_f)/(UCON[SUNIT[@wh]])}
    end
    def explain
      [Subproblem.new([TextLabel.new("How many #{SUNIT[@wh]} are there in a #{LUNIT[@wh]}?"), TextField.new("mul", SUNIT[@wh])], {"mul" => UCON[SUNIT[@wh]]}), 
        Subproblem.new([TextLabel.new("Divide #{@num} #{SUNIT[@wh]} by #{UCON[SUNIT[@wh]]} to get the answer."), TextField.new("lun", LUNIT[@wh])], {"lun" => solve["ans"]})]
    end
    def text
      [TextLabel.new("Convert #{@num} #{SUNIT[@wh]} to #{LUNIT[@wh]}"), TextField.new("ans", LUNIT[@wh])]
    end
  end
  class UnitsDecDecrease < QuestionWithExplanation
    def self.type
      "Convert Units 2"
    end
    def initialize
      @wh=rand(LUNIT.length-1)+1
      @num=rand(UCON[SUNIT[@wh]] * 100)
      @num=@num.to_f/100

    end
    def solve
      ans=(@num)*(UCON[SUNIT[@wh]])
      ans=ans.to_i if ans.to_i.to_f==ans
      {"ans" => ans}
    end
    def explain
      [Subproblem.new([TextLabel.new("How many #{SUNIT[@wh]} are there in a #{LUNIT[@wh]}?"), TextField.new("mul",SUNIT[@wh] )], {"mul" => UCON[SUNIT[@wh]]}),
        Subproblem.new([TextLabel.new("Multiply #{@num} #{LUNIT[@wh]} by #{UCON[SUNIT[@wh]]} to get the answer."), TextField.new("sun", SUNIT[@wh])], {"sun" => solve["ans"]})]
    end
    def text
      [TextLabel.new("Convert #{@num} #{LUNIT[@wh]} to #{SUNIT[@wh]}"), TextField.new("ans", SUNIT[@wh])]
    end
  end
  
  class AddSubDecimals < QuestionWithExplanation
    def self.type
      "Operations with Decimals"
    end
    def initialize(amt=rand(4)+2)
      @nums=[]
      @sigs=[]
      @signif=[]
      for i in 0...amt
        div=rand(3)+1
        @signif[i]=div
        @nums[i]=rand(10000)
        while @nums[i] % 10==0
          @nums[i]=rand(10000)
        end
      end
      for i in 0...@nums.length-1
        @sigs[i]=rand(2)
        if @sigs[i]==0
          @sigs[i]=-1
        end
      end
    end
    def solve
      sum=Rational(0,1)
      for i in 0...@nums.length
        tm=Rational(@nums[i], 10**@signif[i])
        tm*=@sigs[i-1] if i > 0
        sum+=tm
      end
      {"ans" => sum.to_f}
    end
    def explain
      ret=[Chapter8::MaxDecSigDigits.new(@nums, @signif)]
      ret << SubLabel.new("Multiply each of the components of the sum by 1 followed by #{@signif.max} zeroes")
      for i in 0...@nums.length
        ret << Subproblem.new([TextLabel.new("Multiply #{Rational(@nums[i], 10**@signif[i]).to_f} and #{10**@signif.max}"), TextField.new("mul")], {"mul" => (Rational(@nums[i], 10**@signif[i])*(10**@signif.max)).to_i})
      end
      ret << SubLabel.new("You will now notice that there are no decimals left. Now add all these numbers like you would any whole numbers")
      signs=[]
      fnum=[]
      for i in 0...@nums.length
        fnum[i]=(Rational(@nums[i], 10**@signif[i])*(10**@signif.max)).to_i
        signs[i]=1
      end
      ret << Chapter6::AddSubIntegers.new(fnum, signs, @sigs) 
      ret << Subproblem.new([TextLabel.new("Now, divide the previous answer by 1 followed by #{@signif.max} zeros, which is the same as the number you divided each of the components by, and thus obtain the answer"), TextField.new("answ")], {"answ" => solve["ans"]})
      ret
    end
    def text
      str=Rational(@nums[0], 10**@signif[0]).to_f.to_s
      for i in 1...@nums.length
        str+=' + ' if @sigs[i-1] > 0
        str+=" - " if @sigs[i-1] < 0
        str+= Rational(@nums[i], 10**@signif[i]).to_f.to_s
      end
      [TextLabel.new("Find: " + str), TextField.new("ans")] 
    end
  end
  
  class SubDecimals < AddSubDecimals
    def self.type
      "Subtract Decimals"
    end
    def initialize()
      super(2)
      @sigs=[-1]
    end
  end

  class AddDecimals < AddSubDecimals
    def self.type
      "Add Decimals"
    end
    def initialize()
      super()
      @sigs=[]
      for i in 0...@nums.length-1
        @sigs[i]=1
      end
    end
  end

  

  

  PROBLEMS=[Chapter8::FractionsToDecimals, Chapter8::DecimalsToFractions, Chapter8::UnitsDecIncrease, Chapter8::UnitsDecDecrease, Chapter8::AddDecimals, Chapter8::SubDecimals, Chapter8::AddSubDecimals]
end  
