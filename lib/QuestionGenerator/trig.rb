#!/usr/bin/env ruby
require_relative 'questionbase'
require_relative 'tohtml'
include "Math.rb"


PYTHTRIP=[[3,4,5],[5,12,13],[7,24,25],[8,15,17]]
ORD=["a","o","h"]
PYTH=[[1,1,Math.sqrt(2)], [1,Math.sqrt(3),2]]
TRIGF=["sin", "cos", "tan", "cot", "cosec", "sec"]
TRIGDEF={"sin" => ["o","h"], "cos" => ["a","h"], "tan" => ["o","a"], "cot" => ["a","o"], "cosec" => ["h","o"], "sec" => ["h","a"]}


module Trig
  class RatiosMissingSide
    def initialize
      trip=PYTHTRIP.sample
      mult=rand(3)+1
      for i in 0...trip.length
        trip[i]=trip[i]*mult
      end
      @fun=TRIGF.sample
      @trip={"a" => trip[0],
        "o" => trip[1],
        "h" => trip[2]}
      @whmis=TRIGDEF[@fun].sample
    end
    def solve
      rat=Rational(@trip[TRIGDEF[@fun][0]], @trip[TRIGDEF[@fun][1]])
      return {"num" => rat.numerator, 
              "den" => rat.denominator}
    end
    def text
      txt="In a triangle ABC, right angled at B"
      txt+=", AB is of length #{@trip["a"]} " if @whmis != "a"
      if @whmis == "h"
        txt+="and "
      else txt+=", "
      end
      txt+="BC is of length #{@trip["o"]}" if @whmis != "o"
      txt+=" and CA is of length #{@trip["h"]}" if @whmis != "h"
      txt+=". What is the value of #{@fun}(A) in its lowest form?"
      [TextLabel.new(txt), Fraction.new("num", "den")]
    end
  end
  class RatioGivenOther
    def initialize
      trip=PYTHTRIP.sample
      @orig=TRIGF.sample
      @fin=TRIGF.sample
      while @fin==@orig
        @fin=TRIGF.sample
      end
      mult=rand(3)+1
      for i in 0...trip.length
        trip[i]=trip[i]*mult
      end
      @trip={"a" => trip[0],
             "o" => trip[1],
             "h" => trip[2]}
    end
    def solve
      rat=Rational(@trip[TRIGDEF[@fin][0]], @trip[TRIGDEF[@fin][1]])
      return {"num" => rat.numerator, 
              "den" => rat.denominator}
    end
    def text
      [TextLabel.new("In a triangle ABC, right angled at B, #{@orig}(A)=#{Fraction.new(@trip(TRIGDEF[@orig][0]), @trip(TRIGDEF[@orig][1]))}. What is the value of #{@fin}(A) in its lowest form?"), Fraction.new("num", "den")]
    end
  end
  class RatiosUsingId
    def initialize
      @fun=TRIGF.sample
      @ang=rand(85)+3
    end
    def solve
      
    end
    def text
      [TextLabel.new("Find the value of #{Fraction.new("sin(#{@ang})", "sin(#{90-@ang})")} using identities"), TextField.new("ans")]
    end
  end
end





