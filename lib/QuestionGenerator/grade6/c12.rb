require_relative '../questionbase'

require_relative '../tohtml.rb'
include ToHTML

module Chapter12

  SUNIT=["mm", "grams", "ml", "cm", "meters", "paise"]
  LUNIT=["cm", "kg", "liter", "meters", "km", "rupees"]
  UCON={"mm" => 10,
    "grams" => 1000,
    "ml" => 1000,
    "cm" => 100,
    "meters" => 1000,
    "paise" => 100}

  class FindRatioSame < QuestionWithExplanation
    def initialize
      units=Set.new(SUNIT+LUNIT)
      tm1=rand(2)
      if(tm1==0)
        @unit=" "
      else @unit=" #{units.to_a.sample} "
      end
      rat=Grade6ops::chCommPF
      if(rand(2)==0)
        tm=rat[0]
        rat[0]=rat[1]
        rat[1]=tm
      end
      @rat=rat
      @n1=rat[0].reduce(:*)
      @n2=rat[1].reduce(:*)
      @co=rat[2].reduce(:*)
    end
    def explain
      [SubLabel.new("This is essentially the same as reducing the fraction #{@n1}/#{@n2} to its lowest form"), Chapter7::ReduceFractions.new(@rat[0], @rat[1], @rat[2])]
      def solve
        {"ans1" => @n1/@co, "ans2" => @n2/@co}
      end
      def text
        [TextLabel.new("Find the ratio of #{@n1}#{@unit}to #{@n2}#{@unit}in its lowest form"), InlineBlock.new(TextField.new("ans1"), TextLabel.new(" : "), TextField.new("ans2"))]
      end
    end 
  end


  class FindRatioDiff < QuestionWithExplanation
    def initialize
      @lunit=LUNIT.sample
      @sunit=SUNIT[LUNIT.index(@lunit)]
      rat=Grade6ops::chCommPF
      if(rand(2)==0)
        tm=rat[0]
        rat[0]=rat[1]
        rat[1]=tm
      end
      @n1=rat[0].reduce(:*)
      @n2=rat[1].reduce(:*)
      @co=rat[2].reduce(:*)
      @rat=rat
      @wh=rand(2)
    end
    def explain
      [SubLabel.new("First convert to the same units. Try converting #{@n1*UCON[@sunit]} #{@sunit} to #{@lunit}"), Chapter8::UnitsDecIncrease.new(@sunit, @n1*UCON[@sunit]), Chapter12::FindRatioSame.new(@rat[0],@rat[1],@rat[2])]
      def solve
        {"ans1" => @n1/@co, "ans2" => @n2/@co}
      end
      def text
        str="#{@n1} #{@lunit} to #{@n2*UCON[@sunit]} #{@sunit}" if @wh==0
        str="#{@n1} #{@sunit} to #{@n2*UCON[@sunit]} #{@lunit}" if @wh==1
        [TextLabel.new("Find the ratio of #{str} in its lowest form"), InlineBlock.new(TextField.new("ans1"), TextLabel.new(" : "), TextField.new("ans2"))]
      end
    end
  end




	class SumRat
		def initialize(subs, nums, tot)
			@subs=subs
			@nums=nums
			@tot=tot
		end

		def str_long
			ret=[]
			for i in 0...@subs.length
				ret << "What is the ratio of the number of "+@subs[i] + " to the total number of " +@tot
				for j in 0...@subs.length
					if i!=j
						ret << "What is the ratio of the number of "+@subs[i] +" to the number of " +@subs[j]
					end
				end
			end
			ret	
		end
		def str_short
			ret=[]
			for i in 0...@subs.length
				ret << "Number of "+@subs[i] + " to the total number of " +@tot
				for j in 0...@subs.length
					if i!=j
						ret << "Number of "+@subs[i] +" to the number of " +@subs[j]
					end
				end
			end
			ret	
		end
		def solve
			ret={}
			k=0
			for i in 0...@nums.length
				ret["num"+k.to_s]=Rational(@nums[i],@nums.reduce(:+)).numerator
				ret["den"+k.to_s]=Rational(@nums[i],@nums.reduce(:+)).denominator
				k+=1
				for j in 0...@nums.length
					if i!=j
						ret["num"+k.to_s]=Rational(@nums[i],@nums[j]).numerator
						ret["den"+k.to_s]=Rational(@nums[i],@nums[j]).denominator
						k+=1
					end
				end
			end
			ret
		end
	end

	class RatioStudent < QuestionBase
		SUBS=[["girls","boys"], ["students who like cricket", "students who like football", "students who like hockey"], ["Babli saved", "Babli spent"], ["girls", "boys"]]
	  MAX=[30, 30, 2000, 2000]
    UNTS=["",""," rupees that ", ""]
	  TOT=["students", "students", "rupees", "students"]	
	  WHERE=["in the class", "in the class", "earned by Babli", "in the school"] 
		def initialize
			@ch=rand(SUBS.length)
			@wh=rand(2)
			@many=[]
			for i in 0...SUBS[@ch].length
				@many << rand(MAX[@ch])+5	
			end
			@rat=SumRat.new(SUBS[@ch],@many, TOT[@ch]+" "+WHERE[@ch])
		end
		def solve
			@rat.solve
		end
		def text
			ret=[]
			blank=rand(SUBS[@ch].length+1)
			str=""
			if blank!=SUBS[@ch].length
				str+="A total of "+@many.reduce(:+).to_s+" "+TOT[@ch]+" are " +WHERE[@ch] + ". Out of this, "
			else 
				str+="The "+TOT[@ch]+" "+WHERE[@ch]+" includes "  
			end
			pre=[]
			for i in 0...SUBS[@ch].length
				if i!=blank
					pre << @many[i].to_s+UNTS[@ch]+" "+SUBS[@ch][i]
				end
			end
			pre
      if pre.length > 2
