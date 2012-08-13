
#!/usr/bin/env ruby

require_relative '../questionbase'

require_relative '../tohtml'
include ToHTML
require "date"


class Float
  def eq(fl)
#    puts "here"
#    puts ((to_f*100).round).to_s + ", " +((fl*100).round).to_s
    (to_f*100).round==(fl*100).round
  end
end
module CricketQuestions
  class CricketSubproblem < Subproblem
    def correct?(params)
      QuestionBase.vars_from_response("av", params).to_f==@mysoln["av"]
    end  
  end
  TEAMS=["Australia", "Bangladesh", "England", "India", "New Zealand", "Pakistan", "South Africa", "Sri Lanka", "Zimbabwe"]  
  def CricketQuestions.to_date(date)
    d=date.split("-")
    dt=Date.new(d[0].to_i,d[1].to_i,d[2].to_i)
    dt
  end
  def CricketQuestions.pick_player(type, bb,  min_mat, date=Date.new(1877, 1, 1), team="")
    file=File.new("./lib/QuestionGenerator/cricketdata/#{type}/#{bb}mat.csv", "r")
    file.gets
    ar=[]
    while (line=file.gets)
      ind=line.split(", ")
      ar << ind
      rm=false
      if team!=""
        if ind[0]!=team
          ar.slice!(ar.length-1)
          rm=true
        end
      end
      if ind[2].to_i < min_mat && rm!=true
        ar.slice!(ar.length-1)
        rm=true
      end
      if CricketQuestions::to_date(ind[3]) < date && rm!=true
        ar.slice!(ar.length-1)
      end
    end
    ar.sample
  end
  def CricketQuestions.pick_matches(type, team, bb, pname, matches)
    file=File.new("./lib/QuestionGenerator/cricketdata/#{type}/#{team}/#{bb}/#{pname}.csv")
    names=file.gets.split(", ")
    names[names.length-1].slice!(names[names.length-1].length-1)
    ar=[]
#    puts names
    while (line=file.gets)
      line.slice!(line.length-1)
      ar << line.split(", ")
    end
    beg=rand(ar.length-matches-1)
    ret=ar.slice(beg, matches)
    ret=[names]+ret
  end  

  class CrBatAverage < QuestionWithExplanation 
    @type="Find Batting Average"
    def initialize
      @totruns=0
      while(@totruns==0)
        nomat=rand(7)+2
        @mtype="Test"
        pname=CricketQuestions::pick_player(@mtype, "bat", nomat)
        @pname=pname
#        puts @pname
        @mat=CricketQuestions::pick_matches(@mtype, pname[0], "bat", pname[1], nomat)
        @names=@mat.slice!(0)
        @totruns=0
        for i in 0...@mat.length
          @totruns += @mat[i][@names.index("Runs")].to_i
        end
      end
    end
    def correct?(params)
      QuestionBase.vars_from_response("ans", params).to_f.eq(solve["ans"])
    end  
    def image
      return @pname[0]+".png"
    end
    def solve
      sum=0
      for i in 0...@mat.length
        sum += @mat[i][@names.index("Runs")].to_i
      end
      av=sum.to_f/@mat.length
      {"ans" => av}
    end
    def explain
      [Subproblem.new([TextLabel.new("Study the table and the click next"), text[1]]),
        Subproblem.new([TextLabel.new("What was the total number of runs scored by #{@pname[1]} in the given #{@mat.length} innings?"), TextField.new("runs", "Total Runs Scored")], {"runs" => @totruns}),
       CricketSubproblem.new([TextLabel.new("Now, the average will be given by dividing the total runs scored by the number of innings. What is the average?"), TextField.new("av", "Average")], {"av" => solve["ans"]})]
    end 
    def text
      tab=TableField.new("tab", @mat.length+1, 4)
      tab.set_field(0,0,"#{@mtype} No.")
      tab.set_field(0,1,"Innings")
      tab.set_field(0,2,"Opponent")
      tab.set_field(0,3,"Runs Scored")
      for i in 0...@mat.length
        dt=CricketQuestions::to_date(@mat[i][@names.index("Date")])
        tab.set_field(i+1,0,@mat[i][@names.index("Match")])
        tab.set_field(i+1,1,@mat[i][@names.index("Innings")])
        tab.set_field(i+1,2,@mat[i][@names.index("Against")])
        tab.set_field(i+1,3,@mat[i][@names.index("Runs")])
      end 
      
      [TextLabel.new("#{@pname[1]}'s scores for #{@pname[0]} in #{@mat.length} consecutive innings were:"), tab, TextLabel.new("What was his average over this period (Upto 2 Decimal places)?"), TextField.new("ans", "Average")]
    end
  end

  class CrBowlAverage < QuestionWithExplanation 
    @type="Find Bowling Average"
    def initialize
      nomat=rand(4)+5
      @mtype="Test"
      pname=CricketQuestions::pick_player(@mtype, "bowl", nomat)
      @pname=pname
