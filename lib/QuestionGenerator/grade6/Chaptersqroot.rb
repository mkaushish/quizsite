#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml'
require_relative './preg6'
require_relative './c6'

require 'prime'
require 'set'
# TODO override preprocess for the add commas question ( default is now to remove commas )
include ToHTML
include PreG6
include Chapter6

module Chaptersqroot
  INDEX = "Chaptersqroot"
  TITLE = "Square and Square Root"
  class Perfectsquare < QuestionBase
  	def self.type
  		"Perfectsquare"
  	end
  	def initialize
  	    @numbr1= rand(50) + 1
  	    @numbr2=@numbr1*(@numbr1)
    end
    def solve
    	{"ans" => @numbr1}
    end
    def text
    	[TextLabel.new("Write the square root of the number"),InlineBlock.new("#{@numbr2}"),TextLabel.new(""),InlineBlock.new(TextLabel.new("Answer = "),TextField.new("ans"))]
    end
  end

  # class Pattern < QuestionBase
  # 	def self.type
  # 		"Missing number in pattern"
  # 	end
  # 	def initialize
  # 		@numbr1=rand(5) + 1
  # 		@numbr2=rand(10) + 1
  # 		@numbr3=0
  # 		@numbr4=0
  # 		j=0
  # 		i=0
  # 		# while (i==0)
  # 		# 	@numbr3=@numbr3 + 1

  # 		# 	 @numbr4=@numbr1 + @numbr2 + @numbr3
  # 		# 	 for j in @numbr4..100
  # 		# 	 	@numbr4_test=@numbr1**2 + @numbr2**2 + @numbr3**2
  # 		# 	 	if((j*j) == @numbr4_test)
  # 		# 	 		i=1
  # 		# 	 		@numbr4=j

  # 		# 	 		break
  # 		# 	 	end
  			 	
  # 		# 	 end
  			
  # 		# end
  # 	end
  # 	def solve
  # 		{"ans" => @numbr3}
  # 	end
  # 	def text
  # 		[TextLabel.new("Fill in the blank"),InlineBlock.new(Exponent.new(@numbr1,2),
  # 			TextLabel.new("+"),Exponent.new(@numbr2,2),TextLabel.new("+"),Exponent.new(TextField.new("ans"),2),TextLabel.new("="),Exponent.new(@numbr4,2))]
  # 	end
  # end
 


 class Countnumberexp < QuestionWithExplanation
 	def self.type
 		"Between squares "
 	end
 	def initialize
 		@numbr1= rand(30) + 1
 		@numbr2= @numbr1 + 1
 	end
 	def solve
 		{"ans" => @numbr2*@numbr2 - @numbr1*@numbr1 - 1}
 	end
 	def text
 		[TextLabel.new("How many numbers lie between square of the given numbers"),InlineBlock.new(TextLabel.new("#{@numbr1} and #{@numbr2}")),TextLabel.new(""),
 			InlineBlock.new(TextLabel.new("Answer"),TextField.new("ans"))]
 	end
  def explain
    [
      Subproblem.new([TextLabel.new("Find the squares of both the numbers and subtract the smaller square from bigger square and then subtract 1 from the result to exclude both the squares in count.")]),
      Subproblem.new([TextLabel.new("Suppose the numbers are 3 and 4")]),
      Subproblem.new([InlineBlock.new(Exponent.new(3,2),TextLabel.new(" = 9, "),Exponent.new(4,2),TextLabel.new(" = 16"))]),
      Subproblem.new([TextLabel.new("Numbers that lie between 16 and 9 are 19 - 6 - 1 = 6 excluding 16 and 9")])
    ]
  end
 end

 class Pythagortriplet2 < QuestionWithExplanation
 	def self.type
 		"Find pythagorean triplet 2"
 	end
 	def initialize
 		
 		@m= rand(18) + 2
    @numbr1=@m*2
 		@numbr2= @m*@m + 1
 		@numbr3= @m*@m - 1

    
 	end
 	def solve
 		{"ans1" => @numbr2,
         "ans2" => @numbr3}
  end
  def correct?(params)
    solsum = 0
    bool = true
    resps = QuestionBase.vars_from_response( *( (1...3).map { |i| "ans#{i}" }), params)
    puts "********\n" + resps.to_s + "********\n"
    (((resps[0].to_i)**2 - (resps[1].to_i)**2).abs == @numbr1**2)
  end

    def text
    	[TextLabel.new("Find a Pythagorean triplet in which one member is #{@numbr1}"),InlineBlock.new(TextField.new("ans1"),TextField.new("ans2"))]
    end
    def explain
      [
        Subproblem.new([TextLabel.new("There is a formula to find Pythagorean triplet"),
          InlineBlock.new(Exponent.new(TextLabel.new("(2m)"),2),TextLabel.new(" + "),TextLabel.new("("),Exponent.new(TextLabel.new("m"),2),Exponent.new(TextLabel.new("- 1 )"),2),
            TextLabel.new(" = "),TextLabel.new("("),Exponent.new(TextLabel.new("m"),2),Exponent.new(TextLabel.new("+ 1 )"),2))]),
        Subproblem.new([TextLabel.new("For example: if one member given is 4 then ")]),
        Subproblem.new([TextLabel.new("2m=4 => m = 2")]),
        Subproblem.new([TextLabel.new("Other two numbers can be calculated by the above given formulae")]),
        Subproblem.new([InlineBlock.new(TextLabel.new("2nd number =  ("),Exponent.new(2,2),TextLabel.new("- 1) = 3"))]),
        Subproblem.new([InlineBlock.new(TextLabel.new("3rd number = ("),Exponent.new(2,2),TextLabel.new("+ 1) = 5"))]),
        Subproblem.new([TextLabel.new("So, the Pythagorean triplets are 3 ,4 and 5")])
      ]
    end
