#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative './preg6'
include PreG6

include ToHTML
#TODO for predecessors and successors it should say first prdecessor/successsor rather than first 1 pre/successor
#TODO take pre/successors in any order (Not very important)
module Chapter2
  class WriteSuccessors < QuestionBase
    def self.type
      "Successors"
    end
    def initialize
      
      # TODO change this to better numbers that need successors
      @num = Grade6ops::rand_num(0.4, 2, 4) * 10**(rand(3) + 1) - 1
      @num += rand(2) + 1 if rand(2) == 0
      @num += rand(100) if rand(10) == 0
      @nsuccs = rand(3) + 1
    end

    def solve
      ret = {}
      for i in 1..@nsuccs
        ret["ans_#{i}"] = @num + i
      end
      ret
    end
    def explain
      str = ""
      if @nsuccs == 1
        str = "Hence, the first successor of #{@num} is #{@num + 1}."
      else
        succs = ((@num+1)..(@num+@nsuccs)).to_a.join(", ")
        str = "Hence, the first #{@nsuccs} successors of #{@num} are #{succs}."
      end
       
      [SubLabel.new("The successor of a number is the number which follows it. For example the successor of 1 is 2 and the first three successors of 1 are 2, 3 and 4. #{str}")]
    end

    def text
      if(@nsuccs > 1)
        ret = [ TextLabel.new("Write the first #{@nsuccs} successors to #{@num}") ]
      else 
        ret = [ TextLabel.new("Write the first successor to #{@num}") ]
      end
      for i in 1..@nsuccs
        ret << TextField.new("ans_#{i}", i.to_s + ".")
      end
      ret
    end
  end

  class WritePredecessors < QuestionBase
    def self.type
      "Predecessors"
    end
    def initialize
      # TODO change this to better numbers that need successors
      @num = Grade6ops::rand_num(0.4, 2, 4) * 10**(rand(3) + 1) + 1
      @num -= rand(2) - 1 if rand(2) == 0
      @num -= rand(100) if rand(10) == 0
      @nsuccs = rand(3) + 1
    end

    def solve
      ret = {}
      for i in 1..@nsuccs
        ret["ans_#{i}"] = @num - i
      end
      ret
    end
    def explain
      str="Hence, the first "
      str+="#{@nsuccs} " if @nsuccs > 1
      str+="predecessor"
      str+="s" if @nsuccs > 1
      str+=" of #{@num} "
      str+="is" if @nsuccs==1
      str+="are" if @nsuccs > 1
      for i in 1..@nsuccs
        str+=" #{@num-i}"
      end
      str+="."
      [SubLabel.new("The predecessor of a number is the number which comes before it. For example the predecessor of 4 is 3 and the first three predecessors of 4 are 3, 2 and 1. #{str}")]
    end

    def text
      if(@nsuccs > 1)
        ret = [ TextLabel.new("Write the first #{@nsuccs} predecessors to #{@num}") ]
      else 
        ret = [ TextLabel.new("Write the first predecessor to #{@num}") ]
      end
      for i in 1..@nsuccs
        ret << TextField.new("ans_#{i}", i.to_s + ".")
      end
      ret
    end
  end

  class RearrangementHelper < QuestionBase
    # create nums - the array of summands (following examples will assume sum question, but can be
    #                                        generalized to pruduct question)
    # each elt is either an array of size 2, or a fixnum
    #      Fixnum: this element can't be part of the answer
    #
    #     Array:  [ summand, group num ] : if the two numbers chosen are arrays of the same group num,
    #                                       the answer is correct
    def init_nums(sums, which = -1)
      # determine the number of summands each sum will be broken into
      sizes = Array.new(2)
      @nums = []

      if which == 0 || which == 1
        sizes[which] = 2
        sizes[1 - which] = 1
      else
        tmp = rand(2)
        sizes[tmp] = 2
        sizes[1-tmp] = rand(2)+1
      end

      sums.each_index do |i|
        if sizes[i] == 2
          get_elts(sums[i]).each { |elt| @nums << [elt, i] }
        else
          @nums << sums[i]
        end
      end

      @nums.shuffle!
    end

    # produces a hash where the possible answers point to their group numbers (see init_nums)
    def solve
      ans = {}
      @nums.each_with_index do |n, i|
        if n.is_a? Array
          ans[n[0]] = n[1]
        end
      end
      ans
    end

    def num_array
      if @num_array.nil?
        @num_array = ""
        @nums.each_with_index do |n, i|
          @num_array += ", " unless i == 0
          @num_array += "#{n}" if n.is_a? Fixnum
          @num_array += "#{n[0]}" if n.is_a? Array
        end
      end
      @num_array
    end

    # TODO currently takes an answer in the form of an array... need to change this when I
    # get some rails basics working
    def correct?(ans)
      return false unless ans.is_a?(Array) && ans.length == 2
      soln = solve
      soln[ans[0]] == soln[ans[1]]

    end

    def ans_format
      "Array 2"
    end
  end

  class SuitableRearrangementSum < RearrangementHelper
    def self.type
      "Rearrange Sum"
    end
    def prereq
      [[PreG6::Addition,1.0]]
    end


    def initialize
      sums = Array.new(2).map { rand(90) * 10**2 + 1000 }
      init_nums(sums)
    end

    # solve defined in RearrangementHelper

    def text
      "Write out the numbers that you would add together first out of the following: #{num_array}"
    end

    def get_elts(sum)
      tmp = rand((sum * 0.75).to_i  - 11) + 11
      [tmp, sum - tmp]
    end
  end

  class SuitableRearrangementProduct < RearrangementHelper
    def self.type
      "Rearrange Product"
    end
    def prereq
      [[PreG6::Multiplication,1.0]]
    end
    def initialize
      nums = [10**(rand(3) + 2), Grade6ops::rand_num(0.01, 3, 4)]
      init_nums(nums, 0)
    end

    # solve defined in RearrangementHelper

    def text
      "Write out the numbers that you would multiply together first out of the following: #{num_array}"
    end

    def get_elts(prod)
      pow = prod.to_s.length - 1
      tpow = rand(pow/2)
      fpow = pow - rand(tpow / 2 + 1)

      if rand(2) == 0
        tmp = tpow
        tpow = fpow
        fpow = tmp
      end

      puts "fpow = #{fpow}, tpow = #{tpow}"
      [(2**tpow) * (5**fpow), (2**(pow - tpow)) * (5**(5 - fpow))]
    end
  end

  class AddLargeNumbers < QuestionBase
    def self.type
      "Add Large Numbers"
    end
    def initialize
      @num1=rand(100000)+10000
      @num2=rand(100000)+10000
    end
    def prereq
      [[PreG6::Addition,1.0]]
    end
    def solve
      return {"ans" => (@num1+@num2).to_s}
    end
    def text
      [TextLabel.new("Find:"), AddingField.new("ans", @num1, @num2, "+")]
    end
  end

  PROBLEMS = [  
    Chapter2::WriteSuccessors,            Chapter2::WritePredecessors,
    #Chapter2::SuitableRearrangementSum,   Chapter2::SuitableRearrangementProduct, 
    Chapter2::AddLargeNumbers 
  ]

end
