#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml'


include ToHTML

module PreG6
  class Addition

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

  class Subtraction
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


  class Multiplication
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


  
  class Division
    def initialize(num1 = nil, num2 = nil)
      @num1 = num1.nil? ? rand(20)+2 : num1
      @num2 = num2.nil? ? @num1*rand(8+2) : num2
    end
    def solve
      return {"ans" => @num2/@num1}
    end
    def text
      uni='\U000F7'
      [TextLabel.new("#{@num2} / #{@num1} = "), TextField.new("ans")]
    end
  end
end
