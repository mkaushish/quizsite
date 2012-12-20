
#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'

require_relative '../tohtml.rb'
require_relative './preg6'
include PreG6
require 'set'
include ToHTML
module Chapter9
  TITLE = "9: Data Handling"
  class BarQues < QuestionBase
    def initialize
      yr=rand(1900)+106
      nyrs=rand(4)+2
      @yrs=(yr..(yr+nyrs)).to_a
      @amts=Set.new()
      while (@amts.length <= nyrs)
        @amts << (rand(5)+1)*10
      end
      @amts=@amts.to_a
    end
    def solve
      {"ans1" => @yrs[@amts.index(@amts.max)],
      "ans2" => @yrs[@amts.index(@amts.min)]}
    end
    def text
      [TextLabel.new("Give the answers to the following questions by looking at the graph on wheat production between #{@yrs[0]} and #{@yrs[@yrs.length-1]}"), BarGraphLabel.new("nm", @yrs, @amts, {"editdivs" => false, "divs" => 10}), TextLabel.new("(a) The year with the maximum wheat production?"), TextField.new("ans1"), TextLabel.new("The year with the minimum wheat production"), TextField.new("ans2")]
    end
  end
  ACTIVITIES=["Playing", "Books", "TV", "Music", "Painting"]
  class CreateBar < QuestionBase
    def initialize
      @act=ACTIVITIES.sample(rand(4)+2)
      @amts=[]
      for i in 0...@act.length
        @amts[i]=(rand(9)+1)*5
      end
    end
    def solve
      {"ans" => @amts}
    end
    def text
      tab=TableField.new("tb", @act.length, 2)
      ar=[]
      for i in 0...@act.length
        tab.set_field(i, 0, TextLabel.new(@act[i]))
        tab.set_field(i, 1, TextLabel.new(@amts[i]))
        ar[i]=0
      end
      [TextLabel.new("Translate the given table into a bar graph taking the scale as 5 students per unit of length"), tab, BarGraphField.new("ans", @act, ar, {"editdivs" => true, "divs" => 5})]
    end
  end

  class TallyQues < QuestionBase
    def initialize
      yr=rand(1900)+106
      nyrs=rand(4)+2
      @yrs=(yr..(yr+nyrs)).to_a
      @amts=Set.new()
      while (@amts.length <= nyrs)
        @amts << (rand(20)+1)
      end
      @amts=@amts.to_a
    end
    def solve
      {"ans1" => @yrs[@amts.index(@amts.max)],
      "ans2" => @yrs[@amts.index(@amts.min)]}
    end
    def text
      [TextLabel.new("Give the answers to the following questions by looking at the tally marks on wheat production between #{@yrs[0]} and #{@yrs[@yrs.length-1]}"), TallyMarksLabel.new("nm", @yrs, @amts), TextLabel.new("(a) The year with the maximum wheat production?"), TextField.new("ans1"), TextLabel.new("The year with the minimum wheat production"), TextField.new("ans2")]
    end
  end
  ACTIVITIES=["Playing", "Books", "TV", "Music", "Painting"]
  class CreateTally < QuestionBase
    def initialize
      @act=ACTIVITIES.sample(rand(4)+2)
      @amts=[]
      for i in 0...@act.length
        @amts[i]=rand(20)+2
      end
    end
    def solve
      {"ans" => @amts}
    end
    def text
      tab=TableField.new("tb", @act.length, 2)
      ar=[]
      for i in 0...@act.length
        tab.set_field(i, 0, TextLabel.new(@act[i]))
        tab.set_field(i, 1, TextLabel.new(@amts[i]))
        ar[i]=0
      end
      [TextLabel.new("Translate the given table into tally marks"), tab, TallyMarksField.new("ans", @act, ar)]
    end
  end
      
  PROBLEMS=[Chapter9::CreateBar,
  Chapter9::BarQues,
  Chapter9::TallyQues,
  Chapter9::CreateTally]
end 

