#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml'
require_relative './preg6'

# TODO override preprocess for the add commas question ( default is now to remove commas )
include ToHTML
include PreG6

module Chaptersqroot
  INDEX = "Chaptersqroot"
  TITLE = "Square and Square roots"
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
 


 class Countnumber < QuestionBase
 	def self.type
 		"Between squares"
 	end
 	def initialize
 		@numbr1= rand(30) + 1
 		@numbr2= @numbr1 + 1
 	end
 	def solve
 		{"ans" => @numbr2*@numbr2 - @numbr1*@numbr1}
 	end
 	def text
 		[TextLabel.new("How many numbers lie between square of the given numbers"),InlineBlock.new(TextLabel.new("#{@numbr1} and #{@numbr2}")),TextLabel.new(""),
 			InlineBlock.new(TextLabel.new("Answer"),TextField.new("ans"))]
 	end
 end

 class Pythagortriplet < QuestionBase
 	def self.type
 		"Find pythagorean triplet "
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
end

class Subtractmethod < QuestionBase
  def self.type
    "Square-root by Subtraction"
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
end
SMALL_PRIMES=[2,3,5,7,11,13]

class Primefactorization < QuestionBase
  def self.type
    "Prime factorization"
  end
  def glev
    [7,8]
  end
  def initialize
    @num1=[3001]
    
    while @num1.reduce(:*)**2 > 3000 
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



class Makeperfect < QuestionBase
  def self.type
    "Make it perfect square "
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
      [TextLabel.new("Find the two numbers to multipy/divide to make #{@num_final} number a perfect sqaure"),InlineBlock.new(TextField.new("ans1"),TextLabel.new("x"),TextField.new("ans2"))]
  end
end

Twod_prime=[7,11,13,17]
  	class Smallestsquare < QuestionBase
  def self.type
    "Smallest Square "
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
end	      	
       

PROBLEMS = [Chaptersqroot::Perfectsquare,
#Chaptersqroot::Pattern,
Chaptersqroot::Countnumber,
Chaptersqroot::Pythagortriplet,
Chaptersqroot::Subtractmethod,
Chaptersqroot::Primefactorization,
Chaptersqroot::Makeperfect,
Chaptersqroot::Smallestsquare]
end

