
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
      return "invalid"
    end


    def text
      solve
      ret=[TextLabel.new("Write the following in the place value table"), TextLabel.new(@num.to_s)]
      tab=TableField.new("ans", 2, PPVALUE.length+NPVALUE.length)
      for i in 0...PPVALUE.length
        tab.set_field(0, i, TextLabel.new(PPVALUE[PPVALUE.length-i-1]))
      end

      for i in 0...NPVALUE.length
        tab.set_field(0, PPVALUE.length+i, TextLabel.new(NPVALUE[i]))
      end
      for i in 0...(PPVALUE.length)
        tab.set_field(1, PPVALUE.length-1-i, TextField.new("ans_"+PPVALUE[i]))
      end
      for i in 0...NPVALUE.length
        tab.set_field(1, PPVALUE.length+i, TextField.new("ans_"+NPVALUE[i]))
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
      rem=(@num-(@num/(10**@div))*(10**@div))
      orat=rem.to_f/(10**@div)
        [Subproblem.new([TextLabel.new("What is the integer part of #{rat}"), TextField.new("intpart")], {"intpart" => solve["intpart"]}),  
        Subproblem.new([TextLabel.new("How many digits are there after the decimal point in #{rat}"), TextField.new("numd")], {"numd" => @div}),
        Subproblem.new([TextLabel.new("The decimal part of the number is #{orat}. Multiply it by 1 followed by #{@div} zeroes. This is the numerator. 1 followed by #{@div} zeros is the denominator"), Fraction.new("num", "den", TextLabel.new(solve["intpart"]))], {"num" => rem, "den" => 10**@div}),
        Subproblem.new([TextLabel.new("Reduce the fraction to its lowest terms"), Fraction.new(rem, 10**@div, TextLabel.new(solve["intpart"])), Fraction.new("num", "den", TextLabel.new(solve["intpart"]))], {"num" => solve["num"], "den" => solve["den"]} )]
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
      [Subproblem.new([TextLabel.new("How many #{SUNIT[@wh]} are there in a #{LUNIT[@wh]}?"), TextField.new("mul", SUNIT[@wh])], {"mul" => UCON[SUNIT[@wh]]}), 
        Subproblem.new([TextLabel.new("Divide #{@num} #{SUNIT[@wh]} by #{UCON[SUNIT[@wh]]} to get the answer."), TextField.new("lun", LUNIT[@wh])], {"lun" => solve["ans"]})]
    end
    def text
      [TextLabel.new("Convert #{@num} #{SUNIT[@wh]} to #{LUNIT[@wh]}"), TextField.new("ans", LUNIT[@wh])]
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
      [Subproblem.new([TextLabel.new("How many #{SUNIT[@wh]} are there in a #{LUNIT[@wh]}?"), TextField.new("mul",SUNIT[@wh] )], {"mul" => UCON[SUNIT[@wh]]}),
        Subproblem.new([TextLabel.new("Multiply #{@num} #{LUNIT[@wh]} by #{UCON[SUNIT[@wh]]} to get the answer."), TextField.new("sun", SUNIT[@wh])], {"sun" => solve["ans"]})]
    end
    def text
      [TextLabel.new("Convert #{@num} #{LUNIT[@wh]} to #{SUNIT[@wh]}"), TextField.new("ans", SUNIT[@wh])]
    end
  end
  class AddDecimals < QuestionBase
    def initialize(amt=rand(4)+2)
      @nums=[]
      for i in 0...amt
        div=rand(3)+1
        @nums[i]=rand(10000)
        while @nums[i] % 10==0
          @nums[i]=rand(10000)
        end
        @nums[i]=Rational(@nums[i], (10**div))
      end
      @wh=rand(2)
    end
    def solve
      sum=Rational(0,1)
      for i in 0...@nums.length
        sum+=@nums[i]
      end
      {"ans" => sum.to_f.to_s}
    end
    def text
      if @wh==0
        sm="#{@nums[0].to_f}"
        for i in 1...@nums.length
          sm+=" , #{@nums[i].to_f}"
        end
        [TextLabel.new("Get the sum of: #{sm}"), TextField.new("ans")]
      else
        sm="#{@nums[0].to_f}"
        for i in 1...@nums.length
          sm+=" + #{@nums[i].to_f}"
        end
        [TextLabel.new("Find: #{sm}"), TextField.new("ans")]
      end
    end
  end    
  
  class SubDecimals < QuestionBase
    def initialize()
      @nums=[]
      for i in 0...2
        div=rand(3)+1
        @nums[i]=rand(10000)
        while @nums[i] % 10==0
          @nums[i]=rand(10000)
        end
        @nums[i]=Rational(@nums[i], (10**div))
      end
      @wh=rand(2)
      if @nums[0].to_f<@nums[1].to_f
        k=@nums[0]
        @nums[0]=@nums[1]
        @nums[1]=k
      end
    end
    def solve
      {"ans" => (@nums[0]-@nums[1]).to_f}
    end
    def text
      if @wh==0
        [TextLabel.new("Subtract #{@nums[1].to_f} from #{@nums[0].to_f}"), TextField.new("ans")]
      else
        [TextLabel.new("Find: #{@nums[0].to_f} - #{@nums[1].to_f}"), TextField.new("ans")]
      end
    end
  end
  class AddSubDecimals < QuestionBase
    def initialize(amt=rand(4)+2)
      @nums=[]
      @sigs=[]
      for i in 0...amt
        @sigs[i]=rand(2)
        @sigs[i]=-1 if @sigs[i]==0
        div=rand(3)+1
        @nums[i]=rand(10000)
        while @nums[i] % 10==0
          @nums[i]=rand(10000)
        end
        @nums[i]=Rational(@nums[i],(10**div))
        @nums[i]*=@sigs[i-1] if i>0
      end
    end
    def solve
      sum=Rational(0,1)
      for i in 0...@nums.length
        sum+=@nums[i]
      end
      {"ans" => sum.to_f.to_s}
    end
    def text
      str=@nums[0].to_f.to_s
      for i in 1...@nums.length
        str+=' + ' if @nums[i].to_f>0
        str+=" - " if @nums[i].to_f<0
        str+= (@nums[i].to_f).abs.to_s
      end
      [TextLabel.new("Find: " + str), TextField.new("ans")] 
    end
  end
  
  

  

  PROBLEMS=[Chapter8::PlaceValueTable, Chapter8::FractionsToDecimals, Chapter8::DecimalsToFractions, Chapter8::UnitsDecIncrease, Chapter8::UnitsDecDecrease, Chapter8::AddDecimals, Chapter8::SubDecimals, Chapter8::AddSubDecimals]
end  
