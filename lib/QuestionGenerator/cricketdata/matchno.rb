#!/usr/bin/env ruby

require_relative '../questionbase'

require_relative '../tohtml'
include ToHTML
require "date"
TEAMS=["Australia","Bangladesh", "England", "India", "New Zealand", "Pakistan", "South Africa", "Sri Lanka", "West Indies", "Zimbabwe"]

class MatchNo
  def initialize(ty, bb)
    @ty=ty
    @bb=bb
    @bm="batsmen.csv" if @bb=="bat"
    @bm="bowlers.csv" if @bb=="bowl"
  end
  def putbb
    file=File.new("./#{@ty}/"+@bb+"mat.csv","w")
    file.puts "Team, Name, Innings, Begin Date, End Date"
    for i in 0...TEAMS.length
      fname="./#{@ty}/"+TEAMS[i]+"/#{@bm}"
      f=File.new(fname, "r")
      while (line=f.gets)
        puts line
        line.slice!(line.length-1)
        pname=line
        puts pname
        q=File.new("./#{@ty}/#{TEAMS[i]}/#{@bb}/#{pname}.csv")
        l=q.gets
        names=l.split(", ")
        ct=0
        lns=[]
        while (ln=q.gets)
          lns[ct]=ln.split(", ")
          ct+=1
        end
        be=lns[0][names.index("Date")]
        en=lns[lns.length-1][names.index("Date")]
        file.puts "#{TEAMS[i]}, #{pname}, #{ct}, #{be}, #{en}"
      end
    end  
  end
end
