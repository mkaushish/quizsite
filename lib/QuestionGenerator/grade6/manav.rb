
#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml'
require_relative './preg6'

# TODO override preprocess for the add commas question ( default is now to remove commas )
include ToHTML
include PreG6

module Manav
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

  PROBLEMS = [ Manav::ExpandNumbers1 ] 
end
