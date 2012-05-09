
#!/usr/bin/env ruby
require_relative './grade6ops.rb'
require_relative '../questionbase'
require_relative '../tohtml'
require_relative './preg6'



# TODO override preprocess for the add commas question ( default is now to remove commas )
include ToHTML
include PreG6

SOUNDSPEED=340
module Physics
  class SingleEchoDist < QuestionWithExplanation
    def initialize
      @dist=(rand(20)+1)*17
      @wh=rand(3)
    end
    def solve
      {"ans" => @dist}
    end
    def explain
      [Subproblem.new([TextLabel.new("The speed of sound in air is #{SOUNDSPEED} m/s. The time taken for the echo to return is #{(@dist.to_f*2)/SOUNDSPEED}. What is the total distance the sound has travelled to return? Hint: distance = speed x time"), TextField.new("totd", "Total Distance")], {"totd" => @dist*2}),
        Subproblem.new([TextLabel.new("For the sound to echo, it has to reach the wall and return. So, the wall is only half as far as the total distance travelled by the sound. What is the distance from the wall? Hint: Divide the distance from the last step by 2"), TextField.new("dist", "Distance")], {"dist" => @dist})]
    end  
   
    def text
      str=""
      if @wh==0
        str+="A bat in a cave emits a sound. The echo reaches the bat's ears #{((@dist.to_f*2)/SOUNDSPEED)} seconds later. How far is the wall of the cave from the bat in meters?"
      elsif @wh==1
        str+="A girl shouted facing a wall. The echo returned #{((@dist.to_f*2)/SOUNDSPEED)} seconds later. How far is the wall in meters from the girl?"
      elsif @wh==2
        str+="A rifle was shot and its echo returned #{((@dist.to_f*2)/SOUNDSPEED)} seconds later. How far was the wall from the shooter in meters?"
      end
      str+=" Assume the speed of sound to be 340 m/s."
      [TextLabel.new(str), TextField.new("ans", "Distance")]
    end
  end
  class SingleEchoTime < QuestionWithExplanation
    def initialize
      @dist=(rand(20)+1)*17
      @wh=rand(3)
    end
    def solve
      {"ans" => (@dist.to_f*2)/SOUNDSPEED}
    end
    def explain
      [Subproblem.new([TextLabel.new("The speed of sound in air is #{SOUNDSPEED} m/s. The distance to the wall is #{@dist} meters. What is the total distance the sound has travelled? Hint: The sound travels to the wall and then returns back, so the distance will be double the distance to the wall"), TextField.new("totd", "Total Distance")], {"totd" => @dist*2}),
        Subproblem.new([TextLabel.new("Now, find the number of seconds required for the sound to travel this distance. Hint: Time = Distance / Speed"), TextField.new("time", "Seconds")], {"time" => solve["ans"]})]
    end  
    def correct?(params)
      HTMLObj::get_result("ans", params).to_f==solve["ans"]
    end  
   
    def text
      str=""
      if @wh==0
        str+="A bat in a cave emits a sound. The sound echo's after it hits a wall #{@dist} meters away. After how many seconds from the inception of the sound, did the echo return to the bat?"
      elsif @wh==1
        str+="A girl shouted facing a wall #{@dist} meters away. How many seconds did the echo take to return to the girl?"
      elsif @wh==2
        str+="A rifle was shot with a wall #{@dist} meters away. After how many seconds did the shooter hear the echo?"
      end
      str+=" Assume the speed of sound to be 340 m/s."
      [TextLabel.new(str), TextField.new("ans", "Time")]
    end
  end
  class DoubleEchoDist < QuestionWithExplanation
    def initialize
      @d2=(rand(20)+2)
      @d1=rand(@d2-2)+1
      @d1*=17
      @d2*=17
      @wh=rand(3)
    end
    def solve
      {"ans" => @d1+@d2}
    end
    def explain
      [Subproblem.new([TextLabel.new("The speed of sound in air is #{SOUNDSPEED} m/s. The time taken for the echo to return from the first wall is #{(@d1.to_f*2)/SOUNDSPEED}. What is the total distance the sound has travelled to echo from the first wall? Hint: distance = speed x time"), TextField.new("totd", "Total Distance")], {"totd" => @d1*2}),
        Subproblem.new([TextLabel.new("For the sound to echo, it has to reach the wall and return. So, the first wall is only half as far as the total distance travelled by the sound. What is the distance from the first wall? Hint: Divide the distance from the last step by 2"), TextField.new("dist", "Distance")], {"dist" => @d1}),
        Subproblem.new([TextLabel.new("What is the total amount of time taken by the sound to echo from the second wall? Hint: The time taken will be the time taken to return from the first wall (#{(@d1.to_f*2)/SOUNDSPEED} s) plus the time it required after that (#{((((@d2.to_f*2)/SOUNDSPEED)*1000).to_i-(((@d1.to_f*2)/SOUNDSPEED)*1000).to_i)/1000.0} s)."), TextField.new("ttw2")], {"ttw2" => (@d2.to_f*2)/SOUNDSPEED}),
        Subproblem.new([TextLabel.new("The speed of sound in air is #{SOUNDSPEED} m/s. The time taken for the echo to return from the second wall is #{(@d2.to_f*2)/SOUNDSPEED}. What is the total distance the sound has travelled to echo from the second wall? Hint: distance = speed x time"), TextField.new("totd", "Total Distance")], {"totd" => @d2*2}),
        Subproblem.new([TextLabel.new("For the sound to echo, it has to reach the wall and return. So, the second wall is only half as far as the total distance travelled by the sound. What is the distance from the second wall? Hint: Divide the distance from the last step by 2"), TextField.new("dist", "Distance")], {"dist" => @d2}),
        Subproblem.new([TextLabel.new("The distance to the first wall is #{@d1} and the ditance to the second wall is #{@d2}. How far apart are the walls. Hint: Their sum"), TextField.new("dist","Distance between Walls")], {"dist" => @d1+@d2})]
    end  
    def text
      str=""
      if @wh==0
        str+="A bat in a cave emits a sound. The echo from one wall reaches the bat's ears #{((@d1.to_f*2)/SOUNDSPEED)} seconds later, while the echo from the parallel wall reaches the bat #{((((@d2.to_f*2)/SOUNDSPEED)*1000).to_i-(((@d1.to_f*2)/SOUNDSPEED)*1000).to_i)/1000.0} seconds after that. How wide is the cave in meters?"
      elsif @wh==1
        str+="A girl shouted facing between 2 parallel walls. The echo returned from the first wall #{((@d1.to_f*2)/SOUNDSPEED)} seconds later. #{((((@d2.to_f*2)/SOUNDSPEED)*1000).to_i-(((@d1.to_f*2)/SOUNDSPEED)*1000).to_i)/1000.0} seconds after that the echo returns from the parallel wall. How far apart are the two walls in meters?"
      elsif @wh==2
        str+="A rifle was shot in a valley with parallel walls. Its echo returned #{((@d1.to_f*2)/SOUNDSPEED)} seconds later from the first wall. #{((((@d2.to_f*2)/SOUNDSPEED)*1000).to_i-(((@d1.to_f*2)/SOUNDSPEED)*1000).to_i)/1000.0} seconds after that, the echo returned from the parallel wall. How wide is the valley in meters?"
      end
      str+=" Assume the speed of sound to be 340 m/s."
      [TextLabel.new(str), TextField.new("ans", "Distance")]
    end
  end      
  PROBLEMS=[Physics::SingleEchoDist, Physics::SingleEchoTime, Physics::DoubleEchoDist]
end

