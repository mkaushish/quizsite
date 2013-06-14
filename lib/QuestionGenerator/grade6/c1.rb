#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml'
require_relative './preg6'

# TODO override preprocess for the add commas question ( default is now to remove commas )
include ToHTML
include PreG6

module Chapter1
  INDEX = 1
  TITLE = "Knowing our Numbers"
  ROMAN_TABLE = RomanTable.new( [
                               [ 1 , "=", "I" , "", 90  , "=", "XC"],
                               [ 4 , "=", "IV", "", 100 , "=", "C" ],
                               [ 5 , "=", "V" , "", 400 , "=", "CD"],
                               [ 9 , "=", "IX", "", 500 , "=", "D" ],
                               [ 10, "=", "X" , "", 900 , "=", "CM"],
                               [ 40, "=", "XL", "", 1000, "=", "M" ],
                               [ 50, "=", "L" , "", "",   "",  ""  ]
  ])
  PPVALUE=["Ones", "Tens", "Hundreds", "Thousands", "Ten Thousands", "Lakhs", "Ten Lakhs", "Crores", "Ten Crores"]
  class ExpandNumbers1 < QuestionBase
    def self.type
      "Product of 10s"
    end
    def initialize
      @prod=rand(6)
      @num=rand(99)+1
    end
    def solve
      {"ans" => @num}
    end
    def text
      [TextLabel.new("Fill in the blanks:"), InlineBlock.new(TextLabel.new("#{@num*(10**@prod)} = "), TextField.new("ans"), TextLabel.new(" X #{10**@prod}"))]
    end
  end
  class ExpandNumbers2 < QuestionBase
    def self.type
      "Break Whole Numbers"
    end
    def initialize
      @prod1=rand(6)+2
      @prod2=rand(@prod1)
      @num1=rand(99)+1
      @num2=rand(9)+1
    end
    def solve
      {"ans1" => @num1, "ans2" => @num2}
    end
    def correct?(params)
      solsum = 0
      bool = true
      resps = QuestionBase.vars_from_response( *( (1...3).map { |i| "ans#{i}" }), params)
      puts "********\n" + resps.to_s + "********\n"
      resps[0].to_i*(10**@prod1)+resps[1].to_i*(10**@prod2)==@num1*(10**@prod1)+@num2*(10**@prod2)
    end
    def text
      [TextLabel.new("Expand #{@num1*(10**@prod1)+@num2*(10**@prod2)}:"), 
        InlineBlock.new(TextField.new("ans1"), TextLabel.new(" X #{10**@prod1}"), TextLabel.new(" + "), TextField.new("ans2"), TextLabel.new(" X #{10**@prod2}")),
      ]
    end
  end
  class ExpandNumbers < QuestionBase
    def self.type
      "Expand Whole Numbers"
    end
    def initialize
      @num=rand(100000)+5000
    end
    def solve
      sol={}
      for i in 0...("#{@num}").length
        sol["ans_#{i}"]=("#{@num}")[i]
      end
      sol
    end
    def correct?(params)
      solsum = 0
      bool = true
      resps = QuestionBase.vars_from_response( *( (0...("#{@num}").length).map { |i| "ans_#{i}" }), params)
      tem=[]
      for i in 0...resps.length
        tem << resps[i].to_i*(10**(("#{@num}").length-1-i))
      end
      tem.reduce(:+)==@num
    end
    def text
      ret=[TextLabel.new("Expand #{@num}:")]
      for i in 0...("#{@num}").length
        tem=[TextField.new("ans_#{i}")] 
        if i < ("#{@num}").length-1 
          tem << TextLabel.new(" X #{10**(("#{@num}").length-i-1)} + ")
        else
          tem << TextLabel.new(" X #{10**(("#{@num}").length-i-1)}")
        end
        ret << InlineBlock.new(tem)
      end
      ret
    end
  end
  class WordProbSum < QuestionBase
    def self.type
      "Find the Sum"
    end
    def initialize
      n=rand(3)+2
      @nums=[]
      pow=rand(5)
      for i in 0...n
        @nums[i]=rand(10**(pow+1))
      end
      @ob1=["movie theater", "shop", "bakery", "fruit stall", "grocery store"]
      @no1=["tickets", "bottles of churan", "loaves of bread", "apples", "heads of lettuce"]
      @wh1=rand(@ob1.length)
    end
    def solve
      {"ans" => @nums.reduce(:+)}
    end
    def text
      day=[]
      for i in 0...@nums.length
        day[i]="Day #{i+1}"
      end
      re=[day, @nums]
      [TextLabel.new("Over the course of #{@nums.length} days, a #{@ob1[@wh1]} sold the following number of #{@no1[@wh1]} each day: "), TextTable.new(re), TextLabel.new("Find the total number of #{@no1[@wh1]} sold by the #{@ob1[@wh1]}"), TextField.new("ans")]
    end
  end

  class WordProbDiff < QuestionBase
    def self.type
      "Find What's Remaining"
    end
    def initialize
      n=rand(3)+2
      @nums=[]
      pow=rand(5)
      for i in 0...n
        @nums[i]=rand(10**(pow+1))
      end
      @num=@nums.reduce(:+)+rand(10**pow)+1
      @ob1=["movie theater", "shop", "bakery", "fruit stall", "grocery store"]
      @no1=["tickets", "bottles of churan", "loaves of bread", "apples", "heads of lettuce"]
      @wh1=rand(@ob1.length)
    end
    def solve
      {"ans" => @num-@nums.reduce(:+)}
    end
    def text
      day=[]
      for i in 0...@nums.length
        day[i]="Day #{i+1}"
      end
      re=[day, @nums]
      [TextLabel.new("Over the course of #{@nums.length} days, a #{@ob1[@wh1]} sold the following number of #{@no1[@wh1]} each day: "), TextTable.new(re), TextLabel.new("Their target for #{@nums.length+1} days was to sell #{@num} #{@no1[@wh1]}. Find the total number of #{@no1[@wh1]} required to be sold by the #{@ob1[@wh1]} on the final day"), TextField.new("ans")]
    end
  end


  class PlaceValueTable < QuestionBase
    def self.type
      "Place Value"
    end
    def initialize(num=nil)
      if num!=nil
        @num=num
      else
        @num=10
        while @num % 10==0
          @num=(rand(900000000) + 100)
        end
      end
    end

    def solve
      pp={}
      i=@num.to_s.length-1
      while i >= 0
        pp["ans_"+PPVALUE[(@num.to_s.length-1-i)]]=@num.to_s[i]
        i-=1;
      end
      @pp=pp
      ret=pp
      for i in 0...PPVALUE.length
        ret["ans_"+PPVALUE[i]]="0" if(ret["ans_"+PPVALUE[i]]==nil)
      end

      $stderr.puts ret
      ret
    end   
    def preprocess(name, response)
      $stderr.puts "*****"+response
      str=response.strip.downcase.gsub(/,/, "").gsub(/\s+/, " ") if response.is_a?(String)  
      str="0" if str.strip==""
      str
    end


    def text
      solve
      ret=[TextLabel.new("Write the following in the place value table"), TextLabel.new(@num.to_s)]
      tab=TableField.new("tab", PPVALUE.length/3+1, 6)
      puts PPVALUE
      for i in 0...(1+PPVALUE.length/3)
        for j in 0...3
          if(i*3+j+1 <= PPVALUE.length)
            tab.set_field(i, j*2, TextLabel.new(PPVALUE[i*3+j]))
            tab.set_field(i, j*2+1, TextField.new("ans_"+PPVALUE[i*3+j]))
          else
            tab.set_field(i, j*2, TextLabel.new(""))
            tab.set_field(i, j*2+1, TextLabel.new(""))

          end
        end
      end
      ret << tab
      ret
    end

  end

  class FindMaxNumber < QuestionWithExplanation
    attr_accessor :nums
    def self.type
      "Maximum Number"
    end

    def initialize(nums = nil)
      if nums.nil?
        num_nums = rand(3) + 3 # between 3 and 5
        @nums = Array.new(num_nums).map { Grade6ops::rand_num }
      else
        @nums = nums
      end
    end

    def solve
      {"ans" => @nums.max.to_s}
    end
    def explain
      ret=[SubLabel.new("The numbers we have to compare are #{@nums.join(", ")}. We will find the largest number by eliminting from the list.")]
      ret << Subproblem.new([TextLabel.new("Look at all the numbers. What is the largest place that in any of them?"), Dropdown.new("cro", PPVALUE)], {"cro" => PPVALUE[@nums.max.to_s.length-1]})
      tm=[]
      rem=[]
      chb=[]
      hsh={}
      for i in 0...@nums.length
        if @nums[i].to_s.length < @nums.max.to_s.length
          tm << @nums[i] 
          hsh["pk1_#{i}"] = 1
        end
        chb << Checkbox.new("pk1_#{i}", @nums[i])
        rem << @nums[i] if @nums[i].to_s.length == @nums.max.to_s.length
      end
      ret << Subproblem.new([TextLabel.new("Pick all the numbers which do not have the #{PPVALUE[@nums.max.to_s.length-1]} digit. We can eliminate these in our search for the largest number")] + chb, hsh)
      if rem.length==1
        ret << SubLabel.new("The only remaining number is #{@nums.max} and hence, it is the largest number")
        return ret
      end
      ret << SubLabel.new("Now, we will go through the remaining numbers from left to right, comparing digits")

      ret << Subproblem.new([TextLabel.new("The remaining numbers are: #{rem.join(", ")}. First, we compare their left-most digits. What is the largest left-most digit?"), Dropdown.new("dig", ("1".."9").to_a)], {"dig" => @nums.max.to_s[0]})
      tm=[]
      chb=[]
      hsh={}
      for i in 0...rem.length
        if rem[i].to_s[0]!=@nums.max.to_s[0]
          tm << rem[i] 
          hsh["pk2_#{i}"] = 1
        end
        chb << Checkbox.new("pk2_#{i}", rem[i])
      end
      ret << Subproblem.new([TextLabel.new("Now pick those numbers which do not have this digit as their left-most digit")]+chb, hsh)
      for j in 1...@nums.max.to_s.length
        for i in 0...rem.length
          if rem[i].to_s[j-1]!=@nums.max.to_s[j-1]
            rem.slice!(i)
            i-=1
          end
        end
        break if(rem.length==1) 
        tm=[]
        chb=[]
        hsh={}
        for i in 0...rem.length
          if rem[i].to_s[j]!=@nums.max.to_s[j]
            tm << rem[i] 
            hsh["pk2_#{i}"] = 1
          end
          chb << Checkbox.new("pk2_#{i}", rem[i])
        end
        ret << Subproblem.new([TextLabel.new("The remaining numbers are: #{rem.join(", ")}. Now, we compare the next digit from the left. What is the largest such digit?"), Dropdown.new("dig", ("1".."9").to_a)], {"dig" => @nums.max.to_s[j]})
        ret << Subproblem.new([TextLabel.new("Now pick those numbers which do not have this digit")]+chb, hsh)
      end
      ret << SubLabel.new("The only remaining number is #{@nums.max} and hence, it is the largest number")
    end

    def text
      [
        TextLabel.new("Find the greatest number amongst the following:"),
        RadioButton.new("ans", @nums)
      ]
    end
  end

  class FindMinNumber < QuestionWithExplanation
    attr_accessor :nums
    def self.type
      "Minimum Number"
    end

    def initialize(nums = nil)
      if nums.nil?
        num_nums = rand(3) + 3 # between 3 and 5
        @nums = Array.new(num_nums).map { Grade6ops::rand_num }
      else
        @nums = nums
      end
    end

    def solve
      {"ans" => @nums.min.to_s}
    end

    def explain
      ret=[SubLabel.new("The numbers we have to compare are #{@nums.join(", ")}. We will find the smallest number by eliminating from the list.")]
      ret << Subproblem.new([TextLabel.new("Look at all the numbers. What is the smallest left-most place that in any of them?"), Dropdown.new("cro", PPVALUE)], {"cro" => PPVALUE[@nums.min.to_s.length-1]})
      tm=[]
      rem=[]
      chb=[]
      hsh={}
      for i in 0...@nums.length
        if @nums[i].to_s.length > @nums.min.to_s.length
          tm << @nums[i] 
          hsh["pk1_#{i}"] = 1
        end
        chb << Checkbox.new("pk1_#{i}", @nums[i])
        rem << @nums[i] if @nums[i].to_s.length == @nums.min.to_s.length
      end
      ret << Subproblem.new([TextLabel.new("Pick all the numbers which have more than the #{PPVALUE[@nums.max.to_s.length-1]} place. We can eliminate these in our search for the smallest number")] + chb, hsh)
      if rem.length==1
        ret << SubLabel.new("The only remaining number is #{@nums.min} and hence, it is the largest number")
        return ret
      end
      ret << SubLabel.new("Now, we will go through the remaining numbers from left to right, comparing digits")

      ret << Subproblem.new([TextLabel.new("The remaining numbers are: #{rem.join(", ")} First, we compare their left-most digits. What is the smallest left-most digit?"), Dropdown.new("dig", ("1".."9").to_a)], {"dig" => @nums.min.to_s[0]})
      tm=[]
      chb=[]
      hsh={}
      for i in 0...rem.length
        if rem[i].to_s[0]!=@nums.min.to_s[0]
          tm << rem[i] 
          hsh["pk2_#{i}"] = 1
        end
        chb << Checkbox.new("pk2_#{i}", rem[i])
      end
      ret << Subproblem.new([TextLabel.new("Now pick those numbers which do not have this digit as their left-most digit")]+chb, hsh)
      for j in 1...@nums.min.to_s.length
        for i in 0...rem.length
          if rem[i].to_s[j-1]!=@nums.min.to_s[j-1]
            rem.slice!(i)
            i-=1
          end
        end
        break if(rem.length==1) 
        tm=[]
        chb=[]
        hsh={}
        for i in 0...rem.length
          if rem[i].to_s[j]!=@nums.min.to_s[j]
            tm << rem[i] 
            hsh["pk2_#{i}"] = 1
          end
          chb << Checkbox.new("pk2_#{i}", rem[i])
        end
        ret << Subproblem.new([TextLabel.new("The remaining numbers are: #{rem.join(", ")} Now, we compare the next digit from the left. What is the smallest such digit?"), Dropdown.new("dig", ("1".."9").to_a)], {"dig" => @nums.min.to_s[j]})
        ret << Subproblem.new([TextLabel.new("Now pick those numbers which do not have this digit")]+chb, hsh)
      end
      ret << SubLabel.new("The only remaining number is #{@nums.min} and hence, it is the smallest number")
    end

    def text
      [
        TextLabel.new("Find the smallest number amongst the following:"),
        RadioButton.new("ans", @nums)
      ]
    end
  end

  class ArrangeAscending < QuestionBase
    attr_accessor :nums
    def self.type
      "Ascending Order"
    end
    def prereq
      [[Chapter1::FindMinNumber, 1.0]]
    end

    def initialize()
      num_nums = rand(2) + 3 # between 3 and 5
      @nums = Array.new(num_nums).map { Grade6ops::rand_num }
    end

    def solve
      { "ans" => @nums.sort.join(",") }
    end

    def text
      [ TextLabel.new("Drag the numbers in ascending order"),
        PermutationDrag.new("ans", @nums)
      ]
    end
  end
  class ShiftingDigitsGr < QuestionBase

    def initialize(digs=(1..9).to_a.sample(rand(3)+3))
      @digs=digs
    end

    def solve
      {"ans1" => @digs.sort.reverse.join(",") }
    end

    def text
      [ TextLabel.new("Drag the digits to create the largest number possible"),
        TextLabel.new("Largest number:"),
        PermutationDrag.new("ans1", @digs)
      ]
    end
  end
  class ShiftingDigitsLs < QuestionBase

    def initialize(digs=(1..9).to_a.sample(rand(3)+3))
      @digs=digs
    end

    def solve
      { "ans" => @digs.sort.join(",") }
    end

    def text
      [ TextLabel.new("Drag the digits to create the smallest number possible"),
        TextLabel.new("Smallest number:"),
        PermutationDrag.new("ans", @digs),
      ]
    end
  end
  class ShiftingDigits < QuestionWithExplanation
    def initialize
      @digs=(1..9).to_a.sample(rand(3)+3)
    end
    def solve
      {"diff" => @digs.sort.reverse.join("").to_i - @digs.sort.join("").to_i
      }
    end
    def explain
      [SubLabel.new("To do this, we first find the largest and smallest numbers that can be made using these digits. Then, we find their difference."),
        Chapter1::ShiftingDigitsGr.new(@digs),
        Chapter1::ShiftingDigitsLs.new(@digs),
        PreG6::Subtraction.new(@digs.sort.reverse.join("").to_i, @digs.sort.join("").to_i)]
    end
    def text
      [ TextLabel.new("Find the difference between the largest and smallest numbers that can be formed using the following digits"),
        PermutationDisplay.new("ans1", @digs),
        TextField.new("diff")
      ]
    end
  end


  class ArrangeDescending < QuestionBase
    attr_accessor :nums
    def self.type
      "Descending Order"
    end
    def prereq
      [[Chapter1::FindMaxNumber, 1.0]]
    end

    def initialize()
      num_nums = rand(2) + 3 # between 3 and 5
      @nums = Array.new(num_nums).map { Grade6ops::rand_num }
    end

    def solve
      { "ans" => @nums.sort.reverse.join(",") }
    end

    def text
      [ TextLabel.new("Drag the numbers in descending order"),
        PermutationDrag.new("ans", @nums)
      ]
    end
  end

  class WritingIndian < QuestionBase
    attr_accessor :num
    def self.type
      "Indian System of Numeration"
    end

    def initialize
      @num = Grade6ops::rand_num
    end

    def preprocess(name, response)
      super(name, response.gsub(/\s+and\s+/, " "))
    end

    def solve
      {"ans" => @num.to_indian}
    end

    def text
      [ TextLabel.new("Suitably write the name of this number according to the Indian System of Numeration:"),
        TextField.new("ans", @num)
      ]
    end
  end

  class WritingInternational < QuestionBase
    attr_accessor :num
    def self.type
      "International System of Numeration"
    end

    def initialize
      @num = Grade6ops::rand_num
    end

    def preprocess(name, response)
      super(name, response.gsub(/\s+and\s+/, " "))
    end

    def solve
      {"ans" => @num.to_international}
    end

    def text
      [ TextLabel.new("Suitably write the name of this number according to the International System of Numeration:"),
        TextField.new("ans", @num)
      ]
    end
  end

  class AddCommasIndian < QuestionWithExplanation
    attr_accessor :num
    def self.type
      "Adding Commas Indian"
    end

    def initialize
      @num = Grade6ops::rand_num
    end

    def solve
      ret={}
      ct=0
      for i in 0...@num.to_s.length
        if((ct-1) % 2 == 0 && ct!=1)
          ret["ans#{@num.to_s.length-1-ct}"] = "1"
        else ret["ans#{@num.to_s.length-1-ct}"] = "0"
        end
        ct+=1
      end
      ret
    end

    def text
      inl=[]
      for i in 0...@num.to_s.length
        inl << TextLabel.new(@num.to_s[i])
        inl << Commabox.new("ans#{i}")
      end
      [ TextLabel.new("According to the Indian System of Numeration, click where the commas should be:"),
        InlineBlock.new(inl)   
      ]
    end

    def explain
      [
        Subproblem.new( [
                       TextLabel.new("To add commas to to a number, always start from the right side (The side with the \"least significant digit\").  Count 3 digits over, and add a comma there.  After that one, add a comma every two digits.  This way #{@num} becomes #{@num.ind_commas}")
      ], {} 
                      )
      ]
    end
  end

  class AddCommasInternational < QuestionWithExplanation
    attr_accessor :num
    def self.type
      "Adding Commas International"
    end

    def initialize
      @num = Grade6ops::rand_num
    end

    def solve
      ret={}
      ct=0
      for i in 0...@num.to_s.length
        if((ct) % 3 == 0 && ct!=0)
          ret["ans#{@num.to_s.length-1-ct}"] = "1"
        else ret["ans#{@num.to_s.length-1-ct}"] = "0"
        end
        ct+=1
      end
      ret
    end

    def text
      inl=[]
      for i in 0...@num.to_s.length
        inl << TextLabel.new(@num.to_s[i])
        inl << Commabox.new("ans#{i}")
      end
      [ TextLabel.new("According to the International System of Numeration, click where the commas should be:"),
        InlineBlock.new(inl)   
      ]
    end

    def explain
      [ Subproblem.new( [
                       TextLabel.new("To add commas to to a number, always start from the right side (The side with the \"least significant digit\").  Then keep moving 3 digits left and adding a comma, until you hit the end of the number.  This way #{@num} becomes #{@num.int_commas}")
      ], {} 
                      )
      ]
    end
  end

  class ReadingInternational < QuestionBase
    attr_accessor :num
    def self.type
      "Reading Numbers International"
    end

    def initialize
      @num = Grade6ops::rand_num
    end

    def solve
      {"ans" => @num}
    end

    def text
      [ TextLabel.new("Write out the number #{@num.to_international} with numerals:"), 
        TextField.new("ans", @num.to_international)
      ]
    end
  end

  class ReadingIndian < QuestionBase
    attr_accessor :num
    def self.type
      "Reading Numbers Indian"
    end

    def initialize
      @num = Grade6ops::rand_num
    end

    def solve
      {"ans" => @num}
    end

    def text
      [ TextLabel.new("Write out the number #{@num.to_indian} with numerals:"),
        TextField.new("ans", @num.to_indian)
      ]
    end
  end

  class RoundingNumbers < QuestionWithExplanation
    attr_accessor :num

    def self.type
      "Rounding Numbers"
    end

    def initialize(num = nil)
      @num = num.nil? ? Grade6ops::rand_num(0.1, 4, 8) : num
    end

    def solve
      {"ans" => @num.gen_rule}
    end

    def text
      [ TextLabel.new("Round #{@num} to its largest place"), 
        TextField.new("ans")
      ]
    end

    def explain
      [ Subproblem.new( [
                       TextLabel.new("A \"round number\" has all 0's after the first digit.  To round off #{@num}, we pick the closest round number, which is #{@num.gen_rule}") ], {} )
      ]
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

  class ConvertUnitsSimple < QuestionBase
    def initialize(sunit=SUNIT.sample)
      @pos=SUNIT.index(sunit)
    end
    def solve
      {"ans" => UCON[SUNIT[@pos]]}
    end
    def text 
      [TextLabel.new("How many #{SUNIT[@pos]} make up 1 #{LUNIT[@pos]}?"), TextField.new("ans")]
    end
  end

  class ConvertUnits < QuestionWithExplanation
    def initialize
      @pos=rand(SUNIT.length)
      @num=rand(100*(UCON[SUNIT[@pos]]))+UCON[SUNIT[@pos]]
    end
    def solve
      {"ans" => @num}
    end
    def explain
      nm=@num/UCON[SUNIT[@pos]]
      de=@num-nm*UCON[SUNIT[@pos]]
      [Chapter1::ConvertUnitsSimple.new(SUNIT[@pos]),
        SubLabel.new("Now we find how many #{SUNIT[@pos]} make up #{nm} #{LUNIT[@pos]}"),
        PreG6::Multiplication.new(nm, UCON[SUNIT[@pos]]),
        SubLabel.new("Now, we add #{de} #{SUNIT[@pos]}"),
        PreG6::Addition([nm*UCON[SUNIT[@pos]], de])]
    end
    def text 
      nm=@num/UCON[SUNIT[@pos]]
      de=@num-nm*UCON[SUNIT[@pos]]
      [TextLabel.new("Convert #{nm} #{LUNIT[@pos]} #{de} #{SUNIT[@pos]} to #{SUNIT[@pos]}"), TextField.new("ans")]
    end
  end



  class EstimateArithmetic < QuestionWithExplanation
    attr_accessor :op, :n1, :n2
    def self.type
      "Estimation by General Rule"
    end

    def bigger
      (@n1 > @n2) ? n1 : n2
    end

    def smaller
      (@n1 > @n2) ? n2 : n1
    end

    def initialize(op = nil, nums = nil)
      @op = op.nil? ? Grade6ops::random_elt(:+, :-, :*) : op

      if nums.nil?
        min = (@op == :*) ? 2 : 3
        max = (@op == :*) ? 4 : 5
        @n1 = Grade6ops::rand_num(0.01, min, max)
        @n2 = Grade6ops::rand_num(0.01, min, max)

        swap if (@op == :-) && @n2 > @n1
      else
        @n1 = nums[0]
        @n2 = nums[1]
      end
    end
    def prereq
      gen=[[Chapter1::RoundingNumbers, 1.0]]

      return gen + [[PreG6::Multiplication, 0.0]] if (@op==:*) 
      return gen + [[PreG6::Addition, 0.0]] if (@op==:+)
      return gen + [[PreG6::Subtraction, 0.0]]
    end


    def solve
      small = smaller.gen_rule
      big = bigger.round(small.to_s.length - 1)

      {"ans" => big.send(@op, small)}
    end

    def text
      [ TextLabel.new("Estimate the value of #{@n1} #{@op} #{@n2} using the General Rule"),
        TextField.new("ans")
      ]
    end

    def explain_part
      small = smaller
      big = bigger
      small_round = small.gen_rule
      big_round = big.round(small.to_s.length - 1)
      solution = big_round.send(@op, small_round)

      return [ 
        FindMinNumber.new([small, big]),
        RoundingNumbers.new(small),
        Subproblem.new( [ 
                       TextLabel.new("Because #{small} is #{small.to_s.length} digits long, we need to round off the last #{small.to_s.length - 1} digits of #{big}.  This gives us"),
                       TextField.new("big_round")
      ], 
        {"big_round" => bigger.round(small.to_s.length - 1)} 
                      )
      ]
    end

    protected

    def big_round
      bigger.round(smaller.to_s.length - 1)
    end

    def small_round
      smaller.gen_rule
    end

    def swap
      tmp = @n1
      @n1 = @n2
      @n2 = tmp
    end
  end

  class EstimateAddition < EstimateArithmetic
    def self.type
      "Estimate Sums"
    end

    def initialize(nums = nil)
      super(:+, nums)
    end

    def explain
      explain_part << PreG6::Addition.new([big_round, small_round])
    end
  end

  class EstimateSubtraction < EstimateArithmetic
    def self.type
      "Estimate Subtraction"
    end

    def initialize(nums = nil)
      super(:-, nums)
    end

    def explain
      explain_part << PreG6::Subtraction.new(big_round, small_round)
    end
  end

  class EstimateProduct < EstimateArithmetic
    def self.type
      "Estimate Product"
    end

    def initialize(nums = nil)
      super(:*, nums)
    end

    def explain
      explain_part << PreG6::Multiplication.new(big_round, small_round)
    end
  end

  class ToRoman < QuestionWithExplanation
    attr_accessor :num
    def self.type
      "To Roman Numerals"
    end

    def initialize
      @num=rand(Grade6ops::MAX_ROMANNUM - Grade6ops::MIN_ROMANNUM) + Grade6ops::MIN_ROMANNUM
    end
    def solve
      {"ans" => @num.to_roman}
    end

    def text
      [ TextLabel.new("Convert #{@num} to Roman Numerals"),
        TextField.new("ans")
      ]
    end

    def explain
      romans = Fixnum.class_variable_get :@@roman
      num_remaining = @num
      tally = 0
      roman_tally = ""
      tally_table = [ [ "Number", "", "", "Tally" ], [ @num, "", "", "" ] ]
      romans.keys.reverse.each do |k|
        v = romans[k]
        while num_remaining >= k
          tally += k
          num_remaining -= k
          roman_tally = roman_tally + v
          tally_table << [ num_remaining, tally, "=", roman_tally ]
        end
      end

      [
        Subproblem.new( [
                       TextLabel.new("To convert from roman numerals, you need to memorize the table below"),
                       ROMAN_TABLE,
                       TextLabel.new( "Now go through the table from the biggest numeral to the smallest.  Each time you're on a numeral that's smaller than what's left of your number, take it away from your number, and add it to the roman numeral you're making.  Follow the example below for the number #{@num}:"),
                       TextTable.new(tally_table)
      ])
      ]
    end
  end

  class ToArabic < QuestionWithExplanation
    attr_accessor :num
    def self.type
      "To Arabic Numerals"
    end

    def initialize
      @num=rand(Grade6ops::MAX_ROMANNUM - Grade6ops::MIN_ROMANNUM) + Grade6ops::MIN_ROMANNUM
    end

    def solve 
      {"ans" => @num} 
    end

    def text
      [ TextLabel.new("Convert the following to Hindu-Arabic Numerals:"),
        RomanLabel.new(@num.to_roman), 
        TextField.new("ans")
      ]
    end

    def explain
      roman = @num.to_roman
      romans = Fixnum.class_variable_get :@@roman
      tally = 0
      roman_tally = ""
      tally_table = [ [ "Roman Numerals", "", "", "Tally" ], [ roman.clone, "", "", tally ] ]
      romans.keys.reverse.each do |k|
        v = romans[k]
        while roman =~ /^\s*#{v}/i do
          roman.sub!(/^\s*#{v}/i, "")
          tally += k
          roman_tally = roman_tally + v
          tally_table << [ roman.clone, roman_tally, "=", tally ]
        end
      end

      [
        Subproblem.new( [
                       TextLabel.new("To convert to roman numerals, you need to memorize the table below"),
                       ROMAN_TABLE,
                       TextLabel.new( "Now just go through the number #{@num.to_roman}, adding up the values from the table"),
                       TextTable.new(tally_table)
      ])
      ]

    end
  end

  # note that I have to be at the end to compile :(
  PROBLEMS = [  
    Chapter1::ExpandNumbers1,
    Chapter1::ExpandNumbers2,
    Chapter1::ExpandNumbers,
    Chapter1::WordProbSum,
    Chapter1::WordProbDiff,
    Chapter1::PlaceValueTable,
    Chapter1::FindMaxNumber,      Chapter1::FindMinNumber,        
    Chapter1::ArrangeAscending,   Chapter1::ArrangeDescending,  
    # Chapter1::WritingIndian,      Chapter1::WritingInternational, 
    Chapter1::ReadingIndian,      Chapter1::ReadingInternational, 
    Chapter1::AddCommasIndian,    Chapter1::AddCommasInternational,    
    Chapter1::RoundingNumbers,
    #Chapter1::EstimateAddition,   Chapter1::EstimateSubtraction,
    #Chapter1::EstimateProduct,
    Chapter1::ShiftingDigitsGr,
    Chapter1::ShiftingDigitsLs,
    Chapter1::ShiftingDigits,
    Chapter1::ToRoman,            Chapter1::ToArabic
  ]
end

