
#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'

require_relative '../tohtml.rb'
require_relative './preg6'
include PreG6
require 'set'
include ToHTML
module Chapter9
  ACTIVITIES=[["Rice Only", "Wheat Only", "Both"],["English Only", "Maths Only", "Stutied Both"],["Coffee Only","Tea Only","Both"],
  ["Watched TV Only","Played Cricket Only","Done Both"], ["Played Cricket","Played Soccer","Played Both"],["Gold medal","Silver medal","Bronze medal"]]
  INDEX = 9
  TITLE = "Data Handling"
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
  class CreateBar < QuestionBase
    def initialize
      @act=ACTIVITIES.sample()
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
      [TextLabel.new("Translate the given table into a bar graph taking the scale as 5 per unit of length"), tab, BarGraphField.new("ans", @act, ar, {"editdivs" => true, "divs" => 5})]
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
  class CreateTally < QuestionBase
    def initialize
      @act=ACTIVITIES.sample()
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
      [TextLabel.new("Translate the given table into tally marks"),
       tab,
        TallyMarksField.new("ans", @act, ar)
      ]
    end
  end

  class TallyQuesEasy < QuestionWithExplanation
    def initialize
      yr=rand(106)+1900
      nyrs=3
      @rand_index = rand(3)
      @yrs=ACTIVITIES.sample
      @amts=Set.new()
      while (@amts.length <= nyrs)
        @amts << (rand(20)+1)
      end
      @amts=@amts.to_a
    @ans = @amts[@rand_index]
    @ques = @yrs[@rand_index]
    @for_explanation1 = ["One","Two","Three","Four","Five"]
    @for_explanation2 = [1,2,3,4,5]
    @for_explanation2 = @for_explanation2.to_a
    end
    def solve
      {"ans1" => @ans}
    end
    def explain
    [
      Subproblem.new([TextLabel.new("Refer the following table to solve such problems:"),TallyMarksLabel.new("nm1", @for_explanation1, @for_explanation2)])
    ]
    end
    def text
      [TextLabel.new("Give the answers to the following questions by looking at the tally marks:"), TallyMarksLabel.new("nm", @yrs, @amts), TextLabel.new("The people who had #{@ques}"), TextField.new("ans1")]
    end
  end

 PRODUCTS = [["2000","2001","2002","2003","2004"],["1900","1901","1902","1903","1904","1905"],["2004","2005","2006","2007"],
 ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],["Hindi","English","Mathematics","Science","Social Science"],
 ["Yellow Shirts","Black Shirts","White Shirts","Grey Shirts","Blue Shirts"]]
 DESCRIPTION = ["Wheat production in","Rice production in","Bat sales in","T-shirt sales on","Marks in","Sales of"]
    class BarQuesEasy < QuestionWithExplanation
    def initialize
      @yrs= PRODUCTS.sample()
      nyrs= @yrs.size()
      @rand_index = rand(nyrs)
#      @yrs=(yr..(yr+nyrs)).to_a
      @amts=Set.new()
      while (@amts.length <= nyrs)
        @amts << (rand(10)+1)*10
      end
    @amts=@amts.to_a
    @ans = @amts[@rand_index]
    @ques = @yrs[@rand_index]
    @for_explanation1 = [2000,2001]
    @for_explanation2 = [50,20]
    @for_explanation1 = @for_explanation1.to_a
    @describe = DESCRIPTION[PRODUCTS.index(@yrs)]
    end
    def solve
      {"ans1" => @ans}
    end
    def explain
        [
      Subproblem.new([TextLabel.new("Refer the following Example to solve such problems:"),BarGraphField.new("nm1", @for_explanation1, @for_explanation2, {"editdivs" => false, "divs" => 10}), TextLabel.new("The above Bar graph can be read as 50 in year 2000, 20 in year 2001")])
    ]
    end
    def text
      [TextLabel.new("Give the answers to the following questions by looking at the graph:"), BarGraphLabel.new("nm", @yrs, @amts, {"editdivs" => false, "divs" => 10}), TextLabel.new("#{@describe} #{@ques}"), TextField.new("ans1")]
    end
  end

