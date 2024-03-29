#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative './preg6'
include PreG6

include ToHTML
#TODO for predecessors and successors it should say first prdecessor/successsor rather than first 1 pre/successor
#TODO take pre/successors in any order (Not very important)
module Chapter2
  INDEX = 2
  TITLE = "Whole Numbers"
  PEOPLE = ["Sarita", "Balu", "Raju", "Ameena"]

  class WriteSuccessors < QuestionBase
    def self.type
      "Successors"
    end
    def initialize
      
      # TODO change this to better numbers that need successors
      @num = Grade6ops::rand_num(0.4, 2, 4) * 10**(rand(3) + 1) - 1
      @num += rand(2) + 1 if rand(2) == 0
      @num += rand(100) if rand(10) == 0
      @nsuccs = rand(3) + 1
    end

    def solve
      ret = {}
      for i in 1..@nsuccs
        ret["ans_#{i}"] = @num + i
      end
      ret
    end
    def explain
      str = ""
      if @nsuccs == 1
        str = "Hence, the first successor of #{@num} is #{@num + 1}."
      else
        succs = ((@num+1)..(@num+@nsuccs)).to_a.join(", ")
        str = "Hence, the first #{@nsuccs} successors of #{@num} are #{succs}."
      end
       
      [SubLabel.new("The successor of a number is the number which follows it. For example the successor of 1 is 2 and the first three successors of 1 are 2, 3 and 4. #{str}")]
    end

    def text
      if(@nsuccs > 1)
        ret = [ TextLabel.new("Write the first #{@nsuccs} successors to #{@num}") ]
      else 
        ret = [ TextLabel.new("Write the first successor to #{@num}") ]
      end
      for i in 1..@nsuccs
        ret << TextField.new("ans_#{i}", i.to_s + ".")
      end
      ret
    end
  end

  class WritePredecessors < QuestionBase
    def self.type
      "Predecessors"
    end
    def initialize
      # TODO change this to better numbers that need successors
      @num = Grade6ops::rand_num(0.4, 2, 4) * 10**(rand(3) + 1) + 1
      @num -= rand(2) - 1 if rand(2) == 0
      @num -= rand(100) if rand(10) == 0
      @nsuccs = rand(3) + 1
    end

    def solve
      ret = {}
      for i in 1..@nsuccs
        ret["ans_#{i}"] = @num - i
      end
      ret
    end
    def explain
      str="Hence, the first "
      str+="#{@nsuccs} " if @nsuccs > 1
      str+="predecessor"
      str+="s" if @nsuccs > 1
      str+=" of #{@num} "
      str+="is" if @nsuccs==1
      str+="are" if @nsuccs > 1
      for i in 1..@nsuccs
        str+=" #{@num-i}"
      end
      str+="."
      [SubLabel.new("The predecessor of a number is the number which comes before it. For example the predecessor of 4 is 3 and the first three predecessors of 4 are 3, 2 and 1. #{str}")]
    end

    def text
      if(@nsuccs > 1)
        ret = [ TextLabel.new("Write the first #{@nsuccs} predecessors to #{@num}") ]
      else 
        ret = [ TextLabel.new("Write the first predecessor to #{@num}") ]
      end
      for i in 1..@nsuccs
        ret << TextField.new("ans_#{i}", i.to_s + ".")
      end
      ret
    end
  end

  class NumOfNumbers < QuestionWithExplanation
    def self.type
      "Number Of Numbers"
    end
    def initialize
      @a = rand(100)+2
      @b = rand(100)+2
      while @b<@a do
       @b = rand(100)+2 
      end
      @c = @b-@a-1
    end

    def solve
     { 
      "ans1" => @b-@a-1
     }
    end
    
    def text
        [
          TextLabel.new("How many whole numbers are there between #{@a} and #{@b} ?"),
          TextField.new("ans1")
        ]
    end

    def explain
        [
          SubLabel.new("The number of numbers between #{@a} and #{@b} would be equal to #{@b}-#{@a}-1 which turns out to be #{@c}.")
        ]
    end
  end

  class Inequalities < QuestionWithExplanation
    def self.type
      "Inequalities Introduction"
    end
    def initialize
      @a = rand(1000)+2
      @b = rand(1000)+2
      @choose1 = @a-@b
    end

    def solve
     { 
      "ans1" => "#{@var}",
      "sign" => (@choose1 > 0) ? ">" : "<"
     }
    end

    def text
      [
        TextLabel.new("Choose the appropriate sign between the two numbers"),
        InlineBlock.new(TextLabel.new("#{@a} "),Dropdown.new("sign", ">", "<"),TextLabel.new("#{@b}"))
      ]
    end

   def explain
      if @choose1 < 0
        [
          SubLabel.new("Since a is less than b the correct symbol would be <.")
        ]
      else
        [
          SubLabel.new("Since a is more than b the correct symbol would be >.")
        ]
      end
    end
  end

  class StatementProblem < QuestionWithExplanation
    def self.type
      "StatementProblem"
    end
    def initialize
      @person = PEOPLE.sample
      @choose = rand(3)
      @a = rand(10)+25
      @b = rand(10)+2
      @c = rand(10)+40
      @cost = rand(10)+40
      @cost2 = rand(10)+20
      @days = rand(10)+2
      @choose1 = @a-@b
    end

    def solve
     if @choose==0
        { 
        "ans1" => (@a+@b)*@days,
        }
      elsif @choose==1
        {
          "ans1" =>(@a+@c)*@cost
        }
      elsif @choose==2
        {
          "ans1" =>(@a+@c)*@cost2
        }      
      end
    end

    def text
      if @choose==0
        [
          TextLabel.new("The school canteen charges Rs #{@a} for lunch and Rs #{@b} for milk for each day. How much money do you spend in #{@days} days on these things?"),
          TextField.new("ans1")
        ]
      elsif @choose==1
        [
          TextLabel.new("A taxidriver #{@person} filled his car petrol tank with #{@a} litres of petrol on Monday. The next day, he filled the tank with #{@c} litres of petrol. If the petrol costs Rs #{@cost} per litre, how much did he spend in all on petrol?"),
          TextField.new("ans1")
        ]
      elsif @choose==2
        [
          TextLabel.new("A vendor #{@person} supplies #{@a} litres of milk to a hotel in the morning and #{@c} litres of milk in the evening. If the milk costs Rs #{@cost2} per litre, how much money is due to the vendor per day?"),
          TextField.new("ans1")
        ]  
      end
    end

   def explain
      if @choose == 0
        [
          SubLabel.new("The total money spent would be equal to the product of number of days(#{@days}) with the sum of cost of lunch(#{@a}) and cost of milk#{@b}. Therefore total money spent is (#{@a}+#{@b})*#{@days}")
        ]
      elsif @choose==1
        [
          SubLabel.new("The total money spent would be equal to the product of cost of petrol(#{@cost}) with the sum of litres of petrol filled on Monday(#{@a}) and that filled on the next day(#{@c}). Therefore total money spent is (#{@a}+#{@c})*#{@cost}")
        ]
      elsif @choose==2
        [
          SubLabel.new("The total money spent would be equal to the product of cost of milk(#{@cost2}) with the sum of litres of milk supplied in the morning(#{@a}) and that supplied in the evening(#{@c}). Therefore total money spent is (#{@a}+#{@c})*#{@cost2}")
        ]  
      end
    end
  end



  class SuitableRearrangementSum < QuestionBase
    def self.type
      "Rearrange Sum"
    end

    def prereq
      [[PreG6::Addition,1.0]]
    end

    def initialize
      odd_summand  = (rand(70) + 20) * 10 + 1 + rand(9)

      @nice_summand = (rand(7) + 6) * 100 # 600-1200

      @part = rand(@nice_summand / 3) + (@nice_summand / 6)
      @part += 1 + rand(9) if @part % 10 == 0
      while ((@part + odd_summand) % 10 ==0 || (@nice_summand-@part + odd_summand) % 10 ==0)
        odd_summand  = (rand(70) + 20) * 10 + 1 + rand(9)
      end

      @summands = [ odd_summand, @nice_summand - @part, @part ].shuffle
    end

    def solve
      { 'ans' => [ "(",(@nice_summand - @part), "+", (@part), ") + ", (@summands.reduce(:+) - @nice_summand) ] }
    end

    def text
      [ TextLabel.new("Drag the numbers you would add first to the first two places below"), 
        PermutationDrag.new('ans', :"(", @summands[0], :"+", @summands[1], :") +", @summands[2])
      ]
    end

    def preprocess(name, response)
      response
    end

    def get_elts(sum)
      tmp = rand((sum * 0.75).to_i  - 11) + 11
      [tmp, sum - tmp]
    end

    def correct?(response)
      r = text[1].items_from(response)
      r[1].to_i + r[3].to_i == @nice_summand
    end
  end
  class DistComm < QuestionBase
    def self.type
      "Distributivity or Commutativity"
    end
    def initialize
      @type=["Commutativity of Addition", "Commutativity of Multiplication", "Distributivity of Multiplication over Addition"]
      @wh=rand(3)
      @nums=[rand(150)+1, rand(150)+1, rand(150)+1]
    end
    def solve
      {"ans" => @type[@wh]}
    end
    def text
      str=""
      n2=@nums.shuffle
      while n2==@nums
        n2=@nums.shuffle
      end
      if(@wh==0)
        str="#{@nums.join(" + ")} = #{n2.join(" + ")}"
      elsif @wh==1
        str="#{@nums.join(" x ")} = #{n2.join(" x ")}"
      else 
        str="#{@nums[0]} x #{@nums[1]+@nums[2]} = #{@nums[0]} x #{@nums[1]} + #{@nums[0]} x #{@nums[2]}"
      end
      [TextLabel.new("Which of the following does this statement represent:"), TextLabel.new(str), RadioButton.new("ans", @type)]
    end
  end


  class SuitableRearrangementProduct < QuestionBase
    def self.type
      "Rearrange Product"
    end

    def prereq
      [[PreG6::Multiplication,1.0]]
    end

    def initialize
      @nice_product = 10**(rand(2) + 3)
      @product_elts = get_elts(@nice_product)
      @random_elt   = Grade6ops::rand_num(0.01, 2, 3)
      while @random_elt % 5 == 0
        @random_elt   = Grade6ops::rand_num(0.01, 2, 3)
      end
      @nums = (@product_elts + [@random_elt]).shuffle
    end

    def solve
      { 'ans' => [ "(",@product_elts[0], "*", @product_elts[1], ") * ", @random_elt ] }
    end

    def text
      [ TextLabel.new("Drag the numbers you would multiply first to the first two places below"), 
        PermutationDrag.new('ans', :"(", @nums[0], :"*", @nums[1], :") *", @nums[2])
      ]
    end

    def preprocess(name, response)
      response
    end

    def correct?(response)
      r = text[1].items_from(response)
      r[1].to_i * r[3].to_i == @nice_product
    end

    def get_elts(prod)
      pow = prod.to_s.length - 1
      pow2 = rand(pow + 1)
      pow5 = ((3 * pow / 2 + 1) - pow2) / 2

