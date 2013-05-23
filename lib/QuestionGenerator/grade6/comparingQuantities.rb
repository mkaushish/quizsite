
#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml'
require_relative './preg6'
require 'prime'

# TODO override preprocess for the add commas question ( default is now to remove commas )
include ToHTML
include PreG6

module ComparingQuantities
  INDEX = "comparingQuantities" 
  TITLE = "Comparing Quantities"
   

   class FindPercent < QuestionWithExplanation
    def self.type
      "Find Percentage"
    end
    def initialize
		@factors = [1,2,4,5,10,20,25,50,100]
		@num2 = @factors.sample
		@num1 =  rand(@num2)
		if @num1 === 0
			@num1 = 1
		end	
		@mult = rand(99) +1
		@num = @num1*@mult
		@den = @num2*@mult

    end
    def solve
     { "ans" => (100/@num2)*@num1 }
    end
        def explain
      [Subproblem.new([TextLabel.new("To Find the percentage, you can take help from the the following example: "),TextLabel.new("26 out of 130 = (26/130)X100 = 20%")])]
    end
    def text
      [TextLabel.new("Find the Percentage: "), InlineBlock.new(TextLabel.new("#{@num} out of #{@den} = "),TextField.new("ans"),TextLabel.new("%"))]
    end
  end


   class FindValue < QuestionWithExplanation
    def self.type
      "Find the value"
    end
    def initialize
		@factors = [1,2,4,5,10,20,25,50,100]
		@num2 = @factors.sample
		@num3 = 100/@num2
		@num1 =  rand(@num2)
		if @num1 === 0
			@num1 = 1
		end	

		@mult = rand(99) +1
		@num = @num1*@num3
		@den = @num2*@mult

    end
    def solve
     { "ans" => (@num*@den)/100 }
    end
def explain
      [Subproblem.new([TextLabel.new("To Find the value, you can take help from the following example: "),TextLabel.new("20% of 130 = (20/100)X130 = 26")])]
    end
    def text
      [TextLabel.new("Find the value:"), InlineBlock.new(TextLabel.new("#{@num}% of #{@den} = "),TextField.new("ans"))]
    end
  end

class Discount < QuestionWithExplanation
    def self.type
      "Discount"
    end
    def initialize
		@factors = [1,2,4,5,10,20,25,50,100]
		@num2 = @factors.sample
		@num1 =  rand(@num2)
		if @num1 === 0
			@num1 = 1
		end	
		@mult = rand(99) +1
		@num = @num1*@mult
		@den = @num2*@mult
    @diff = @den - @num
    @temp = 100*@num1
    end
    def solve
     { "ans" => (100/@num2)*@num1}
    end
    def explain
     [
      Subproblem.new([TextLabel.new("To Find the Discount rate, first find the discount using the following formula: "),
      TextLabel.new("Discount = Original price - Discounted price"),
      TextLabel.new("Discounted price = #{@den - @num}, Original price =  #{@den}: Discount = ")]), 
      PreG6::Subtraction.new(@den,@diff),
      Subproblem.new([TextLabel.new("Discount Percentage = (Discount/(Original Price)) X 100"),
      TextLabel.new("Original price =  #{@den}: Discount = ")]),
      PreG6::Division.new(@num2,@temp,true)]
    end
    def text
      [TextLabel.new("Find the percentage of discount: "), InlineBlock.new(TextLabel.new("Discounted price of #{@den - @num} on #{@den}: Discount = "),TextField.new("ans"),TextLabel.new("%"))]
    end
  end


