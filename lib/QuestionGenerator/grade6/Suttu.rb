
#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml'
require_relative './preg6'

# TODO override preprocess for the add commas question ( default is now to remove commas )
include ToHTML
include PreG6

module chapter27
  INDEX = 1
  TITLE = "Find Power"
  class findpower < QuestionBase
    def self.type
      "findpower"
    end
    def initialize
      @numbr=2
      @num=rand(10)+1
    end
    def solve
      {"ans" => @num}
    end
    def text
      [TextLabel.new("Calculate the power of 2 in the number:"), InlineBlock.new(TextLabel.new("#{(@numbr)**@num} = "), TextField.new("ans"))]
    end
  end

  PROBLEMS = [chapter27::findpower] 
end