#      puts @pname
      @mat=CricketQuestions::pick_matches(@mtype, pname[0], "bowl", pname[1], nomat)
      @names=@mat.slice!(0)
      tr=false
      for i in 0...@mat.length
#        puts @mat[i]
        if @mat[i][@names.index("Wickets")]!="0"
          tr=true
          break
        end
      end
      while tr==false
        pname=CricketQuestions::pick_player(@mtype, "bowl", nomat)
        @pname=pname
#        puts @pname
        @mat=CricketQuestions::pick_matches(@mtype, pname[0], "bowl", pname[1], nomat)
        @names=@mat.slice!(0)
        tr=false
        for i in 0...@mat.length
          if @mat[i][@names.index("Wickets")]!="0"
            tr=true
            break
          end
        end
      end
    end
    def correct?(params)
      QuestionBase.vars_from_response("ans", params).to_f.eq(solve["ans"])
    end  
    def image
      return @pname[0]+".png"
    end
    def solve
      sum=0
      wi=0
      for i in 0...@mat.length
        sum += @mat[i][@names.index("Runs")].to_i
        wi += @mat[i][@names.index("Wickets")].to_i
      end
      av=sum.to_f/wi
      @wi=wi
      @sum=sum
      {"ans" => av}
    end
    def explain
      solve
      [Subproblem.new([TextLabel.new("Study the table and the click next"), text[1]]),
      Subproblem.new([TextLabel.new("What was the total number of runs conceded by #{@pname[1]} in the given #{@mat.length} innings?"), TextField.new("runs", "Total Runs Conceded")], {"runs" => @sum}),
      Subproblem.new([TextLabel.new("What was the total number of wickets taken by #{@pname[1]} in the given #{@mat.length} innings?"), TextField.new("wickets", "Total Wickets Taken")], {"wickets" => @wi}),
       CricketSubproblem.new([TextLabel.new("Now, the average will be given by dividing the total runs conceded by the number of wickets taken. What is the average?"), TextField.new("av", "Average")], {"av" => @sum.to_f/@wi})]
    end 
    def text
      tab=TableField.new("tab", @mat.length+1, 5)
      tab.set_field(0,0,"#{@mtype} No.")
      tab.set_field(0,1,"Innings")
      tab.set_field(0,2,"Opponent")
      tab.set_field(0,3,"Wickets")
      tab.set_field(0,4,"Runs Conceded")
      for i in 0...@mat.length
        dt=CricketQuestions::to_date(@mat[i][@names.index("Date")])
        tab.set_field(i+1,0,@mat[i][@names.index("Match")])
        tab.set_field(i+1,1,@mat[i][@names.index("Innings")])
        tab.set_field(i+1,2,@mat[i][@names.index("Against")])
        tab.set_field(i+1,3,@mat[i][@names.index("Wickets")])
        tab.set_field(i+1,4,@mat[i][@names.index("Runs")])
      end 
      
      [TextLabel.new("#{@pname[1]}'s bowling figures for #{@pname[0]} in #{@mat.length} consecutive innings were:"), tab, TextLabel.new("What was his bowling average over this period (Upto 2 Decimal places)?"), TextField.new("ans", "Average")]
    end
  end
  EARLIEST=Date.new(1985, 1, 1)
  class CrStrikeRate < QuestionWithExplanation
    @type="Find Batting Strike Rate" 
    def initialize
      nomat=rand(7)+2
      @mtype="Test"
      pname=CricketQuestions::pick_player(@mtype, "bat", nomat, EARLIEST)
      @pname=pname
#      puts @pname
      @mat=CricketQuestions::pick_matches(@mtype, pname[0], "bat", pname[1], nomat)
      @names=@mat.slice!(0)   
    end
    def correct?(params)
      QuestionBase.vars_from_response("ans", params).to_f.eq(solve["ans"])
    end  
    def solve
      sum=0
      balls=0
      for i in 0...@mat.length
        sum += @mat[i][@names.index("Runs")].to_i
        balls += @mat[i][@names.index("Balls")].to_i
      end
      str=sum.to_f/balls
      @balls=balls
      @sum=sum
      {"ans" => str*100} 
    end
    def image
      return @pname[0]+".png"
    end
    def explain
      solve
      [Subproblem.new([TextLabel.new("Study the table and the click next"), text[1]]),
      Subproblem.new([TextLabel.new("What was the total number of runs scored by #{@pname[1]} in the given #{@mat.length} innings?"), TextField.new("runs", "Total Runs Scored")], {"runs" => @sum}),
      Subproblem.new([TextLabel.new("What was the total number of balls used by #{@pname[1]} in the given #{@mat.length} innings?"), TextField.new("balls", "Total Balls Bowled")], {"balls" => @balls}),
       CricketSubproblem.new([TextLabel.new("Now, the strike rate will be given by dividing the total runs scored by the number of balls taken and multiplying that by 100. What is his strike rate over this period?"), TextField.new("av", "Strike Rate")], {"str" => (@sum.to_f/@balls)*100})]
    end 
    def text
      tab=TableField.new("tab", @mat.length+1, 5)
      tab.set_field(0,0,"#{@mtype} No.")
      tab.set_field(0,1,"Innings")
      tab.set_field(0,2,"Opponent")
      tab.set_field(0,3,"Runs Scored")
      tab.set_field(0,4,"Balls Played")
      for i in 0...@mat.length
        dt=CricketQuestions::to_date(@mat[i][@names.index("Date")])
        tab.set_field(i+1,0,@mat[i][@names.index("Match")])
        tab.set_field(i+1,1,@mat[i][@names.index("Innings")])
        tab.set_field(i+1,2,@mat[i][@names.index("Against")])
        tab.set_field(i+1,3,@mat[i][@names.index("Runs")])
        tab.set_field(i+1,4,@mat[i][@names.index("Balls")])
      end 
      
      [TextLabel.new("#{@pname[1]}'s scores for #{@pname[0]} in #{@mat.length} consecutive innings were:"), tab, TextLabel.new("What was his batting strike rate over this period (Upto 2 Decimal places)?"), TextField.new("ans", "Strike Rate")]
    end
  end
  class CrStrikeRateBowling < QuestionWithExplanation
    @type="Find Bowling Strike Rate"
    def initialize
      nomat=rand(4)+5
      @mtype="Test"
      pname=CricketQuestions::pick_player(@mtype, "bowl", nomat, EARLIEST)
      @pname=pname