end

class Subtractmethodexp2 < QuestionWithExplanation
  def self.type
    "Square-root by Subtraction2"
  end
 

  def initialize
    @numbr1= rand(25) + 1
    @numbr2=@numbr1*@numbr1
  end
  def solve
    {"ans" => @numbr1}
         
  end

  def text
      [TextLabel.new("Find the square root of #{@numbr2} by Repeated Subtraction method "),InlineBlock.new(TextField.new("ans"))]
    end
    def explain
      [
        Subproblem.new([TextLabel.new("Subtract the odd numbers starting from 1 from the original number and number of steps it takes for the number to become 0 is the square root of the number")]),
        Subproblem.new([TextLabel.new("For example: 25 is the number")]),
        Subproblem.new([TextLabel.new("1) 25 - 1 = 24")]),
        Subproblem.new([TextLabel.new("2) 24 - 3 = 21")]),
        Subproblem.new([TextLabel.new("3) 21 - 5 = 16")]),
        Subproblem.new([TextLabel.new("4) 16 - 7 = 9")]),
        Subproblem.new([TextLabel.new("5) 9 - 9 = 0")]),
        Subproblem.new([TextLabel.new("5 steps. Hence 5 is the square root")])
      ]
    end
end
SMALL_PRIMES=[2,3,5,7]

class Primefactorization < QuestionBase
  def self.type
    "Prime factorization"
  end
  def glev
    [7,8]
  end
  def initialize
    @num1=[4001]
    while @num1.reduce(:*)**2 > 4000
      for i in 0...rand(1)+3
       @num1 << SMALL_PRIMES.sample
       @num2=@num1
      end
    end
  end
  def solve
    {"ans" => (@num1.reduce(:*))}    
  end
  def text
      [TextLabel.new("Find the square root of #{(@num1.reduce(:*))**2} by Prime factorization"),TextField.new("ans")]
  end
end



class Makeperfect1exp < QuestionWithExplanation
  def self.type
    "Make it perfect square 1st part"
  end
  def glev
    [7,8]
  end
  def initialize
    @num1=[3001]
    
    while @num1.reduce(:*)**2 > 3000 
      @num1=[]
    for i in 0...rand(1)+3
      @num1 << SMALL_PRIMES.sample
   
    end
  end
    @numbr =[]
  
    @numbr = SMALL_PRIMES.sample(2)
    @num_sqr=(@num1.reduce(:*))**2
    @num_final=@num_sqr*(@numbr.reduce(:*))
   end
  def solve
    {"ans1" => @numbr[0],
      "ans2" => @numbr[1]}    
  end
  def correct?(params)
      solsum = 0
      bool = true
      resps = QuestionBase.vars_from_response( *( (1...3).map { |i| "ans#{i}" }), params)
      puts "********\n" + resps.to_s + "********\n"
      (resps[0].to_i)*(resps[1].to_i)*(@num_sqr)== @num_sqr*(@numbr.reduce(:*))
      
    end
  def text
      [TextLabel.new("Find the two numbers to multipy to make #{@num_final} number a perfect sqaure"),InlineBlock.new(TextField.new("ans1"),TextLabel.new("x"),TextField.new("ans2"))]
  end
  def explain
    [
      SubLabel.new("First Prime Factorize the number and then do pairing. The numbers which are not in pair should be multiplied to the original number which will give the perfect square.")
    ]
  end
