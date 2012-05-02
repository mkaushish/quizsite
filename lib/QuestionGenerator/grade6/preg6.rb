#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml'


include ToHTML

module PreG6
  class Addition
    def initialize
      ln=rand(3)+2
      @nums=[]
      for i in 0...ln
        @nums.push(rand(100)+2)
      end
    end
    def solve
      return {"ans" => @nums.reduce(:*)}
    end
    def text
      [TextLabel.new(@nums.join(" + ")+" = "), TextField.new("ans")]
    end
  end

  class Subtraction
    def initialize
      @num1=rand(100)+2
      @num2=rand(@num1-2)+2
    end
    def solve
      return {"ans" => @num1-@num2}
    end
    def text
      [TextLabel.new("#{@num1} - #{@num2} = "), TextField.new("ans")]
    end
  end


  class Multiplication
    def initialize
      @num1=rand(20)+2
      @num2=rand(@num1-2)+2
    end
    def solve
      return {"ans" => @num1*@num2}
    end
    def text
      [TextLabel.new("#{@num1} x #{@num2} = "), TextField.new("ans")]
    end
  end


  
  class Division
    def initialize
      @num1=rand(20)+2
      @num2=@num1*rand(8+2)
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