#      #puts "pow5 = #{pow5}, pow2 = #{pow2}"
      [(2**pow2) * (5**pow5), (2**(pow - pow2)) * (5**(pow - pow5))]
    end
  end
  PLACES=["Ones", "Tens", "Hundreds", "Thousands", "Ten Thousands"]
  class PlacesNum < QuestionBase
    def self.type
      "Translate to Number"
    end
    def initialize
      @num=(1...10).to_a.sample(rand(3)+2)
    end
    def solve
      {"ans" => @num.reverse.join("")}
    end
    def text
      str=[]
      for i in 0...@num.length
        str[i]=""+@num[i]+" "+PLACES[i]
      end
      [TextLabel.new("Find the value of: "), TextLabel.new(str.shuffle.join(" plus ")), TextField.new("ans")]
    end
  end



  class AddLargeNumbers < QuestionBase
    def self.type
      "Add Large Numbers"
    end
    def initialize
      @num1=rand(100000)+10000
      @num2=rand(100000)+10000
    end
    def prereq
      [[PreG6::Addition,1.0]]
    end
    def solve
      return {"ans" => (@num1+@num2).to_s}
    end
    def explain
      st1=@num1.to_s
      st2=@num2.to_s
      len1=st1.length
      len2=st2.length 
      if @num2 < @num1
        slen=len2
        blen=len1
      else 
        slen=len1
        blen=len2
      end
      st=(@num1+@num2).to_s
      ret=[]
      for i in 0...slen
        tab=TableField.new("tab_#{st.length-i-1}", 5, blen+2)
        for j in 0...len1
          tab.set_field(1, blen+1-j, st1[len1-1-j])
        end
        for j in 0...len2
          tab.set_field(2, blen+1-j, st2[len2-1-j])
        end
        for j in 0...blen+2
          tab.set_field(3, j, "_")
        end
        for j in 0...i
          tab.set_field(4, blen+1-j, st[st.length-1-j])
        end
        if i > 0