end

class Makeperfect2exp2 < QuestionWithExplanation
  def self.type
    "Make it perfect square 2nd part 2"
  end
  def glev
    [7,8]
  end
  def initialize
    @num1=[3001]
    
    while @num1.reduce(:*)**2 > 3000 
      @num1=[]
    for i in 0...rand(1)+3
      @num1 << SMALL_PRIMES.sample
   
    end
  end
    @numbr =[]
  
    @numbr = SMALL_PRIMES.sample(2)
    @num_sqr=(@num1.reduce(:*))**2
    @num_final=@num_sqr*(@numbr.reduce(:*))
   end
  def solve
    {"ans1" => @numbr[0],
      "ans2" => @numbr[1]}    
  end
  def correct?(params)
      solsum = 0
      bool = true
      resps = QuestionBase.vars_from_response( *( (1...3).map { |i| "ans#{i}" }), params)
      puts "********\n" + resps.to_s + "********\n"
      (resps[0].to_i)*(resps[1].to_i)*(@num_sqr)== @num_sqr*(@numbr.reduce(:*))
      
    end
  def text
      [TextLabel.new("Find the two numbers to divide to make #{@num_final} number a perfect sqaure"),InlineBlock.new(TextField.new("ans1"),TextLabel.new("x"),TextField.new("ans2"))]
  end
  def explain
    [
      SubLabel.new("First Prime Factorize the number and then do pairing. The number which is not in pair should be divided to the original number which will give the perfect square.")
    ]
  end
end

Twod_prime=[7,11]
  	class Smallestsquareexp < QuestionWithExplanation
  def self.type
    "Smallest Square  "
  end
  def glev
    [7,8]
  end
  def initialize
    
   
      @rand_prim= Twod_prime.sample
    @rand_prod=[1,2,3,5].sample(3)
    @rand_prod_1= @rand_prod[0] * @rand_prod[1]
    @rand_prod_2=(@rand_prod[2])**2
        @ans=((@rand_prim)**2)* (@rand_prod_1**2)*@rand_prod_2
    
    @rand1=rand(3)+1
    if(@rand1==1)
      @numbr1=@rand_prim
    elsif(@rand1==2)
      @numbr1=@rand_prim*@rand_prod[2]
    else
      @numbr1=@rand_prim*@rand_prod_1
    end
    
    @rand1=rand(3)+1
    if(@rand1==1)
      @numbr2=@rand_prod_1
    elsif(@rand1==2)
      @numbr2=@rand_prod_1*@rand_prod[2]
    else
      @numbr2=@rand_prod_1**2
    end

     @rand1=rand(2)
    if(@rand1==1)
      @numbr3=@rand_prod_2*@rand_prod[rand(2)]
    else
      @numbr3=@rand_prod_2
    end
    
   end
  def solve
    {"ans" => @ans}    
  end
  
  def text
      [TextLabel.new("Find the smallest square number which is divisible by each of the numbers #{@numbr1},#{@numbr2},#{@numbr3}."),
        InlineBlock.new(TextField.new("ans"))]
  end
  def explain
    [
      Subproblem.new([TextLabel.new("This has to be done in two steps. First find the smallest common multiple and then find the square number needed. For example:-")]),
      Subproblem.new([TextLabel.new("Find the smallest square number which is divisible by each of the numbers 6, 9 and 15.")]),
      Subproblem.new([TextLabel.new("The least number divisible by each one of 6, 9 and 15 is their LCM. 
        The LCM of 6, 9 and 15 is 2 x 3 x 3 x 5 = 90. Prime factorisation of 90 is 90 = 2 x 3 x 3 x 5.")]),
      Subproblem.new([TextLabel.new("We see that prime factors 2 and 5 are not in pairs. Therefore 90 is not a perfect square. In order to get a perfect square, each factor of 90 must be paired. So we need to
make pairs of 2 and 5. ")]),
      Subproblem.new([TextLabel.new("Therefore, 90 should be multiplied by 2 x 5, i.e., 10. Hence, the required square number is 90 x 10 = 900.")])

    ]
  end
end	      	
       

PROBLEMS = [Chaptersqroot::Perfectsquare,
#Chaptersqroot::Pattern,
Chaptersqroot::Countnumberexp,
Chaptersqroot::Pythagortriplet2,
Chaptersqroot::Subtractmethodexp2,
Chaptersqroot::Primefactorization,
Chaptersqroot::Makeperfect1exp,
Chaptersqroot::Makeperfect2exp2,
Chaptersqroot::Smallestsquareexp]
end

