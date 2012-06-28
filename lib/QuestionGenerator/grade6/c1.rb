#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml'
require_relative './preg6'

# TODO override preprocess for the add commas question ( default is now to remove commas )
include ToHTML
include PreG6

module Chapter1
  ROMAN_TABLE = TextTable.new( [
     [ 1 , "=", "I" , "", 90  , "=", "XC"],
     [ 4 , "=", "IV", "", 100 , "=", "C" ],
     [ 5 , "=", "V" , "", 400 , "=", "CD"],
     [ 9 , "=", "IX", "", 500 , "=", "D" ],
     [ 10, "=", "X" , "", 900 , "=", "CM"],
     [ 40, "=", "XL", "", 1000, "=", "M" ],
     [ 50, "=", "L" , "", "",   "",  ""  ]
  ])

  class FindMaxNumber < QuestionBase
    attr_accessor :nums
    def self.type
      "Maximum Num"
    end

    def desc
      [TextLabel.new("In this question, we have to find the maximum of the given whole numbers. To understand this question, lets go through a simple example - 123, 223, 32, 323, 333, 94, 43, 334, 9, 2."),
      TextLabel.new("First we count the number of digits of each number and only keep those with the maximum number of digits, which in this case is 3. We are left with 123, 223, 333, 334 and 323."),
      TextLabel.new("Now we look at the left most digit and only keep those numbers with the highest left most digit. We are left with 333, 334, 323."),
      TextLabel.new("Now we look at the next digit from the left and only keep those with the largest. We are left with 333 and 334."),
      TextLabel.new("Then, we look at the next digit from the left and do the same. We are left with 334. Since this is the only number left, it is also the maximum number.")]
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

    def text
      [
        TextLabel.new("Find the greatest number amongst the following:"),
        RadioButton.new("ans", @nums)
      ]
    end
  end

  class FindMinNumber < QuestionBase
    attr_accessor :nums
    def self.type
      "Minimum Num"
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
      "Order Nums +"
    end
    def prereq
      [[Chapter1::FindMinNumber, 1.0]]
    end

    def initialize()
      num_nums = rand(2) + 3 # between 3 and 5
      @nums = Array.new(num_nums).map { Grade6ops::rand_num }
    end

    def solve
      { "ans" => @nums.sort }
    end

    def text
      [ TextLabel.new("Drag the numbers in ascending order"),
        PermutationDrag.new("ans", @nums)
      ]
    end
  end

  class ArrangeDescending < QuestionBase
    attr_accessor :nums
    def self.type
      "Order Nums -"
    end
    def prereq
      [[Chapter1::FindMaxNumber, 1.0]]
    end

    def initialize()
      num_nums = rand(2) + 3 # between 3 and 5
      @nums = Array.new(num_nums).map { Grade6ops::rand_num }
    end

    def solve
      { "ans" => @nums.sort.reverse }
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
      "Writing Numbers"
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
      "Writing Numbers International"
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
      "Adding Commas"
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
        end
        ct+=1
      end
      ret
    end

    def text
      inl=[]
      for i in 0...@num.to_s.length
        inl << TextLabel.new(@num.to_s[i])
        inl << Checkbox.new("ans#{i}", "")
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
      {"ans" => @num.int_commas}
    end

    def text
      [ TextLabel.new("Add commas to this number according to the International System of Numeration"),
        TextField.new("ans", @num)
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
      "Reading Numbers"
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
      "Rounding Nums"
    end

    def initialize(num = nil)
      @num = num.nil? ? Grade6ops::rand_num(0.1, 4, 8) : num
    end

    def solve
      {"ans" => @num.gen_rule}
    end

    def text
      [ TextLabel.new("Round #{@num} using the General Rule"), 
        TextField.new("ans")
      ]
    end

    def explain
      [ Subproblem.new( [
          TextLabel.new("A \"round number\" has all 0's after the first digit.  To round off #{@num}, we pick the closest round number, which is #{@num.gen_rule}") ], {} )
      ]
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
      [ TextLabel.new("Convert #{@num.to_roman} to Hindu-Arabic Numerals"),
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
    Chapter1::FindMaxNumber,      Chapter1::FindMinNumber,        
    Chapter1::ArrangeAscending,   Chapter1::ArrangeDescending,  
    Chapter1::WritingIndian,      Chapter1::WritingInternational, 
    Chapter1::ReadingIndian,      Chapter1::ReadingInternational, 
    Chapter1::AddCommasIndian,    Chapter1::AddCommasInternational,    
    Chapter1::RoundingNumbers,
    Chapter1::EstimateAddition,   Chapter1::EstimateSubtraction,
    Chapter1::EstimateProduct,
    Chapter1::ToRoman,            Chapter1::ToArabic
  ]
end

