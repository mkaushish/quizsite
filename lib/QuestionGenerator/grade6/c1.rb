#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml'


# TODO override preprocess for the add commas question ( default is now to remove commas )
include ToHTML

module Chapter1
  class FindMaxNumber < QuestionBase
    attr_accessor :nums
    @type = "Maximum Number"

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
    @type = "Minimum Number"

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
    @type = "Order Numbers"

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
    @type = "Order Numbers"

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
    @type = "Writing Numbers (Indian)"

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
    @type = "Writing Numbers (International)"

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
    @type = "Adding Commas (Indian)"

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
    @type = "Adding Commas (International)"

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
    @type = "Reading Numbers (International)"

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
    @type = "Reading Numbers (Indian)"

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

  class EstimateArithmetic < QuestionWithExplanation
    attr_accessor :op, :n1, :n2
    @type = "Estimating Arithmetic"

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

    def solve
      big = bigger
      small = smaller

      small = small.gen_rule
      big = big.round(small.to_s.length - 1)

      {"ans" => big.send(@op, small)}
    end

    def text
      [ TextLabel.new("Estimate the value of #{@n1} #{@op} #{@n2}"),
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
        Subproblem.new( [ TextLabel.new("First pick the smallest number, because we want to round off to the most significant digit of " + 
                                        "the smaller number"),
                          RadioButton.new("small", @n1, @n2)
                        ], {"small" => smaller}),
        Subproblem.new(  [ TextLabel.new("Now round off #{small} according to the general rule"),
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
    @type = "Converting To Roman Numerals"

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
    @type = "Converting To Arabic Numerals"

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
                #Chapter1::WritingIndian,      Chapter1::WritingInternational, 
                Chapter1::ReadingIndian,      Chapter1::ReadingInternational, 
                Chapter1::AddCommasIndian,    Chapter1::AddCommasInternational,    
                Chapter1::EstimateArithmetic, 
                Chapter1::ToRoman,            Chapter1::ToArabic
             ]
end
