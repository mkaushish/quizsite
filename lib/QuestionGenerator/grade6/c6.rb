

#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'

require_relative '../tohtml'
require_relative './preg6'
include PreG6
include ToHTML

module Chapter6
  MAXCOMINT=30
  class CompareIntegers < QuestionBase
    def self.type
      "Compare Integers"
    end
    def initialize()
      @num1=-1*rand(MAXCOMINT)
      whi=rand(3)
      if whi==0
        @num2=@num1
      elsif whi==1
        @num2=rand(MAXCOMINT)
      else
        @num2=-1*rand(MAXCOMINT)
      end
    end
    def solve
      return {"ans" => '='} if @num1==@num2
      return {"ans" => '<'} if @num1<@num2
      return {"ans" => '>'}
    end
    def text
      [TextLabel.new("Place the appropriate symbol:"), TextLabel.new(@num1), Dropdown.new("ans", '=', '<', '>'), TextLabel.new(@num2)]

    end
  end
  MAXADDINT=250
  class AddIntegers < QuestionBase
    def prereq
      [[PreG6::Addition, 1.0], [PreG6::Addition, 1.0]]
    end

    def self.type
      "Add Integers"
    end
    def initialize(amt=2)
      @nums=[]
      @nums[0]=-1*rand(MAXADDINT)
      for i in 1...amt
        sign=rand(2)
        if sign==0
          @nums[i]=rand(MAXADDINT)
        else @nums[i]=-1*rand(MAXADDINT)
        end
      end
      @wh=rand(2)
    end
    def solve
      sum=0
      for i in 0...@nums.length
        sum+=@nums[i]
      end
      {"ans" => sum.to_s}
    end
    def text
      str=""
      if @wh==0
        str = "Find:  " + @nums[0].to_s
        for i in 1...@nums.length
          str += ' + '
          str +="("+ @nums[i].to_s+")"
        end
        
      else
        str += "Find the sum of "
        str += @nums[0].to_s
        for i in 1...(@nums.length-1)
          str += ','
          str += @nums[i].to_s
        end
        str += " and " 
        str += @nums[@nums.length-1].to_s
      end
      [TextLabel.new(str), TextField.new("ans")]
    end
  end
  MAXSUBINT=100
  class SubtractIntegers < QuestionBase
    def self.type
      "Subtract Integers"
    end
    def prereq
      [[PreG6::Addition, 1.0], [PreG6::Addition, 1.0]]
    end
    def initialize
      sign=rand(2)
      if sign==0
        @num1=rand(MAXSUBINT)
      else
        @num1=-1*rand(MAXSUBINT)
      end
      sign=rand(2)
      if sign==0
        @num2=rand(MAXSUBINT)
      else
        @num2=-1*rand(MAXSUBINT)
      end
      wh=rand(2)
    end
    def solve
      {"ans" => (@num1-@num2).to_s}
    end
    def text
      if @wh==0
        return [TextLabel.new("Subtract #{@num2} from #{@num1}"), TextField.new("ans")]
      else
        return [TextLabel.new("Find:  (#{@num1}) - (#{@num2})"), TextField.new("ans")]
      end
    end
  end
  MAXCOMAS=50
  class CompareAddSub < QuestionBase
    def self.type
      "Compare Integer Operations"
    end
    def prereq
      [[Chapter6::CompareIntegers, 0.5], [Chapter6::AddIntegers, 0.25], [Chapter6::SubtractIntegers, 0.25]]
    end
    def initialize
      amt1=rand(3)+2
      amt2=rand(3)+2
      @nums1=[]
      @nums2=[]
      for i in 0...amt1
        wh=rand(2)
        if wh==0
          @nums1[i]=-1*rand(MAXCOMAS)
        else
          @nums1[i]=rand(MAXCOMAS)
        end
      end
      for i in 0...amt2-1
        wh=rand(2)
        if wh==0
          @nums2[i]=-1*rand(MAXCOMAS)
        else
          @nums2[i]=rand(MAXCOMAS)
        end
      end
      sign=rand(3)
      if sign==0
        @nums2[amt2-1]=@nums1.reduce(:+)-@nums2.reduce(:+)
      elsif sign==1
        @nums2[amt2-1]=-1*rand(MAXCOMAS)
      else @nums2[amt2-1]=rand(MAXCOMAS)
      end
      @signs1=[]
      for i in 0...@nums1.length-1
        @signs1[i]=rand(2)
      end
      @signs2=[]
      for i in 0...@nums2.length-1
        @signs2[i]=rand(2)
      end
    end
    def solve
      if @nums2.reduce(:+)==@nums1.reduce(:+)
        return {"ans" => '='}
      elsif @nums1.reduce(:+)<@nums2.reduce(:+)
        return {"ans" => '<'}
      else return {"ans" => '>'}
      end
    end
    def text
      pr="Choose the appropriate symbol:  "
      str="(#{@nums1[0]})"
      for i in 1...@nums1.length
        if @signs1[i-1]==0
          str += ' + '
          str += "(#{@nums1[i]})"
        else 
          str += ' - '
          str += "(#{-1*@nums1[i]})"
        end
      end
      dr = Dropdown.new("ans", '=', '<', '>')
      str2 = "(#{@nums2[0]})"
      for i in 1...@nums2.length
        if @signs2[i-1]==0
          str2 += ' + '
          str2 += "(#{@nums2[i]})"
        else 
          str2 += ' - '
          str2 += "(#{-1*@nums2[i]})"
        end
      end
      [TextLabel.new(pr), TextLabel.new(str), dr, TextLabel.new(str2)]
    end
  end

  MAXASINT=100
  class AddSubIntegers < QuestionBase
    def self.type
      "Operations on Integers"
    end
    def prereq
      [[Chapter6::AddIntegers, 0.5], [Chapter6::SubtractIntegers, 0.5]]
    end
    def initialize(amt=rand(3)+2)
      @nums=[]
      for i in 0...amt
        wh=rand(2)
        if wh==0
          @nums[i]=-1*rand(MAXASINT)
        else
          @nums[i]=rand(MAXASINT)
        end
      end
      @signs=[]
      for i in 0...@nums.length-1
        @signs[i]=rand(2)
      end
    end
    def solve
      {"ans" => @nums.reduce(:+).to_s}
    end
    def text
      str="Find:  (#{@nums[0]})"
      for i in 1...@nums.length do
        if @signs[i-1]==0
          str += ' + '
          str += "(#{@nums[i]})"
        else 
          str += ' - '
          str += "(#{-1*@nums[i]})"
        end
      end
      [TextLabel.new(str), TextField.new("ans")]
    end
  end

PROBLEMS = [ Chapter6::AddIntegers,  Chapter6::SubtractIntegers,  Chapter6::CompareIntegers, Chapter6::CompareAddSub,  Chapter6::AddSubIntegers]
end



