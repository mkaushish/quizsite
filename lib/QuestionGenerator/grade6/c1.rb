#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml'
require_relative './preg6'



# TODO override preprocess for the add commas question ( default is now to remove commas )
include ToHTML
include PreG6

module Chapter1
  class FindMaxNumber < QuestionBase
    attr_accessor :nums
    def self.type
      "Maximum Num"
    end

    def initialize()
      num_nums = rand(3) + 3 # between 3 and 5
      @nums = Array.new(num_nums).map { Grade6ops::rand_num }
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

    def initialize()
      num_nums = rand(3) + 3 # between 3 and 5
      @nums = Array.new(num_nums).map { Grade6ops::rand_num }
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
      "Order Nums"
    end
    def prereq
      [[Chapter1::FindMinNumber, 1.0]]
    end

    def initialize()
      num_nums = rand(3) + 3 # between 3 and 5
      @nums = Array.new(num_nums).map { Grade6ops::rand_num }
    end

    def solve
      @nums.sort
    end

    def text
      raise "ArrangeAscending not fully implemented"
      "Put the numbers in descending order:\n#{@nums.join("\t")}"
    end
  end

  class ArrangeDescending < QuestionBase
    attr_accessor :nums
    def self.type
      "Order Nums"
    end
    def prereq
      [[Chapter1::FindMaxNumber, 1.0]]
    end

    def initialize()
      num_nums = rand(3) + 3 # between 3 and 5
      @nums = Array.new(num_nums).map { Grade6ops::rand_num }
    end

    def solve
      @nums.sort
    end

    def text
      raise "ArrangeDescending not fully implemented"
      "Put the numbers in descending order:\n#{@nums.join("\t")}"
    end
  end

  class WritingIndian < QuestionBase
    attr_accessor :num
    def self.type
      "Writing Nums (I)"
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
      "Writing Nums"
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

  class AddCommasIndian < QuestionBase
    attr_accessor :num
    def self.type
      "Adding Commas (I)"
    end

    def initialize
      @num = Grade6ops::rand_num
    end

    def solve
      {"ans" => @num.ind_commas}
    end

    def text
      [ TextLabel.new("Add commas to this number according to the Indian System of Numeration:"),
        TextField.new("ans", @num)
      ]
    end
  end

  class AddCommasInternational < QuestionBase
    attr_accessor :num
    def self.type
      "Adding Commas"
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
  end

  class ReadingInternational < QuestionBase
    attr_accessor :num
    def self.type
      "Reading Nums"
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
      "Reading Nums (I)"
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

  class GeneralRule < QuestionBase
    def initialize
      @num=rand(10000+10)
    end
    def solve
      {"ans" => @num.gen_rule}
    end
    def text
      [TextLabel.new("Round #{@num} using the General Rule"), TextField.new("ans")]
    end
  end


  class EstimateArithmetic < QuestionWithExplanation
    attr_accessor :op, :n1, :n2
    def self.type
      "Gen Rule Est"
    end

    def bigger
      (@n1 > @n2) ? n1 : n2
    end

    def smaller
      (@n1 > @n2) ? n2 : n1
    end

    def initialize
      @op = Grade6ops::random_elt(:+, :-, :*)
      min = (@op == :*) ? 2 : 3
      max = (@op == :*) ? 4 : 5
      @n1 = Grade6ops::rand_num(0.01, min, max)
      @n2 = Grade6ops::rand_num(0.01, min, max)

      swap if (@op == :-) && @n2 > @n1
    end
    def prereq
      gen=[[Chapter1::GeneralRule, 1.0]]
      
      return gen + [[PreG6::Multiplication, 0.0]] if (@op==:*) 
      return gen + [[PreG6::Addition, 0.0]] if (@op==:+)
      return gen + [[PreG6::Subtraction, 0.0]]
      
    end


    def solve
      big = bigger
      small = smaller

      small = small.gen_rule
      big = big.round(small.to_s.length - 1)

      {"ans" => big.send(@op, small)}
    end

    def text
      [ TextLabel.new("Estimate the value of #{@n1} #{@op} #{@n2} using the General Rule"),
        TextField.new("ans")
      ]
    end

    def explain
      small = smaller
      big = bigger
      small_round = small.gen_rule
      big_round = big.round(small.to_s.length - 1)
      solution = big_round.send(@op, small_round)

      return [ 
        Subproblem.new( [ TextLabel.new("First pick the smallest number, because we need to round off to the most significant digit of " + 
                                        "the smaller number"),
                                        RadioButton.new("small", @n1, @n2)
      ], {"small" => smaller}),
        Subproblem.new(  [ TextLabel.new("Now round off #{small} according to the general rule for rounding"),
                       TextField.new("small_round")
      ], {"small_round" => smaller.gen_rule}),
        Subproblem.new( [ TextLabel.new("Because #{small} is #{small.to_s.length} digits long, we need to round off the last " +
                                        "#{small.to_s.length - 1} digits of #{big}.  This gives us"),
                                        TextField.new("big_round")
      ], {"big_round" => bigger.round(small.to_s.length - 1)} ),
        Subproblem.new( [ TextLabel.new("Finally, we can calculate the answer:"),
                       TextField.new("solution", "#{big_round} #{@op} #{small_round} = ")
      ], {"solution" => solution} )
      ]
    end

    private

    def swap
      tmp = @n1
      @n1 = @n2
      @n2 = tmp
    end
  end

  class ToRoman < QuestionBase
    attr_accessor :num
    def self.type
      "To Roman Nums"
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
  end

  class ToArabic < QuestionBase
    attr_accessor :num
    def self.type
      "To Arabic Nums"
    end

    def initialize
      @num=rand(Grade6ops::MAX_ROMANNUM - Grade6ops::MIN_ROMANNUM) + Grade6ops::MIN_ROMANNUM
    end
    def solve 
      {"ans" => @num} 
    end
    def  text
      [ TextLabel.new("Convert #{@num.to_roman} to Hindu-Arabic Numerals"),
        TextField.new("ans")
      ]
    end
  end

  # note that I have to be at the end to compile :(
  PROBLEMS = [  Chapter1::FindMaxNumber,      Chapter1::FindMinNumber,        
    #Chapter1::ArrangeAscending,    Chapter1::ArrangeDescending,  
    Chapter1::WritingIndian,      Chapter1::WritingInternational, 
    Chapter1::ReadingIndian,      Chapter1::ReadingInternational, 
    Chapter1::AddCommasIndian,    Chapter1::AddCommasInternational,    
    Chapter1::EstimateArithmetic, 
    Chapter1::ToRoman,            Chapter1::ToArabic, Chapter1::GeneralRule
  ]
end

