
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
        pp["ans_1_"+POS[PPVALUE[posdot-i-1]].to_s] = @num.to_s[i]
        i-=1
      end
      i=posdot
      for j in i...(@num.to_s.length-1)
        np["ans_1_"+ POS[NPVALUE[j-i]].to_s ] = @num.to_s[j+1]
      end
      ret=pp.merge(np)
      for j in 0...(PPVALUE+NPVALUE).length
        ret["ans_1_"+j.to_s]="0" if  ret["ans_1_"+j.to_s]==nil
      end
      ret
    end   
    
    def preprocess(name, response)
      if response =~ /^[0-9, ]+$/
        return response.to_i.to_s
      end
      return "invalid"
    end


    def text
      ret=[TextLabel.new("Write the following in the place value table"), TextLabel.new(@num.to_s)]
      tab=TableField.new("ans", 2, PPVALUE.length+NPVALUE.length)
      for i in 0...PPVALUE.length
        tab.set_field(0, i, TextLabel.new(PPVALUE[PPVALUE.length-i-1]))
      end
      for i in 0...NPVALUE.length
        tab.set_field(0, PPVALUE.length+i, TextLabel.new(NPVALUE[i]))
      end
      ret << tab
    end

  end

  class DecimalsToFractions < QuestionWithExplanation
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
      orat=Rational(@num-solve["intpart"].to_i*(10**@div), 10**@div).to_f
        [Subproblem.new([TextLabel.new("What is the integer part of #{rat}"), TextField.new("intpart")], {"intpart" => solve["intpart"]}),  
        Subproblem.new([TextLabel.new("How many digits are there after the decimal point in #{rat}"), TextField.new("numd")], {"numd" => @div}),
        Subproblem.new([TextLabel.new("The decimal part of the number is #{orat}. Multiply it by 1 followed by #{@div} zeroes. This is the numerator. 1 followed by #{@div} zeros is the denominator"), Fraction.new(TextField.new("num" => "Numerator"), TextField.new("den" => "Denominator"), solve["intpart"])], {"num" => (orat)*(10**@div), "den" => 10**@div}),
        Subproblem.new([TextLabel.new("Reduce the fraction to its lowest terms"), Fraction.new((orat*(10**@div)).to_i, 10**@div, solve["intpart"]), Fraction.new("num", "den", solve["intpart"])], {"num" => solve["num"], "den" => solve["den"]} )]
    end
    def text
      ret=[TextLabel.new("Convert the following Decimal into a Mixed Fraction in its lowest form:"), TextLabel.new(Rational(@num, 10**@div).to_f.to_s), Fraction.new("num", "den", "intpart")]
    end
  end  

  class FractionsToDecimals < QuestionBase
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
    def initialize
      @wh=rand(SUNIT.length-1)+1
      @num=rand(UCON[SUNIT[@wh]]*100)
    end
    def solve
      {"ans" => (@num.to_f)/(UCON[SUNIT[@wh]])}
    end
    def explain
      [Subproblem.new([TextLabel.new("How many #{SUNIT[@wh]} are there in a #{LUNIT[@wh]}?"), TextField.new("mul")], {"mul" => UCON[SUNIT[@wh]]}), 
        Subproblem.new([TextLabel.new("Divide #{@num} #{SUNIT[@wh]} by #{UCON[SUNIT[@wh]]} to get the answer."), TextField.new("lun"), TextLabel.new(LUNIT[@wh])], {"lun" => solve["ans"]})]
    end
    def text
      [TextLabel.new("Convert #{@num}#{SUNIT[@wh]} to #{LUNIT[@wh]}"), TextField.new("ans", LUNIT[@wh]), TextLabel.new(LUNIT[@wh])]
    end
  end
  class UnitsDecDecrease < QuestionWithExplanation
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
      [Subproblem.new([TextLabel.new("How many #{SUNIT[@wh]} are there in a #{LUNIT[@wh]}?"), TextField.new("mul")], {"mul" => UCON[SUNIT[@wh]]}),
        Subproblem.new([TextLabel.new("Multiply #{@num} #{LUNIT[@wh]} by #{UCON[SUNIT[@wh]]} to get the answer."), TextField.new("sun"), TextLabel.new(SUNIT[@wh])], {"sun" => solve["ans"]})]
    end
    def text
      [TextLabel.new("Convert #{@num} #{LUNIT[@wh]} to #{SUNIT[@wh]}"), TextField.new("ans", LUNIT[@wh]), TextLabel.new(SUNIT[@wh])]
    end
  end
  class AddDecimals < QuestionBase
    def initialize(amt=rand(4)+1)
      @nums=[]
      @divs=[]
      for i in 0...amt
        @divs[i]=rand[3]+1
        @nums[i]=rand(10000)
        while @nums[i] % 10==0
          @nums[i]=rand(10000)
        end
        @nums[i]=@nums[i]/@divs[i]
      end
      @wh=rand(2)
    end
    def solve
      {"ans" => @nums.reduce(:+)}
    end
    def text
      if @wh==0
        [TextLabel.new("Get the sum of #{@nums.join(",")}"), TextField.new("ans")]
      else
        [TextLabel.new("Find: #{@nums.join("+")}"), TextField.new("ans")]
      end
    end
  end    
  
  class SubDecimals < QuestionBase
    def initialize()
      @nums=[]
      @divs=[]
      for i in 0...1
        @divs[i]=rand[3]+1
        @nums[i]=rand(10000)
        while @nums[i] % 10==0
          @nums[i]=rand(10000)
        end
        @nums[i]=@nums[i]/@divs[i]
      end
      @wh=rand(2)
      if @nums[0]<@nums[1]
        k=@nums[0]
        @nums[0]=@nums[1]
        @nums[1]=k
      end
    end
    def solve
      {"ans" => @nums[0]-@nums[1]}
    end
    def text
      if @wh==0
        [TextLabel.new("Subtract #{@nums[1]} from #{@nums[0]}"), TextField.new("ans")]
      else
        [TextLabel.new("Find: #{@nums.join("-")}"), TextField.new("ans")]
      end
    end
  end
  class AddSubDecimals < QuestionBase
    def initialize(amt=rand(5))
      @nums=[]
      @divs=[]
      @sigs=[]
      for i in 0...amt
        @sigs[i]=rand(2)
        @sigs[i]=-1 if @sigs[i]==0
        @divs[i]=rand[3]+1
        @nums[i]=rand(10000)
        while @nums[i] % 10==0
          @nums[i]=rand(10000)
        end
        @nums[i]=@nums[i]/@divs[i]
        @nums[i]*=@sigs[i-1] if i>0
      end
    end
    def solve
      {"ans" => @nums.reduce(:+).to_s}
    end
    def text
      str=@nums[0].to_s
      for i in 1...@nums.length
        str+='+' if @nums[i]>0
        str+=@nums[i].to_s
      end
      [TextLabel.new("Find: " + str), TextField.new("ans")] 
    end
  end
  
  

  

  PROBLEMS=[Chapter8::PlaceValueTable, Chapter8::FractionsToDecimals, Chapter8::DecimalsToFractions, Chapter8::UnitsDecIncrease, Chapter8::UnitsDecDecrease, Chapter8::AddDecimals, Chapter8::SubDecimals, Chapter8::AddSubDecimals]
end  
