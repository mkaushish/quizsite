#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml'
require_relative './preg6'
require 'prime'

# TODO override preprocess for the add commas question ( default is now to remove commas )
include ToHTML
include PreG6

module Algebra
  INDEX = "algebra"
  TITLE = "Algebra"
  


  class Level_1 < QuestionBase
    def self.type
      "Level_1"
    end
    def initialize
      # @prod=rand(6)
      @a = rand(100)+1
      
        
      @b = rand(100)+1
    end
    def solve
     { "ans" => @b-@a }
    end
    def text
      [TextLabel.new("Find the value of x "), TextLabel.new("X  + #{@a} = #{@b}"),InlineBlock.new(TextLabel.new("Answer:"), TextField.new("ans"))]
    end
  end

  
  PROBLEMS = [
   Algebra::Level_1, 
    ] # //Anurag is module name and dummy is class name
end