class ProfitLoss < QuestionWithExplanation
    def self.type
      "Profit & Loss"
    end
    def initialize
    @factors = [1,2,4,5,10,20,25,50,100]
    @num2 = @factors.sample
    @num1 =  rand(@num2)
    if @num1 === 0
      @num1 = 1
    end 

    @comm = rand(9) +1
    @arr = [-1,1]
    @sign = @arr.sample
    @k = @num1*@comm*@sign
    @price = @num2*@comm
    @quant  = rand(@price+@k-1) +2    
    @netbalance = @k*@price
    @cp = @quant*@price
    if @k + @price > 999
      @price2 = rand(999 - (@k+@price-@quant)) + @k+@price-@quant +1
    else
      @price2 = rand(@quant) + @k+@price-@quant +1
    end  
    @price1 = @price2 + @quant
    @quant1 = @k + @price - @price2
    @sp = @quant1*@price1 + (@quant-@quant1)*@price2
    @diff = @sp - @cp
    end
    def solve
     { "ans" => (100/@num2)*@num1*@sign}
    end
        def explain
     [
      Subproblem.new([TextLabel.new("To Find the Net Profit, first find the Total Cost: "),
      TextLabel.new("Cost = Quantity X (Cost Price)"),  
      TextLabel.new("Quantity =#{@quant},Cost Price =#{@price}")]), 
      PreG6::Multiplication.new(@quant,@price),
      Subproblem.new([TextLabel.new("Now find the Total Selling Price:"),
      TextLabel.new("Selling Price = Quantity1 X (Selling Price1) + (Quantity - Quantity1) X (Selling Price2)"),
      TextLabel.new("selling price1 =#{@price1},quant1 =#{@quant1},selling price2 =#{@price2}"),]), 
      PreG6::Addition.new([(@quant1*@price1),((@quant-@quant1)*@price2)]),
      Subproblem.new([TextLabel.new("Now calculate the difference between above 2")]),
      PreG6::Subtraction.new(@sp,@cp),
      Subproblem.new([TextLabel.new("Now calculate percentage")]),
      PreG6::Division.new(@cp,100*@diff,true)]
    end    
    def text
      [TextLabel.new("Find the value of net profit percentage "), InlineBlock.new(TextLabel.new("Quantity =#{@quant},Cost Price =#{@price},Selling Price1 =#{@price1},Quantity1 =#{@quant1},Selling Price2 =#{@price2}"),TextField.new("ans"),TextLabel.new("%"))]
    end
  end


   class ProfitLoss2 < QuestionWithExplanation
    def self.type
      "Profit & Loss 2"
    end
    def initialize
    @factors = [1,2,4,5,10,20,25,50,100]
    @num2 = @factors.sample
    @num3 = 100/@num2
    @num1 =  rand(@num2)
    if @num1 === 0
      @num1 = 1
    end 
    @num4 =  rand(@num2)
    if @num4 === 0
      @num4 = 1
    end 

    @mult = rand(99) +1
    @numerator1 = @num1*@num3
    @den = @num2*@mult
    @numerator2 = @num4*@num3
    @temp1 = (@numerator1*@den)/100
    @temp2 = (@numerator2*@den)/100

    end
    def solve
     { "ans" => (@numerator1*@den)/100 - (@numerator2*@den)/100 }
    end
        def explain
     [
      Subproblem.new([TextLabel.new("To Find the Net Profit, first find the profit on first item: "),
      TextLabel.new("Profit Percentage =#{@numerator1}, Price =#{@den}"),
      TextLabel.new("Profit = ((Profit Percentage)*Price)/100")]), 
      PreG6::Division.new(100,(@den*@numerator1),true),
      Subproblem.new([TextLabel.new("Now find the loss on second item:"),
      TextLabel.new("Loss Percentage =#{@numerator2}, Price =#{@den}"),
      TextLabel.new("Loss = ((Loss Percentage)*Price)/100")]), 
      PreG6::Division.new(100,(@den*@numerator2),true),
      Subproblem.new([TextLabel.new("Now Subract loss from the profit")]),
      PreG6::Subtraction.new(@temp1,@temp2)]
    end
    def text
      [TextLabel.new("Find the value of net profit"), InlineBlock.new(TextLabel.new("#{@numerator1}% profit on #{@den} : #{@numerator2}% loss on #{@den} = "),TextField.new("ans"))]
    end
  end

   class SalesTax < QuestionWithExplanation
    def self.type
      "Sales Tax"
    end
    def initialize
    @factors = [2,4,5,10,20,25,50,100]
    @num2 = @factors.sample
    @num3 = 100/@num2
    @num2 = (@num2/2).truncate
    @num1 =  rand(@num2)
    if @num1 === 0
      @num1 = 1
    end 
    @mult = rand(99) +1
    @numerator1 = @num1*@num3
    @den = @num2*@mult
    end
    def solve
     { "ans" => @den +(@numerator1*@den)/100 }
    end
    def explain
      [Subproblem.new([TextLabel.new("To Find the Billing Amount you first calculate the taxed amount & then add that to the original price: "),TextLabel.new("Taxed Amount = (Original Price)X(ST/100)")])]
    end
    def text
      [TextLabel.new("Find the Billing Amount "), InlineBlock.new(TextLabel.new("#{@numerator1}% Sales Tax on #{@den}; Bill Amount = "),TextField.new("ans"))]
    end
  end

   class Vat < QuestionWithExplanation
    def self.type
      "VAT"
    end
    def initialize
      @factors = [2,4,5,10,20,25,50,100]
      @num2 = @factors.sample
      @num3 = 100/@num2
      @num1 = rand(49) +1
      @vat = rand(25) + 1;
      @den = 100 + @vat
      if @vat === 25
        @num = @num1*5
      elsif @vat === 20
       @num = @num1*6
      elsif @vat === 10      
        @num = @num1*11
      elsif @vat%5 === 0    
        @num = @num1*((@vat+100)/5)
      elsif @vat%2 === 0    
        @num = @num1*((@vat+100)/2)
      else
        @num = @num1*(@vat+100)
      end    
    end
    def solve
     { "ans" => (@num/@den)*100 }
    end
    def explain
      [Subproblem.new([TextLabel.new("To Find the Original Price, you can use the following formulas: "),TextLabel.new("Original Price = Billed Price X (100/(100+vat))")])]
    end    
    def text
      [TextLabel.new("Find the Original Price "), InlineBlock.new(TextLabel.new("#{@vat}% VAT makes the price #{@num}; Original Price = "),TextField.new("ans"))]
    end
  end

 class CompoundInterest < QuestionWithExplanation
    def self.type
      "Compound Interest"
    end
    def initialize
      @principal = rand(199) +1
      @principal = @principal*100
      @rate = rand(19) +1
      if @rate%10 === 0
        @time = rand(2) +2
      else
        @time = 2  
        @principal = @principal*100
      end  

    end
    def solve
     { "ans" => @principal*((100 + @rate)**@time)/(100**@time) - @principal }
    end
    def explain
      [Subproblem.new([TextLabel.new("To Find the Compound Interest, you can use the following formulas: "),TextLabel.new("P = Principal, R = Yearly Rate of Interest, T = Time in years"),TextLabel.new("Amount = P(1+(R/100))^T"),TextLabel.new("Compound Interest = Amount - Principal")])]
    end  
    def text
      [TextLabel.new("Find the Compound Interest(Compounded Yearly)"), InlineBlock.new(TextLabel.new("Principal: Rs.#{@principal} Rate: #{@rate}% Time: #{@time}yrs Compound Interest= "),TextField.new("ans"))]
    end
  end

 class CompoundInterest2 < QuestionWithExplanation
    def self.type
      "Compound Interest 2"
    end
    def initialize
      @principal = rand(99) +1
      @principal = @principal*100
      @rate = rand(24) +1
      if @rate%10 === 0
        @time = rand(2) +2
        @principal = @principal*10
      else
        @time = 2  
        @principal = @principal*100
      end  

    end
    def solve
     { "ans" => @principal*((100 + @rate)**@time)/(100**@time) - @principal }
    end
    def explain
      [Subproblem.new([TextLabel.new("For problems compounded half-yearly, Double the time period & half the yearly rate of interest. Now we can use the following formulas to find the Compound Interest: "),TextLabel.new("P = Principal, R = (Yearly Rate of Interest)/2, T = 2X(Time in years)"),TextLabel.new("Amount = P(1+(R/100))^T"),TextLabel.new("Compound Interest = Amount - Principal")])]
    end
    def text
      [TextLabel.new("Find the Compound Interest (Compounded half-yearly)"), InlineBlock.new(TextLabel.new("Principal: Rs.#{@principal} Rate: #{2*@rate}% Time: #{@time/2.0}yrs Compound Interest= "),TextField.new("ans"))]
    end
  end


  PROBLEMS = [ComparingQuantities::FindValue, ComparingQuantities::FindPercent, ComparingQuantities::Discount, ComparingQuantities::ProfitLoss, ComparingQuantities::ProfitLoss2, ComparingQuantities::SalesTax, ComparingQuantities::Vat, ComparingQuantities::CompoundInterest, ComparingQuantities::CompoundInterest2] 

 end 