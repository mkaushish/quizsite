#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml'


include ToHTML

module PreG6
  class Addition < QuestionBase
    def initialize(nums = nil)
      if nums.nil?
        num_nums = rand(3)+2
        @nums = Array.new(num_nums) { rand(100) + 2 }
      else
        @nums = nums
      end
    end

    def solve
      return {"ans" => @nums.reduce(:+)}
    end

    def text
      [TextLabel.new(@nums.join(" + ")+" = "), TextField.new("ans")]
    end
  end

  class Subtraction < QuestionBase
    def initialize(num1 = nil, num2 = nil)
      @num1 = num1.nil? ? rand(100)+2 : num1
      @num2 = num2.nil? ? rand(@num1-2)+2 : num2
    end
    def solve
      return {"ans" => @num1-@num2}
    end
    def text
      [TextLabel.new("#{@num1} - #{@num2} = "), TextField.new("ans")]
    end
  end

  class Multiplication < QuestionBase
    def initialize(num1 = nil, num2 = nil)
      @num1 = num1.nil? ? rand(20)+2 : num1
      @num2 = num2.nil? ? rand(@num1-2)+2 : num2
    end
    def solve
      return {"ans" => @num1*@num2}
    end
    def text
      [TextLabel.new("#{@num1} x #{@num2} = "), TextField.new("ans")]
    end
  end
  
  class Division < QuestionBase
    def initialize(num1 = nil, num2 = nil)
      @num1 = num1.nil? ? rand(20)+2 : num1
      @num2 = num2.nil? ? @num1*rand(8) + 2 : num2
    end
    def solve
      return {"ans" => @num2/@num1}
    end
    def text
      [TextLabel.new("#{@num2} / #{@num1} = "), TextField.new("ans")]
    end
  end

  class IsDivisible < QuestionBase
    def initialize(num1 = nil, num2 = nil)
      num1 ||= rand(20) + 2
      num2 ||= num1 * rand(8) + 2 + Grade6ops::w_rand_dig(0.4, num1)
      @num1 = num1
      @num2 = num2
    end

    def solve
      return {"ans" => (@num2 % @num1 == 0 ? "yes" : "no")}
    end

    def text
      [
        TextLabel.new("Is #{@num2} divisible by #{@num1}?"),
        RadioButton.new("ans", "yes", "no"),
      ]
    end
  end

  PROBLEMS = [ 
    PreG6::Addition, 
    PreG6::Subtraction, 
    PreG6::Multiplication, 
    PreG6::Division, 
    PreG6::IsDivisible ]
end
