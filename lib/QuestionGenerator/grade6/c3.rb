#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'

require_relative '../tohtml.rb'
require_relative './preg6'
include PreG6
require 'set'
include ToHTML
module Chapter3
  TITLE = "3: Playing with Numbers"
  SMALL_PRIMES    = [2, 3, 5, 7, 11, 13, 17]
  WEIGHTED_PRIMES = [2,2,2,2,2,3,3,3,3,5,5,5,7,7,11,13,17]

  ODDPRIMES = [3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73, 79, 83, 89, 97, 101, 103, 107,109,113,127,131,137,139,149,151,157,163,167,173,179,181,191,193,197,199,211,223,227,229,233,239,241]
  #first 20 odd primes

  class IdentifyPrimes < QuestionWithExplanation
    def self.type
      "Identify Primes"
    end
    def initialize(num = nil)
      if num.nil?
        if rand() < 0.4
          @num = ODDPRIMES.slice(0,24).sample
        else
          @num=rand(100+2)
        end
      else
        @num = num
      end
    end

    def solve
      return {"ans" => "True"} if ODDPRIMES.index(@num)!=nil
      return {"ans" => "False"}
    end

    def text
      [TextLabel.new("#{@num} is a prime: "), RadioButton.new("ans", ["True", "False"])]
    end

    def explain
      prime = (soln["ans"] == "True") ? "prime" : "not prime"
      [ SubLabel.new("A prime number is one that doesn't have any factors - which is to say nothing divides it.  Therefore the basic way to check if a number is prime is to check if anything divides it.  You don't actually have to check every single number - if you just check lower prime numbers, all the other numbers will get checked on their own.  It is probably easiest to memorize at least the lower primes.  #{@num} is #{prime}") ]
    end
  end

  class PrimeFactors < QuestionWithExplanation
    attr_accessor :nums
    def self.type
      "Prime Factorization"
    end

    def prereq
      [[Chapter3::IdentifyPrimes, 1.0]]
    end

    def initialize(nums=nil)
      if nums!=nil
        @nums=nums
      else
        len             = rand(3)+3
        begin
          @nums = Array.new(len) { |i| WEIGHTED_PRIMES.sample }
        end while @nums.reduce(:*) > 600 
      end
    end

    def solve
      {"ans" => @nums}
    end

    def explain  
      num  = @nums.reduce(:*)
      i    = 0
      p_no = 0 # for the soln indices

      ret  = [ Subproblem.new( [ TextLabel.new("To get the prime factors of a number, you have to go through the list of prime numbers.  On each prime number you check if your number is divisible by that prime.  If it is, you divide out the prime as many times as possible, and keep adding that prime to your list of factors.  Then you move on to the next prime.  We'll walk through these steps for the prime factors of #{num}") ], {} )
      ]

      SMALL_PRIMES.each do |curprime|
        break if num==1

        ret << PreG6::IsDivisible.new(curprime, num) unless curprime > num/2
        while num % curprime == 0 do
          if num == curprime
            ret << Subproblem.new( [ TextLabel.new("Since #{curprime} is prime, we know we've reached the end, and #{curprime} is the last prime factor.  Hence, the prime factors of #{@nums.reduce(:*)} are { #{@nums.join(", ")} }") ], {})
            return ret
          end

          ret << PreG6::Division.new(curprime, num, true)
          num      = num/curprime

          ret << PreG6::IsDivisible.new(curprime, num) unless (curprime > num/2)
        end
      end

      ret
    end

    def text
      pro = @nums.reduce(:*)
      [TextLabel.new("Give the Prime Factorization of #{pro}"), MultiTextField.new("ans")]
    end
  end


  class Factors < QuestionWithExplanation
    def self.type
      "Factorization"
    end
    def prereq
      [[Chapter3::PrimeFactors, 1.0]]
    end
    attr_accessor :nums
    def initialize
      len             = rand(2)+2
      highest_prime_i = 13
      @nums=[13, 13, 13, 13, 13]
      while @nums.reduce(:*) > 200
        @nums = Array.new(len) { |i| WEIGHTED_PRIMES.sample }
      end
    end

    def solve
      {"ans" => Grade6ops::factors(@nums)}
    end

    def text
      pro = @nums.reduce(:*)
      [TextLabel.new("Give the Factors of #{pro}"), MultiTextField.new("ans")]
    end

    def explain
      num  = @nums.reduce(:*)
      ret  = [ SubLabel.new("To find all the factors for a number, we go through all the numbers that divide that number.  Let's walk through how to do it for #{num}") ]
      facs = Grade6ops::factors(@nums)
      halffacs = facs[1,facs.length/2]

      ret << Subproblem.new([ TextLabel.new("The smallest number that divides #{num} is obviously 1"),  
                            TextLabel.new("1 x #{num} = #{num}"),
      TextLabel.new("Therefore 1 and #{num} are factors of #{num}") ], {} )

      halffacs.each do |fac|
        ret << Subproblem.new( [ TextLabel.new("What is the next smallest number that divides #{num}?"),
                              TextField.new("ans")
        ], {"ans" => fac } )
        ret << Subproblem.new( [ TextField.new("ans", "#{num} = #{fac} x ") ], {"ans" => num / fac } )
      end

      lastfac = facs[facs.length/2 + 1]
      ret << SubLabel.new("The next smallest divisor is #{lastfac}, which we've already seen.  That means we've reached the end, and the factors of #{num} are { #{@nums.join(", ")} }")
    end
  end


  class CommonFactors < QuestionWithExplanation
    def self.type
      "Common Factors"
    end
    def prereq
      [[Chapter3::Factors, 1.0]]
    end
    def initialize
      @f1=Chapter3::Factors.new()
      @f2=Chapter3::Factors.new()
      while @f1.nums.reduce(:*)==@f2.nums.reduce(:*)
        @f2=Chapter3::Factors.new()
      end
    end
    def explain
      [ @f1, @f2, 
        Subproblem.new([TextLabel.new("Which numbers are in both of the above lists?"), MultiTextField.new("ans")], soln),
        SubLabel.new("These are the common factors of #{@f1.nums.reduce(:*)} and #{@f2.nums.reduce(:*)}!")
      ]
    end
    def solve
      fac1 = Set.new(Grade6ops::factors(@f1.nums))
      fac2 = Set.new(Grade6ops::factors(@f2.nums))
      {"ans" => fac1.intersection(fac2).to_a}
    end

    def text
      [TextLabel.new("Give the common factors of #{@f1.nums.reduce(:*)} and #{@f2.nums.reduce(:*)}"), MultiTextField.new("ans")]
    end
  end

  class Div_39 < QuestionWithExplanation
    def self.type
      "Divisibility by 3 and 9"
    end

    def initialize(div=(rand(2)+1), num = nil)
      # sdiv is the power of three. Choices are 1,2.
      @sdiv = div

      num ||= Grade6ops::divgen(3**div)
      @num = num
    end

    def solve
      numstr = @num.to_s
      sumdig = 0
      for i in 0...numstr.length do
        sumdig += numstr[i].to_i
      end
      k = "Not Divisible"
      k = "Divisible" if sumdig.to_f/(3**(@sdiv)) == sumdig/(3**@sdiv)
      return {"sum" => sumdig.to_s,
        "divisible" => k}
    end

    def text
      [TextLabel.new("Test if #{@num} is divisible by #{3**@sdiv}"), TextField.new("sum", "Sum of Digits"), Dropdown.new("divisible", "Divisible", "Not Divisible")]
    end

    def explain
      [ Subproblem.new([TextLabel.new("Add the digits of #{@num}"), TextField.new("sumdig", "Sum of digits")], {"sumdig" => solve["sum"]}),
        Subproblem.new([TextLabel.new("Does #{3**@sdiv} divide #{solve["sum"]}"), RadioButton.new("div", "Divisible", "Not Divisible")],{"div" => solve["divisible"]}),
        Subproblem.new([TextLabel.new("Since #{solve["sum"]} is #{solve["divisible"]} by #{3**@sdiv}, #{@num} is #{solve["divisible"]} by #{3**@sdiv}")])]  
    end
  end

  class Div_3 < Div_39
    def self.type
      "Divisibility by 3"
    end

    def initialize(num = nil)
      super(1, num)
    end
  end

  class Div_9 < Div_39
    def self.type
      "Divisibility by 9"
    end
    def initialize(num = nil)
      super(2, num)
    end
  end

  class Div_248 < QuestionWithExplanation
    def self.type
      "Divisibility by 2, 4 and 8"
    end
    def initialize(div=(rand(3)+1), num = nil)
      #div is the power of 2. Choices are 1,2,3  
      @sdiv = div

      @num = num
      @num ||= Grade6ops::divgen(2**div)
    end
    def solve
      lastd = @num-(@num/(10**@sdiv))*(10**@sdiv)
      k = "Not Divisible"
      k = "Divisible" if lastd.to_f/(2**@sdiv) == lastd/(2**@sdiv)
      return {"lastdigit" => lastd.to_s,
        "divisible" => k}
    end
    def text
      [TextLabel.new("Test if #{@num} is divisible by #{2**@sdiv}"), TextField.new("lastdigit", "Last Digit"), Dropdown.new("divisible", "Divisible", "Not Divisible")]
    end
    def explain
      if @sdiv!=1
        ret=[Subproblem.new([TextLabel.new("What are the last #{@sdiv} digits of  #{@num}"), TextField.new("lastdig", "Last #{@sdiv} digit(s)")], {"lastdig" => solve["lastdigit"]})]
      else
        ret=[Subproblem.new([TextLabel.new("What is the last digit of  #{@num}"), TextField.new("lastdig", "Last #{@sdiv} digit(s)")], {"lastdig" => solve["lastdigit"]})]
      end
      ret << Subproblem.new([TextLabel.new("Does #{2**@sdiv} divide #{solve["lastdigit"]}"), RadioButton.new("div", "Divisible", "Not Divisible")],{"div" =>solve["divisible"]})
      ret << Subproblem.new([TextLabel.new("Since #{solve["lastdigit"]} is #{solve["divisible"]} by #{2**@sdiv}, #{@num} is #{solve["divisible"]} by #{2**@sdiv}")])
      ret  
    end
  end  

  class Div_2 < Div_248
    def self.type
      "Divisibility by 2"
    end
    def initialize(num = nil)
      super(1, num)
    end
  end

  class Div_4 < Div_248
    def self.type
      "Divisibility by 4"
    end
    def initialize(num = nil)
      super(2, num)
    end
  end

  class Div_8 < Div_248
    def self.type
      "Divisibility by 8"
    end

    def initialize(num = nil)
      super(3, num)
    end
  end

  class Div_5 < QuestionWithExplanation
    def self.type
      "Divisibility by 5"
    end

    def initialize
      @num =Grade6ops::divgen(5)
    end

    def solve 
      { "lastdigit" => @num.to_s.last,
        "divisible" => (@num % 5 == 0) ? "Divisible" : "Not Divisible"
      }
    end

    def text
      [TextLabel.new("Test if #{@num} is divisible by 5"), TextField.new("lastdigit", "Last Digit"), Dropdown.new("divisible", "Divisible", "Not Divisible")]
    end

    def explain
      final_ans = (@num % 5 == 0) ? "is" : "isn't"
      ret = [ Subproblem.new( [ TextLabel.new("A number is divisible by 5 if it's last digit is divisible by 5.  Theferore the last digit is the important piece of information.  Is #{@num.to_s.last} divisible by 5?"), 
                                Dropdown.new("ans", "Yes", "No")], {"ans" => (@num % 5 == 0) ? "Yes" : "No" }),

              SubLabel.new("Therefore #{@num} #{final_ans} divisible by 5")
      ]
    end
  end

  class Div_10 < QuestionWithExplanation
    def self.type
      "Divisibility by 10"
    end
    def initialize
      @num =Grade6ops::divgen(10)
    end
    def solve 
      lastd = @num-(@num/(10))*(10)
      k = "Not Divisible" 
      k = "Divisible" if lastd == 0
      return {"lastdigit" => lastd.to_s,
        "divisible" => k}
    end
    def text
      [TextLabel.new("Test if #{@num} is divisible by 10"), TextField.new("lastdigit", "Last Digit"), Dropdown.new("divisible", "Divisible", "Not Divisible")]
    end
    def explain
      ret=[Subproblem.new(["What is the last digit of  #{@num}", TextField.new("lastdig", "Last digit")], {"lastdig" => solve["lastdigit"]})]
      if solve["divisible"]=="Divisible"
        ret << Subproblem.new([TextLabel.new("Since the last digit is 0, #{@num} is divisible by 10")])
      else
        ret << Subproblem.new([TextLabel.new("Since the last digit is #{solve["lastdigit"]} and not 0, #{@num} is not divisible by 10")])
      end  
    end


  end

  class Div_11 < QuestionWithExplanation
    def self.type
      "Divisibility by 11"
    end

    def initialize
      @num =Grade6ops::divgen(11)
    end

    def solve 
      @odddig = 0
      @evendig = 0
      numstr = @num.to_s
      n = numstr.length-1
      while n >= 0 do
        @odddig+= numstr[n].to_i
        @evendig+=numstr[n-1].to_i if n>0
        n-=2
      end
      dif = @odddig-@evendig
      k = "Not Divisible"
      k = "Divisible" if dif.to_f/11==dif/11
      return {"difference" => dif.to_s,
        "divisible" => k}
    end

    def explain
      solve
      evens = []
      odds = []
      @num.to_s.split("").each_with_index { |n,i| (i % 2 == 0) ? odds << n : evens << n }
      
      final_ans = nil

      if((@odddig - @evendig) % 11 == 0 )
        final_ans = "Therefore #{@num} is divisible by 11. Remeber that 0 is divisible by everything!"
      else
        final_ans = "Therefore #{@num} is not divisible by 11"
      end

      [ SubLabel.new("To figure out if a number is divisible by 11, add up the even numbered digits counting from the right (#{evens.join(", ")}), and the odd numbered digits (#{odds.join(", ")})"),

        Subproblem.new([TextLabel.new("What is the sum of the odd numbered digits of #{@num} from the right?"),  TextField.new("odd") ], {"odd"  => @odddig.to_s }),

        Subproblem.new([TextLabel.new("Now give the sum of the even numbered digits of #{@num} from the right"), TextField.new("even")], {"even" => @evendig.to_s}),

        Subproblem.new( [ TextLabel.new("If the sum of the odds minus the sum of the evens is divisible by 11, then the number is divisible by 11."), 
                          TextField.new("n", "#{@odddig} - #{@evendig} = ")
                        ], { "n" => @odddig - @evendig } ),

        Subproblem.new( [ TextLabel.new("Is #{@odddig - @evendig} divisible by 11?"), RadioButton.new("ans", "yes", "no")
                        ], { "ans" => ((@odddig - @evendig) % 11 == 0) ? "yes" : "no" } ), 

        SubLabel.new(final_ans)

      ]
    end
    def text
      [TextLabel.new("Test if #{@num} is divisible by 11"), TextField.new("difference", "Difference of odd and even Digits"), Dropdown.new("divisible", "Divisible", "Not Divisible")]
    end
  end

  class Div_6 < QuestionWithExplanation
    def self.type
      "Divisibility by 6"
    end
    def initialize(num = nil)
      @num = num
      @num ||= Grade6ops::divgen(6)
    end

    def solve
      { "ans" => (@num % 6 == 0) ? "Divisible" : "Not Divisible" }
    end

    def text
      [ TextLabel.new("Test if #{@num} is divisible by 6"),  Dropdown.new("ans", "Divisible", "Not Divisible") ]
    end

    def explain
      ret = [ SubLabel.new("To check if a number is divisible by 6, you just have to check if it's divisible by 2 and 3"),
        Div_2.new(@num)
      ]
      if @num % 2 == 0 
        ret << Div_3.new(@num) 
        if @num % 3 == 0
          ret << SubLabel.new("Since #{@num} is divisible by both 2 and 3, it is also divisible by 6")
        else
          ret << SubLabel.new("Since #{@num} is not divisible by 3, it is also not divisible by 6")
        end
      else
        ret << SubLabel.new("Since #{@num} is not divisible by 2, it is also not divisible by 6")
      end
      ret
    end
  end

  class SumPrimes < QuestionBase
    def self.type
      "Sum of Primes"
    end
    def prereq
      [[Chapter3::IdentifyPrimes, 1.0], [PreG6::Addition, 0.0]]
    end

    def initialize(amt = rand(2) + 2)
      #amt is the number of primes to be added (2 or 3)

      @nums = []
      @sum = 0
      for i in 0...amt do
        curnum = ODDPRIMES[rand(20)]
        @nums << curnum
        @sum += curnum
      end
    end

    def solve
      ret = {}
      @nums.each_with_index { |num,i| ret["ans#{i}"] = num }
      ret
    end

    def correct?(params)
      solsum = 0
      bool = true
      resps = QuestionBase.vars_from_response( *( (0...@nums.length).map { |i| "ans#{i}" }), params)
      for i in 0...@nums.length do
        bool   &&= ODDPRIMES.member?(resps[i].to_i)
        solsum +=  resps[i].to_i
      end
      return true if bool && solsum==@sum
      return false
    end

    def text
      txt=[TextLabel.new("Express #{@sum} as the sum of #{@nums.length} odd primes")]
      for i in 0...@nums.length
        txt << TextField.new("ans"+i.to_s)
      end  
      txt
    end
  end



  MAXHL=500
  class HCF < QuestionWithExplanation
    def self.type
      "HCF"
    end
    def prereq
      [[Chapter3::PrimeFactors, 1.0], [PreG6::Multiplication, 0.0]]
    end

    def initialize(nums1=nil, nums2=nil, comm=nil)
      if(nums1!=nil && nums2!=nil && comm!=nil)
        @nums1=nums1
        @nums2=nums2
        @comm=comm
      else
        nms=Grade6ops.chCommPF
        @nums1=nms[0]
        @nums2=nms[1]
        @comm=nms[2]
      end
    end
    def solve
      hcf=@comm.reduce(:*)
      return {"hcf" => hcf}
    end

    def explain
      solve
      h1={}
      h2={}
      co={}
      for i in 0...@nums1.length
        h1["pro1_"+i.to_s]=@nums1[i]
      end
      for i in 0...@nums2.length
        h2["pro2_"+i.to_s]=@nums2[i]
      end
      for i in 0...@comm.length
        co["comm_"+i.to_s]=@comm[i]
      end
      ret=[Chapter3::PrimeFactors.new(@nums1), Chapter3::PrimeFactors.new(@nums2),
        Subproblem.new([TextLabel.new("What are the prime factors in common?"), MultiTextField.new("comm")], co),  
        Subproblem.new([TextLabel.new("The common prime factors are #{@comm.join(", ")}. The HCF is the product of all the common prime factors. What is the HCF?"), TextField.new("hcf")], {"hcf" => solve["hcf"]})]
    end

    def text
      [TextLabel.new("Give the HCF of #{@nums1.reduce(:*)} and #{@nums2.reduce(:*)}"), TextField.new("hcf", "HCF")] 
    end
  end

  class HCFEA < QuestionWithExplanation
    def initialize(num1=nil, num2=nil)
      if num1!=nil
        @num1=num1
        @num2=num2
      else
        comm=rand(10)+1
        @num1=comm*(rand(30)+1)
        @num2=comm*(rand(30)+1)
      end
    end
    def solve
      {"ans" => Grade6ops.euclideanalg(@num1, @num2)}
    end
    def explain
      max=[@num1, @num2].max
      min=[@num1, @num2].min
      ret=[Chapter1::FindMaxNumber.new([@num1, @num2])]
      while min!=0
        tm=PreG6::Division.new(min, max, false)
        ret << tm
        max=min
        min=tm.solve["rem"]
      end
      ret << Subproblem.new([TextLabel.new("The HCF is the divisor in the last step. Hence, the HCF is:"), TextField.new("ans")], solve)
      ret
    end
    def text
      [TextLabel.new("Give the HCF of #{@num1} and #{@num2} using the Euclidean Algorithm."), TextField.new("ans", "HCF")]
    end
  end

  class MultHCF < QuestionWithExplanation
    def self.type
      "HCF of 3+ numbers"
    end
    def initialize(nums=nil, comm=nil)
      if nums!=nil
        @nums=nums
        @comm=comm
      else
        @nums=[]
        @comm=[]
        ln=rand(3)+3
        nms=Grade6ops.chCommPF
        @nums[0]=nms[0]
        @nums[1]=nms[1]
        @comm[0]=nms[2]
        for i in 2...ln
          nms=Grade6ops.chCommPF(750, @comm[i-2])
          @nums[i]=nms[1]
          @comm[i-1]=nms[2]
        end
      end
    end
    def solve
      return {"hcf" => 1} if @comm[@comm.length-1].length==0
      {"hcf" => @comm[@comm.length-1].reduce(:*)}
    end
    def explain
      ret=[SubLabel.new("To find the HCF of multiple numbers, we find the HCF of the first 2 numbers. Now we take the HCF of the result we just got with the next number and so on."), Chapter3::HCF.new(@nums[0], @nums[1], @comm[0])]
      for i in 2...@nums.length
        ret << Chapter3::HCF.new(@comm[i-2], @nums[i], @comm[i-1])
      end
      ret
    end
    def text
      num=[]
      for i in 0...@nums.length
        num[i]=@nums[i].reduce(:*)
      end
      [TextLabel.new("Give the HCF of the following numbers: #{num.join(", ")}"), TextField.new("hcf", "HCF")]
    end
  end

  class MultHCFEA < QuestionWithExplanation
    def initialize(nums=nil)
      if nums!=nil
        @nums=nums
      else
        @nums=[]
        len=rand(2)+3
        comm=rand(10)+1
        for i in 0...len
          @nums[i]=(rand(15)+1)*comm
        end
      end
    end
    def solve
      hcf=Grade6ops.euclideanalg(@nums[0], @nums[1])
      for i in 2...@nums.length
        hcf=Grade6ops.euclideanalg(hcf, @nums[i])
      end
      {"ans" => hcf}
    end
    def explain
      ret=[]
      tm=Chapter3::HCFEA.new(@nums[0], @nums[1])
      ret << tm
      for i in 2...@nums.length
        tm= Chapter3::HCFEA.new(tm.solve["ans"], @nums[i])
        ret << tm
      end
      ret
    end
    def text
      [TextLabel.new("What is the HCF of the following: #{@nums.join(", ")}"), TextField.new("ans")]
    end
  end



  class LCM < QuestionWithExplanation
    attr_accessor :lcm
    def self.type
      "LCM"
    end
    def prereq
      [[Chapter3::PrimeFactors, 1.0], [PreG6::Multiplication, 0.0]]
    end

    def initialize(nums1=nil, nums2=nil, comm=nil)
      if(nums1!=nil && nums2!=nil && comm!=nil)
        @nums1=nums1
        @nums2=nums2
        @comm=comm
      else
        nms=Grade6ops.chCommPF
        @nums1=nms[0]
        @nums2=nms[1]
        @comm=nms[2]
      end
