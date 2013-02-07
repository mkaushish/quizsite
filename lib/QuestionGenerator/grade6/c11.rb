
#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'

require_relative '../tohtml.rb'
require_relative './preg6'
include PreG6
require 'set'
include ToHTML
module Chapter11
  TITLE = "Algebra"

  VARNAMES=["x", "b", "y", "n", "k", "z", "c", "m"] 
  CONT=["row", "box", "row of Rangoli"]
  PLCONT=["rows", "boxes", "rows of Rangoli"]
  INS={"row" => ["cadets"], "box" => ["mangoes"], "row of Rangoli" => ["dots"]}
  class SimpleVariableMult < QuestionBase
    def initialize(var=VARNAMES.sample)
      @var=var
      @cont=CONT.sample
      @ins=INS[@cont].sample
      @num=rand(12)+2
    end
    def solve
      {"ans" => "#{@num}#{@var}"}
    end
    def text
      [TextLabel.new("A single #{@cont} contains #{@num} #{@ins}. How do you write the number of #{@ins} in terms of the number of #{PLCONT[CONT.index[@cont]]} (Use #{@var} as the number of #{PLCONT[CONT.index[@cont]]})"), TextField.new("ans")]
    end
  end 

  OPS=[:+, :-]
  class SimpleVariableAddSub < QuestionBase
    def initialize(var=VARNAMES.sample, op=OPS.sample)
      @var=var
      @ops=op
      @cont=CONT.sample
      @ins=INS[@cont].sample
      @num=rand(12)+2
    end
    def solve
      if @ops==:+
        {"ans" => "#{@var}+#{@num}"}
      elsif @ops==:-
        {"ans" => "#{@var}-#{@num}"}
      end
    end
    def text
      [TextLabel.new("A #{@cont} contains #{@var} #{@ins}. Another #{@cont} contains #{@num} #{{:+ => "more", :- =>"less"}[@ops]} #{@ins} than the first. How do you write the number of #{@ins} in the second #{@cont} in terms of the number of #{@ins} in the second #{@cont}?"), TextField.new("ans")]
    end
  end 


  PROBLEMS=[]
end