#          puts ((st1[len1-i].to_i+st2[len2-i].to_i)/10).to_s
          tab.set_field(0, blen+1-i, ((st1[len1-i].to_i+st2[len2-i].to_i)/10).to_s)
        end 
        tab.set_field(4, blen+1-i, TextField.new("sum_#{st.length-i-1}"))
        tab.set_field(0, blen-i, TextField.new("rem_#{st.length-i-1}"))
        tab.set_field(2, 0, "+")
#        puts tab
        ret << Subproblem.new([tab], {"sum_#{st.length-1-i}" => st[st.length-i-1], "rem_#{st.length-1-i}" => ((st1[len1-1-i].to_i+st2[len2-1-i].to_i)/10).to_s})
      end
      for i in slen...blen
        tab=TableField.new("tab_#{st.length-i-1}", 5, blen+2)
        for j in 0...len1
          tab.set_field(1, blen+1-j, st1[len1-1-j])
        end
        for j in 0...len2
          tab.set_field(2, blen+1-j, st2[len2-1-j])
        end
        for j in 0...blen+2
          tab.set_field(3, j, "_")
        end
        for j in 0...i
          tab.set_field(4, blen+1-j, st[st.length-1-j])
        end
        if i == slen
          tab.set_field(0, blen+1-i, ((st1[len1-i].to_i+st2[len2-i].to_i) % 10).to_s)
        end 
        tab.set_field(4, blen+1-i, TextField.new("sum_#{st.length-i-1}"))
        tab.set_field(2, 0, "+")
        ret << Subproblem.new([tab], {"sum_#{st.length-1-i}" => st[st.length-i-1]})
      end
      if st.length > blen
       tab=TableField.new("tab_#{0}", 5, blen+2)
        for j in 0...len1
          tab.set_field(1, blen+1-j, st1[len1-1-j])
        end
        for j in 0...len2
          tab.set_field(2, blen+1-j, st2[len2-1-j])
        end
        for j in 0...blen+2
          tab.set_field(3, j, "_")
        end
        for j in 0...st.length-1
          tab.set_field(4, blen+1-j, st[st.length-1-j])
        end
        tab.set_field(0, blen-st.length+2, st[0])
        tab.set_field(4, blen+2-st.length, TextField.new("sum_#{0}"))
        tab.set_field(2, 0, "+")
        ret << Subproblem.new([tab], {"sum_#{0}" => st[0]}) 
      end
      ret
    end
    def text
      [TextLabel.new("Find:"), AddingField.new("ans", @num1, @num2, "+")]
    end
  end


  PROBLEMS = [  
    Chapter2::WriteSuccessors,            Chapter2::WritePredecessors,
    Chapter2::NumOfNumbers,
    Chapter2::Inequalities,
    Chapter2::StatementProblem,
    Chapter2::DistComm,
    Chapter2::AddLargeNumbers 
  ]

end