#      puts @comm
      @lnums1=Array.new(@nums1)
      com=Array.new(@comm)
      for j in 0...com.length
        for i in 0...@lnums1.length
          if com[j] == @lnums1[i]
            @lnums1.slice!(i)
            break
          end
        end
      end
      @lnums2=Array.new(@nums2)
      com=Array.new(@comm)
      for j in 0...com.length
        for i in 0...@lnums2.length
          if com[j] == @lnums2[i]
            @lnums2.slice!(i)
            break
          end
        end
      end
      @lcm=@lnums1+@comm+@lnums2
    end
    def solve
      lcm=@comm.reduce(:*)
      lcm=1 if @comm.length == 0
      if @lnums1.length == 0
        lcm*=1
      else lcm*=@lnums1.reduce(:*)
      end
      if @lnums2.length == 0
        lcm*=1
      else lcm*=@lnums2.reduce(:*)
      end
      return {"lcm" => lcm}
    end

    def explain
      solve
      h1={}
      h2={}
      co={}
      for i in 0...@lnums1.length
        h1["pro1_"+i.to_s]=@lnums1[i]
      end
      for i in 0...@lnums2.length
        h2["pro2_"+i.to_s]=@lnums2[i]
      end
      for i in 0...@comm.length
        co["comm_"+i.to_s]=@comm[i]
      end
      ret=[Chapter3::PrimeFactors.new(@nums1), Chapter3::PrimeFactors.new(@nums2),
        Subproblem.new([TextLabel.new("What are the prime factors in common?"), MultiTextField.new("comm")], co),
        Subproblem.new([TextLabel.new("What are the prime factors remaining in #{@nums1.reduce(:*)} once the common factors are removed (Do not count the common factors)."), MultiTextField.new("pro1")], h1),  
        Subproblem.new([TextLabel.new("What are the prime factors remaining in #{@nums2.reduce(:*)} once the common factors are removed (Do not count the common factors)."), MultiTextField.new("pro2")], h2),  
        Subproblem.new([TextLabel.new("The common prime factors are #{@comm.join(", ")}, the prime factors that make up #{@nums1.reduce(:*)} not including the common factors are #{@lnums1.join(", ")}, and the prime factors that make up #{@nums2.reduce(:*)} not including the common factors are #{@lnums2.join(", ")}. The LCM is the product of all of these prime factors. What is the LCM?"), TextField.new("lcm")], {"lcm" => solve["lcm"]})]
    end

    def text
      [TextLabel.new("Give the LCM of #{@nums1.reduce(:*)} and #{@nums2.reduce(:*)}"), TextField.new("lcm", "LCM")] 
    end
  end

  class LCMEA < QuestionWithExplanation
    def initialize(num1=nil, num2=nil)
      if num1!=nil
        @num1=num1
        @num2=num2
      else
        comm=rand(10)+1
        @num1=comm*(rand(20)+1)
        @num2=comm*(rand(20)+1)
      end
    end
    def solve
      {"ans" => (@num1*@num2)/Grade6ops.euclideanalg(@num1, @num2)}
    end
    def explain
      [Chapter3::HCFEA.new(@num1, @num2),
        SubLabel.new("Now you have to multiply the two numbers, #{@num1} and #{@num2}, and then divide the product by their HCF to get the LCM"),
      PreG6::Multiplication.new(@num1, @num2),
        PreG6::Division.new(Grade6ops.euclideanalg(@num1, @num2), (@num1*@num2), true)]
    end
    def text
      [TextLabel.new("Give the LCM of #{@num1} and #{@num2} using the Euclidean Algorithm to find the HCF."), TextField.new("ans", "LCM")]
    end
  end

  class MultLCM < QuestionWithExplanation
    def self.type
      "LCM of 3+ numbers"
    end
    def initialize(nums=nil, comm=nil)
      if nums!=nil
        @nums=nums
        @comm=comm
      else
        @nums=[]
        @comm=[]
        ln=rand(2)+3
        nms=Grade6ops.chCommPF(250)
        @nums[0]=nms[0]
        @nums[1]=nms[1]
        @comm[0]=nms[2]
        @tmp=Chapter3::LCM.new(@nums[0], @nums[1], @comm[0])
        for i in 2...ln
          @tmp=Chapter3::LCM.new(@tmp.lcm, @nums[i-1], @comm[i-2])
          nms=Grade6ops.chCommPF(250, @tmp.lcm)
          @nums[i]=nms[1]
          @comm[i-1]=nms[2]
        end
        @tmp=Chapter3::LCM.new(@tmp.lcm, @nums[@nums.length-1], @comm[@nums.length-2])
      end
    end
    def solve
      explain
      return {"lcm" => @lcm.solve["lcm"]} 
    end
    def explain
      ret=[SubLabel.new("To find the LCM of multiple numbers, we find the LCM of the first 2 numbers. Now we take the LCM of the result we just got with the next number and so on.") ]
      @lcm=Chapter3::LCM.new(@nums[0], @nums[1], @comm[0])
      ret << @lcm
      for i in 2...@nums.length
        @lcm=Chapter3::LCM.new(@lcm.lcm, @nums[i], @comm[i-1])
        ret << @lcm
      end
      ret
    end
    def text
      num=[]
      for i in 0...@nums.length
        num[i]=@nums[i].reduce(:*)
      end
      [ TextLabel.new("Give the LCM of the following numbers: #{num.join(", ")}"), 
        TextField.new("lcm", "LCM") 
      ]
    end
  end


  class MultLCMEA < QuestionWithExplanation
    def initialize(nums=nil)
      if nums!=nil
        @nums=nums
      else
        @nums=[]
        len=rand(2)+3
        comm=rand(10)+1
        for i in 0...len
          @nums[i]=(rand(15)+1)*comm
        end
      end
    end
    def solve
      hcf=Grade6ops.euclideanalg(@nums[0], @nums[1])
      for i in 2...@nums.length
        hcf=Grade6ops.euclideanalg(hcf, @nums[i])
      end
      {"ans" => @nums.reduce(:*)/(hcf**(@nums.length-1))}
    end
    def explain
      ret=[]
      tm=Chapter3::LCMEA.new(@nums[0], @nums[1])
      ret << tm
      for i in 2...@nums.length
        tm= Chapter3::LCMEA.new(tm.solve["ans"], @nums[i])
        ret << tm
      end
      ret
    end
    def text
      [TextLabel.new("What is the LCM of the following: #{@nums.join(", ")}"), TextField.new("ans")]
    end
  end


  PROBLEMS = [ Chapter3::IdentifyPrimes,  Chapter3::PrimeFactors,    Chapter3::Factors,  Chapter3::CommonFactors,
    Chapter3::Div_2, 
    Chapter3::Div_3, 
    Chapter3::Div_4, 
    Chapter3::Div_5, 
    Chapter3::Div_6,
    Chapter3::Div_8, 
    Chapter3::Div_9, 
    Chapter3::Div_10, 
    Chapter3::Div_11,
    Chapter3::SumPrimes, 
    Chapter3::HCF,
    Chapter3::MultHCF,
    Chapter3::LCM, 
    Chapter3::MultLCM
  ]
end
