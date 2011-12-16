#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'

require_relative '../tohtml.rb'
require 'set'
include ToHTML

module Chapter3
  PRIMES = [2,3,5,7,11,13,17]
  ODDPRIMES = [3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73, 79, 83, 89, 97, 101, 103, 107,109,113,127,131,137,139,149,151,157,163,167,173,179,181,191,193,197,199,211,223,227,229,233,239,241]
  #first 20 odd primes


  class PrimeFactors < QuestionWithExplanation
    def initialize
      @nums = Array.new
      @len = rand(3)+4
      k = 0
      while k<@len do
        @nums[k] = PRIMES[rand(7)]
        k = k+1
      end
      @nums=@nums.sort
    end
    def solve
      {"ans" => @nums.sort}
    end
    def correct?(params)
      sol=solve()["ans"]
      so=[]
      for i in 0...sol.length do
        so[i]=HTMLObj::get_result("ans"+i.to_s, params).to_i
      end
      so.sort
      if sol==so
        return true
      end
      return false
    end  


    def explain  
      num=@nums.reduce(:*)
      ret=[]
      trac=[]
      for i in 0...PRIMES.length
        trac[i]=0
      end
      i=0
      while i<PRIMES.length
        if num==1
          break
        end
        curprime=PRIMES[i]
        if num % curprime==0
          ret << Subproblem.new([TextLabel.new("Does #{curprime} divide #{num} with no remainder?"), RadioButton.new("iprime"+curprime.to_s+"no"+trac[i].to_s, an=TextField.new("prime"+curprime.to_s+"no"+trac[i].to_s,"Yes. Divide #{num} by #{curprime}"), "No")], {"iprime"+curprime.to_s+"no"+trac[i].to_s => an, "prime"+curprime.to_s+"no"+trac[i].to_s => num/curprime})   
          num=num/curprime

          trac[i]+=1

        else
          ret << Subproblem.new([TextLabel.new("Does #{curprime} divide #{num} with no remainder?"), RadioButton.new("iprime"+curprime.to_s+"no"+trac[i].to_s, TextField.new("prime"+curprime.to_s+"no"+trac[i].to_s,"Yes. Divide #{num} by #{curprime}"), "No")], {"iprime"+curprime.to_s+"no"+trac[i].to_s => "No"})   
          i+=1

        end
      end
      ret << Subproblem.new(TextLabel.new("Since we have reached 1, the process of Prime Factorization is complete. Hence, the prime factors of #{@nums.reduce(:*)} are #{@nums.join(", ")}"))

      ret
    end

    def text
      n = 0
      pro = 1
      while n<@len do
        pro = pro*@nums[n]
        n = n+1
      end
      [TextLabel.new("Give the Prime Factorization of #{pro}"), MultiTextField.new("ans")]
    end
  end

  class Factors < QuestionBase
    def initialize
      @nums = Array.new
      @len = rand(2)+3
      k = 0
      while k<@len do
        @nums[k] = PRIMES[rand(4)]
        k = k+1
      end
    end
    def solve
      {"ans" => Grade6ops::factors(@nums)}
    end
    def correct?(params)
      sol=solve()["ans"]
      so=[]
      for i in 0...sol.length do
        so[i]=HTMLObj::get_result("ans"+i.to_s, params).to_i
      end
      so.sort
      if sol==so
        return true
      end
      return false
    end  
    def text
      n = 0
      pro = 1
      while n<@len do
        pro = pro*@nums[n]
        n = n+1
      end
      [TextLabel.new("Give the Factors of #{pro}"), MultiTextField.new("ans")]
    end
  end


  class CommonFactors < QuestionBase
    def initialize
      @nums1 = []
      @nums2 = []
      @len1 = rand(2)+3
      @len2 = rand(2)+3
      for i in 0...@len1 do
        @nums1[i] = PRIMES[rand(4)]
      end
      for i in 0...@len2 do
        @nums2[i] = PRIMES[rand(4)]
      end
    end
    def solve
      fac1 = Set.new(Grade6ops::factors(@nums1))
      fac2 = Set.new(Grade6ops::factors(@nums2))
      {"ans" => fac1.intersection(fac2)}
    end
    def correct?(params)
      sol=solve()["ans"]
      so=[]
      for i in 0...sol.length do
        so[i]=HTMLObj::get_result("ans"+i.to_s, params).to_i
      end
      so.sort
      if sol==so
        return true
      end
      return false
    end  

    def text
      num1 = 1
      for i in 0...@len1  
        num1 = num1*@nums1[i]
      end
      num2 = 1
      for i in 0...@len2  
        num2 = num2*@nums2[i]
      end
      [TextLabel.new("Give the common factors of #{num1} and#{num2}"), MultiTextField.new("ans")]
    end
  end

  class Div_39 < QuestionWithExplanation

    def initialize(div=(rand(2)+1))
      #div is the power of three. Choices are 1,2.
      @sdiv = div
      @num =Grade6ops::divgen(3**div)
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
    def explain
      [Subproblem.new([TextLabel.new("Add the digits of #{@num}"), TextField.new("sumdig", "Sum of digits")], {"sumdig" => solve["sum"]}),
        Subproblem.new([TextLabel.new("Does #{3**@sdiv} divide #{solve["sum"]}"), RadioButton.new("div", "Divisible", "Not Divisible")],{"div" => solve["divisible"]}),
        Subproblem.new([TextLabel.new("Since #{solve["sum"]} is #{solve["divisible"]} by #{3**@sdiv}, #{@num} is #{solve["divisible"]} by #{3**@sdiv}")])]  
    end

    def text
      [TextLabel.new("Test if #{@num} is divisible by #{3**@sdiv}"), TextField.new("sum", "Important Information"), Dropdown.new("divisible", "Divisible", "Not Divisible")]
    end
  end

  class Div_248 < QuestionWithExplanation
    def initialize(div=(rand(3)+1))
      #div is the power of 2. Choices are 1,2,3  
      @sdiv = div
      @num =Grade6ops::divgen(2**div)
    end
    def solve
      lastd = @num-(@num/(10**@sdiv))*(10**@sdiv)
      k = "Not Divisible"
      k = "Divisible" if lastd.to_f/(2**@sdiv) == lastd/(2**@sdiv)
      return {"lastdigit" => lastd.to_s,
        "divisible" => k}
    end
    def text
      [TextLabel.new("Test if #{@num} is divisible by #{2**@sdiv}"), TextField.new("lastdigit", "Important Information"), Dropdown.new("divisible", "Divisible", "Not Divisible")]
    end
    def explain
      if @sdiv!=1
        ret=[Subproblem.new(["What are the last #{@sdiv} digits of  #{@num}", TextField.new("lastdig", "Last #{@sdiv} digit(s)")], {"lastdig" => solve["lastdigit"]})]
      else
        ret=[Subproblem.new(["What is the last digit of  #{@num}", TextField.new("lastdig", "Last #{@sdiv} digit(s)")], {"lastdig" => solve["lastdigit"]})]
      end
      ret << Subproblem.new(["Does #{2**@sdiv} divide #{solve["lastdigit"]}", RadioButton.new("div", "Divisible", "Not Divisible")],{"div" =>solve["divisible"]})
      ret <<   Subproblem.new([TextLabel.new("Since #{solve["lastdigit"]} is #{solve["divisible"]} by #{2**@sdiv}, #{@num} is #{solve["divisible"]} by #{2**@sdiv}")])
      ret  
    end
  end  

  class Div_5 < QuestionWithExplanation
    def initialize
      @num =Grade6ops::divgen(5)
    end
    def solve 
      lastd = @num-(@num/(10))*(10)
      k = "Not Divisible" 
      k = "Divisible" if lastd == 5 || lastd == 0
      return {"lastdigit" => lastd.to_s,
        "divisible" => k}
    end
    def text
      [TextLabel.new("Test if #{@num} is divisible by 5"), TextField.new("lastdigit", "Important Information"), Dropdown.new("divisible", "Divisible", "Not Divisible")]
    end

    def explain
      ret=[Subproblem.new(["What is the last digit of  #{@num}", TextField.new("lastdig", "Last digit")], {"lastdig" => solve["lastdigit"]})]
      if solve["divisible"]=="Divisible"
        ret << Subproblem.new([TextLabel.new("Since the last digit is #{solve["lastdigit"]}, #{@num} is divisible by 5")])
      else
        ret << Subproblem.new([TextLabel.new("Since the last digit is #{solve["lastdigit"]} and not 0 or 5, #{@num} is not divisible by 5")])
      end  
    end

  end

  class Div_10 < QuestionWithExplanation
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
      [TextLabel.new("Test if #{@num} is divisible by 10"), TextField.new("lastdigit", "Important Information"), Dropdown.new("divisible", "Divisible", "Not Divisible")]
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

  class Div_11 < QuestionBase
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
      [Subproblem.new([TextLabel.new("Give the sum of the odd numbered digits of #{@num} from the right"), TextField.new("odd")],{"odd" => @odddig.to_s}),
        Subproblem.new([TextLabel.new("Give the sum of the even numbered digits of #{@num} from the right"), TextField.new("even")],{"even" => @evendig.to_s})]
    end
    def text
      [TextLabel.new("Test if #{@num} is divisible by 11"), TextField.new("difference", "Important Information"), Dropdown.new("divisible", "Divisible", "Not Divisible")]
    end
  end

  class SumPrimes < QuestionBase
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
      @nums 
    end

    def correct?(params)
      solsum = 0
      bool = true
      for i in 0...@nums.length do
        bool = false if !ODDPRIMES.member?(HTMLObj::get_result("ans"+i.to_s, params).to_i)
        solsum+=HTMLObj::get_result("ans"+i.to_s, params)
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
  class HCFLCM < QuestionBase
    @@primes=[2,2,2,3,3,3,5,5,7,11]

    def initialize()

      @nums1=Array.new
      @pro1=MAXHL+1
      while @pro1 > MAXHL
        @len1=rand(3)+3
        for i in 0...@len1 do
          @nums1[i]=@@primes[rand(@@primes.length)]
        end
        @pro1=@nums1.reduce(:*)
      end
      @nums2=Array.new
      @pro2=MAXHL+1
      while @pro2 >MAXHL
        @len2=rand(3)+3
        for i in 0...@len2 do
          @nums2[i]=@@primes[rand(@@primes.length)]
        end
        @pro2=@nums2.reduce(:*)
      end
      @nums1=@nums1.sort
      @nums2=@nums2.sort
    end
    def solve
      @comm=[]
      js=0
      for i in 0...@nums1.length
        for j in js...@nums2.length
          if @nums1[i]==@nums2[j]
            @comm << @nums1[i]
            js+=1
            break
          end
        end
      end

      hcf=@comm.reduce(:*)
      lcm=(@pro1*@pro2)/hcf
      return {"hcf" => hcf,
        "lcm" => lcm}
    end
    def explain
      solve
      h1={}
      h2={}
      co={}
      for i in 0...@nums1.length
        h1["pro1"+i.to_s]=@nums1[i]
      end
      for i in 0...@nums2.length
        h2["pro2"+i.to_s]=@nums2[i]
      end
      for i in 0...@comm.length
        co["comm"+i.to_s]=@comm[i]
      end
      ret=[Subproblem.new([TextLabel.new("Write out the prime factorization of #{@pro1}"), MultiTextField.new("pro1")], h1),
        Subproblem.new([TextLabel.new("Write out the prime factorization of #{@pro2}"), MultiTextField.new("pro2")], h2),
        Subproblem.new([TextLabel.new("Find the common prime factors of #{@pro1}=#{@nums1.join("*")} and #{@pro2}=#{@nums2.join("*")}"), MultiTextField.new("comm")], co),  
      Subproblem.new([TextLabel.new("The common Factors are #{@comm.join(", ")}. The HCF is the product of all the common factors. Hence HCF=#{@comm.join("*")}=#{solve["hcf"]}. The LCM is the product of the two original numbers, #{@pro1} and #{@pro2} divided by the HCF. Hence LCM=#{solve["lcm"]}")])]
    end
    def text
      [TextLabel.new("Give the HCF and LCM of #{@pro1} and #{@pro2}"), TextField.new("hcf", "HCF"), TextField.new("lcm", "LCM")] 
    end
  end


  PROBLEMS = [  Chapter3::PrimeFactors,    Chapter3::Factors,  Chapter3::CommonFactors,
    Chapter3::Div_39, Chapter3::Div_248, Chapter3::Div_5, Chapter3::Div_10, Chapter3::Div_11,
    Chapter3::SumPrimes, Chapter3::HCFLCM
  ]
end