#      puts @pname
      @mat=CricketQuestions::pick_matches(@mtype, pname[0], "bowl", pname[1], nomat)
      @names=@mat.slice!(0)
      tr=false
      for i in 0...@mat.length
#        puts @mat[i]
        if @mat[i][@names.index("Wickets")]!="0"
          tr=true
          break
        end
      end
      while tr==false
        pname=CricketQuestions::pick_player(@mtype, "bowl", nomat)
        @pname=pname
#        puts @pname
        @mat=CricketQuestions::pick_matches(@mtype, pname[0], "bowl", pname[1], nomat)
        @names=@mat.slice!(0)
        tr=false
        for i in 0...@mat.length
          if @mat[i][@names.index("Wickets")]!="0"
            tr=true
            break
          end
        end
      end
    end
    def correct?(params)
      QuestionBase.vars_from_response("ans", params).to_f.eq(solve["ans"])
    end  
    def image
      return @pname[0]+".png"
    end
    def solve
      sum=0
      wi=0
      for i in 0...@mat.length
        ov= @mat[i][@names.index("Overs")]
        if ov.index(".")!=nil
          overs=ov.split(".")
          sum += overs[0].to_i*6 + overs[1].to_i
        else sum+=ov.to_i*6
        end
        wi += @mat[i][@names.index("Wickets")].to_i
#        puts sum
      end
      av=sum.to_f/wi
      @wi=wi
      @sum=sum
      {"ans" => av}
    end
    def explain
      solve
      [Subproblem.new([TextLabel.new("Study the table and the click next"), text[1]]),
      Subproblem.new([TextLabel.new("What was the total number of balls bowled by #{@pname[1]} in the given #{@mat.length} innings?"), TextField.new("balls", "Total Balls Bowled")], {"balls" => @sum}),
      Subproblem.new([TextLabel.new("What was the total number of wickets taken by #{@pname[1]} in the given #{@mat.length} innings?"), TextField.new("wickets", "Total Wickets Taken")], {"wickets" => @wi}),
       CricketSubproblem.new([TextLabel.new("Now, the strike rate will be given by dividing the total balls bowled by the number of wickets taken. What is the strike rate?"), TextField.new("av", "Strike Rate")], {"av" => (@sum.to_f/@wi)})]
    end 
    def text
      tab=TableField.new("tab", @mat.length+1, 5)
      tab.set_field(0,0,"#{@mtype} No.")
      tab.set_field(0,1,"Innings")
      tab.set_field(0,2,"Opponent")
      tab.set_field(0,3,"Wickets")
      tab.set_field(0,4,"Overs Bowled")
      for i in 0...@mat.length
        dt=CricketQuestions::to_date(@mat[i][@names.index("Date")])
        tab.set_field(i+1,0,@mat[i][@names.index("Match")])
        tab.set_field(i+1,1,@mat[i][@names.index("Innings")])
        tab.set_field(i+1,2,@mat[i][@names.index("Against")])
        tab.set_field(i+1,3,@mat[i][@names.index("Wickets")])
        tab.set_field(i+1,4,@mat[i][@names.index("Overs")])
      end 
      
      [TextLabel.new("#{@pname[1]}'s bowling figures for #{@pname[0]} in #{@mat.length} consecutive innings were:"), tab, TextLabel.new("What was his bowling strike rate over this period (Upto 2 Decimal places)?"), TextField.new("ans", "Strike Rate")]
    end
  end
  PROBLEMS=[CricketQuestions::CrBatAverage, CricketQuestions::CrBowlAverage, CricketQuestions::CrStrikeRate, CricketQuestions::CrStrikeRateBowling]
end 