#        puts "here"
			  str += pre.slice(0,pre.length-1).join(", ")+" and "+pre.last
      else str+= pre[0]
      end

			if blank!=SUBS[@ch].length
				str << ". The rest are " +SUBS[@ch][blank]
			end
			if @wh==0
				tex=@rat.str_long
			else
				tex=@rat.str_short
				str+=". Find the ratio of:"
			end
			ret << TextLabel.new(str)
			for i in 0...tex.length
				ret << TextLabel.new((i+1).to_s+". "+tex[i])
				tab= TableField.new("ans", 1, 3)
				tab.set_field(0,0,TextField.new("num"+i.to_s))
				tab.set_field(0,1,TextLabel.new(":"))
				tab.set_field(0,2,TextField.new("den"+i.to_s))
				ret << tab
			end
			ret		
		end
	end

	UNITS=["g","kg","m","cm","mm","km","litre","ml","sec","min", "hr", "Rupees"]
	MAXPROP=60
	class Proportion < QuestionBase
		def initialize
			@unit1=UNITS.sample
			@unit2=UNITS.sample
			@nums1=[rand(MAXPROP)+2,rand(MAXPROP)+2]
			@nums2=[@nums1[0],@nums1[1]]
			if rand(2)==0
				while @nums1[0]==@nums2[0]
					mult=rand(10)+2
					@nums2=[Rational(@nums1[0],@nums1[1]).numerator*mult , Rational(@nums1[0],@nums1[1]).denominator*mult]
				end
			else
				@nums2=[rand(MAXPROP)+2,rand(MAXPROP)+2]
			end
			@wh=rand(4)
		end
		def solve
			return {"ans" => "True"} if  Rational(@nums1[0],@nums1[1])==Rational(@nums2[0],@nums2[1])
			return {"ans" => "False"}
		end
		def text
			str=[]
			if @wh==0
				str=[TextLabel.new(@nums1.join(", ")+", "+@nums2.join(", ")+ " are in proportion. True or False?")]
      elsif @wh==1
        str=[TextLabel.new(@nums1.join(":")+"::"+@nums2.join(":") + ". True or False?")]
      elsif @wh==2
        str=[TextLabel.new(@nums1[0].to_s+" "+@unit1+" : "+ @nums1[1].to_s + @unit1 +" = "+ @nums2[0].to_s+@unit2+" : "+@nums2[1].to_s + @unit2 +". True or False?")]
      elsif @wh==3
        str=[TextLabel.new(@nums1[0].to_s+" "+@unit1+" : "+ @nums1[1].to_s + @unit1 + " and "+ @nums2[0].to_s+@unit2+" : "+@nums2[1].to_s+ @unit2 +" are in proportion. True or False?")]
      end
      str << RadioButton.new("ans", ["True", "False"])
      str
    end
  end

  class UnitaryWord
    attr_accessor :wh2
    NAMES=["Babloo", "Babli"]
    VERBS=["costs", "cost", "is", "weigh", "weighs"]
    NOUNS={"costs" => [["meters", "cloth"], ["kilograms", "wheat"]],
      "cost" => [["bushels", "apples"], ["boxes", "oranges"], ["dozen bananas"]],
      "is" => [["months", "name1's rent"], ["days", "name1's salary"]],
      "weigh" => [["books"], ["apples"], ["oranges"],["bushels", "wheat"], ["planks", "wood"]]}
    VERBNOUN={"costs" => "the cost of", 
      "cost" => "the cost of",
      "weigh" => "the weight of",
      "weighs" => "the weight of",
      "is" => ["name1's rent for", "name1's salary for"]}
    UNS={"costs" => "Rs.",
      "cost" => "Rs.",
      "weigh" => "kg",
      "is" => ["Rs.","Rs."]}

    def initialize(cam,fam,mul,wh=rand(VERBS.length),wh2=nil)
      @wh=wh
      @wh2=wh2
      @wh2=rand(NOUNS[VERBS[@wh]].length) if @wh2==nil
      @cam=cam
      @fam=fam
      @mul=mul
    end
    def str
      verb=VERBS[@wh]
      no=NOUNS[verb][@wh2]
      noun=no.last
      uns=""
      uns=no.first + " of " if no.length > 1
      st=@cam.to_s+ " " + uns + noun + " " + verb
      units=UNS[verb]
      units=units[@wh2] if Array.try_convert(units)!=nil
      if units=="Rs."
        st+=" " + units + " " + ( @cam * @mul ).to_s 
      else st+=" "+(@cam*@mul).to_s+ " "+units
      end
      verbn=VERBNOUN[verb]
      verbn=verbn[@wh2] if Array.try_convert(verbn) != nil
      st+=". What is "+verbn +" "+@fam.to_s+" "+uns +noun
      name=NAMES.sample
      while st.index("name1")!=nil
        st=st.slice(0,st.index("name1")) + name + st.slice(st.index("name1")+5, st.length)
      end

      st+="?"
      st
    end
    def str_first
      verb=VERBS[@wh]
      no=NOUNS[verb][@wh2]
      noun=no.last
      uns=""
      uns=no.first + " of " if no.length > 1
      st=@cam.to_s+ " " + uns + noun + " " + verb
      units=UNS[verb]
      units=units[@wh2] if Array.try_convert(units)!=nil
      if units=="Rs."
        st+=" " + units + " " + ( @cam * @mul ).to_s 
      else st+=" "+(@cam*@mul).to_s+ " "+units
      end
      st
    end
    def str_opp
      verb=VERBS[@wh]
      no=NOUNS[verb][@wh2]
      noun=no.last
      uns=""
      uns=no.first + " of " if no.length > 1
      st=@cam.to_s+ " " + uns + noun + " " + verb
      units=UNS[verb]
      units=units[@wh2] if Array.try_convert(units)!=nil
      if units=="Rs."
        st+=" " + units + " " + ( @cam * @mul ).to_s 
      else st+=" "+(@cam*@mul).to_s+ " "+units
      end
      verbn=VERBNOUN[verb]
      verbn=verbn[@wh2] if Array.try_convert(verbn) != nil
      st+=". How many "+ uns + noun + " " + verb +" "
      if units=="Rs."
        st+= "Rs." + (@fam*@mul).to_s
      else st+= (@fam*@mult).to_s +" "+units
      end
      name=NAMES.sample
      while st.index("name1")!=nil
        st=st.slice(0,st.index("name1")) + name + st.slice(st.index("name1")+5, st.length)
      end
      st+="?"
      st
    end
  end 

  MAXUNITARY=40
  class UnitaryMethod < QuestionBase
    def initialize
      @camt=rand(MAXUNITARY)+3
      @famt=@camt
      while @famt==@camt
        @famt=rand(MAXUNITARY)+3
      end
      @mult=rand(MAXUNITARY)+3
      @txt=UnitaryWord.new(@camt, @famt, @mult)
      @ch=rand(2)
    end

    def solve
      return {"ans" => @famt*@mult} if @ch==0
      {"ans" => @famt}
    end

    def text
      str=""
      if @ch==0
        str=@txt.str
      else str=@txt.str_opp
      end
      return [TextLabel.new(str), TextField.new("ans")]
    end
  end
  COUNTRIES = ["India", "Pakistan", "Bangladesh", "China", "Afghanistan"]
  class RatioCompCostWord < QuestionBase
    def initialize
      @num1=rand(MAXUNITARY)
      @num2=rand(MAXUNITARY)
      @mult1=rand(MAXUNITARY)
      @mult2=rand(MAXUNITARY)
      @ch=rand(2)
      @txt1=UnitaryWord.new(@num1,0, @mult1, @ch)
      @txt2=UnitaryWord.new(@num2,0, @mult2, @ch, @txt1.wh2)
      @c1=COUNTRIES.sample
      @c2=@c1
      while @c1==@c2
        @c2=COUNTRIES.sample
      end
    end

    def solve
      return {"ans" => @c1} if @mult1 > @mult2
      {"ans" => @c2}
    end

    def text
      [TextLabel.new(@txt1.str_first + " in " + @c1 + ". "+@txt2.str_first + " in " + @c2 + ". Where is it more expensive per unit?"), RadioButton.new("ans", @c1, @c2)]
    end
  end
  PROBLEMS=[Chapter12::FindRatioSame, Chapter12::RatioStudent, Chapter12::Proportion, Chapter12::UnitaryMethod, Chapter12::RatioCompCostWord]
  
end