class BarQuesEasy2 < QuestionWithExplanation
  def initialize
      @yrs=PRODUCTS.sample()
      nyrs= @yrs.size()
      @yrs = @yrs.to_a
      @rand_index1 = rand(nyrs)
      @rand_index2 = rand(nyrs)
      if @rand_index1 == @rand_index2
        @rand_index2 = (@rand_index1 +1)%3
      end  
  #    @yrs=(yr..(yr+nyrs)).to_a
      @amts=Set.new()
      while (@amts.length <= nyrs)
        @amts << (rand(10)+1)*10
      end
      @amts=@amts.to_a
      @ans = (@amts[@rand_index2] - @amts[@rand_index1]).abs
      @ques1 = @yrs[@rand_index1]
      @ques2 = @yrs[@rand_index2]
      @for_explanation1 = [2000,2001]
      @for_explanation2 = [50,20]
      @for_explanation1 = @for_explanation1.to_a
      @describe = DESCRIPTION[PRODUCTS.index(@yrs)]
  end
  def solve
    {"ans1" => @ans}
  end
  def explain
    [Subproblem.new([TextLabel.new("Refer the following Example to solve such problems:"),BarGraphField.new("nm1", @for_explanation1, @for_explanation2, {"editdivs" => false, "divs" => 10}), TextLabel.new("The above Bar graph can be read as 50 in year 2000, 20 in year 2001")])]
  end
  def text
    [TextLabel.new("Give the answers to the following questions by looking at the graph"), BarGraphLabel.new("nm", @yrs, @amts, {"editdivs" => false, "divs" => 10}), TextLabel.new("Difference in #{@describe} #{@ques1} & #{@ques2} (absolute value)"), TextField.new("ans1")]
  end
end


class TallyQuesEasy2 < QuestionWithExplanation
  def initialize
    yr=rand(106)+1900
    nyrs=3
    @rand_index1 = rand(3)
    @rand_index2 = rand(3)
    if @rand_index1 == @rand_index2
      @rand_index2 = (@rand_index1 +1)%3
    end  
    @yrs=ACTIVITIES.sample()
    @amts=Set.new()
    while (@amts.length <= nyrs)
      @amts << (rand(20)+1)
    end
    @amts=@amts.to_a
    @ans = (@amts[@rand_index1] - @amts[@rand_index2]).abs
    @ques1 = @yrs[@rand_index1]
    @ques2 = @yrs[@rand_index2]
    @for_explanation1 = ["One","Two","Three","Four","Five"]
    @for_explanation2 = [1,2,3,4,5]
    @for_explanation2 = @for_explanation2.to_a
  end

  def solve
    {"ans1" => @ans}
  end
  def explain
    [Subproblem.new([TextLabel.new("Refer the following table to solve such problems:"),TallyMarksLabel.new("nm1", @for_explanation1, @for_explanation2)])]
    end
  def text
    [TextLabel.new("Give the answers to the following questions by looking at the tally marks:"), TallyMarksLabel.new("nm", @yrs, @amts), TextLabel.new("The difference in people who had #{@ques1} & #{@ques2} (absolute value)"), TextField.new("ans1")]
  end
end

ACTIVITIES=[["Rice", "Wheat", "Both"],["English", "Maths", "Stutied Both"],["Coffee","Tea","Both"],
  ["Watched TV","Played Cricket","Done Both"], ["Played Cricket","Played Soccer","Played Both"]]

  class TallyQuesEasy3 < QuestionWithExplanation
    def initialize
      yr=rand(106)+1900
      nyrs=3
      @rand_index = rand(2)
      @yrs=ACTIVITIES.sample
      @amts=Set.new()
      while (@amts.length < nyrs-1)
        @amts << (rand(20)+7)
      end
      @amts << (rand(6) + 1) 
      @amts=@amts.to_a
    @ans = @amts[@rand_index]
    @ques = @yrs[@rand_index]
    @for_explanation1 = ["One","Two","Three","Four","Five"]
    @for_explanation2 = [1,2,3,4,5]
    @for_explanation2 = @for_explanation2.to_a
    end
    def solve
      {"ans1" => @ans - @amts[2]}
    end
    def explain
    [
      Subproblem.new([TextLabel.new("Refer the following table to solve such problems:"),TallyMarksLabel.new("nm1", @for_explanation1, @for_explanation2)])
    ]
    end
    def text
      [TextLabel.new("Give the answers to the following questions by looking at the tally marks:"), TallyMarksLabel.new("nm", @yrs, @amts), TextLabel.new("The people who had #{@ques}"), TextField.new("ans1")]
    end
  end

  PROBLEMS=[Chapter9::CreateBar,
  Chapter9::BarQues,
  Chapter9::TallyQues,
  Chapter9::CreateTally,
  Chapter9::TallyQuesEasy,
  Chapter9::BarQuesEasy,
  Chapter9::BarQuesEasy2,
  Chapter9::TallyQuesEasy2,
  Chapter9::TallyQuesEasy3]
end