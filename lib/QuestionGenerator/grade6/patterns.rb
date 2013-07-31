#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'

require_relative '../tohtml.rb'
require_relative './preg6'
include PreG6
require 'set'
include ToHTML
module Patterns
  INDEX = 'patterns'
  TITLE = "Patterns"
  class Series1 < QuestionBase
  	def self.type
  		"Series 1"
  	end
    def initialize
    	@div=rand(23)+1
    	@ini=@div
    	@num=rand(6)+3
    end
    def solve
      {"ans" => @ini+(@num)*@div}
    end
    def text
      [TextLabel.new("What comes next?"), TextLabel.new((@ini...(@ini+@div*(@num))).step(@div).to_a.join(", ")), TextField.new("ans")]
    end
  end
  class Series2 < QuestionBase
  	def self.type
  		"Series 2"
  	end
    def initialize
    	@ini=rand(50)
    	@div=rand(23)
    	@num=rand(6)+3
    end
    def solve
      {"ans" => @ini+(@num)*@div}
    end
    def text
      [TextLabel.new("What comes next?"), TextLabel.new((@ini...(@ini+@div*(@num))).step(@div).to_a.join(", ")), TextField.new("ans")]
    end
  end
  class Series3 < QuestionBase
    def self.type
      "Series 3"
    end
    def initialize
      @ini1=rand(50)+1
      @ini2=rand(50)+1
      @div=rand(23)
      @num=rand(6)+3
    end
    def solve
      {"ans" => @ini+(@num)*@div}
    end
    def text
      [TextLabel.new("What comes next?"), TextLabel.new((@ini...(@ini+@div*(@num))).step(@div).to_a.join(", ")), TextField.new("ans")]
    end
  end
  class Series4 < QuestionBase
  end
end
