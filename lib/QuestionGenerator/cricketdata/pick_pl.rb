
#!/usr/bin/env ruby

TEAMS=["England", "Australia", "South Africa", "India", "New Zealand", "Sri Lanka", "Pakistan", "West Indies", "Bangladesh", "Zimbabwe"]
class PickPlayer
  def initialize(wh, bb, tm=TEAMS.sample)
    @tm=tm
    @wh=wh
    @bb=bb
  end
  def player
    fname="./#{@wh}/#{@tm}/"
    fname+="batsmen.csv" if @bb=="bat"
    fname+="bowlers.csv" if @bb=="bowl"
    f=File.new(fname, "r")
    pl=[]
    while (line=f.gets)
      if line.index("\n")!=0
        line.slice!(line.length-1)
      end
      pl << line
    end
    pl.sample
  end
  def plmat
    pl=player
    fname="./#{@wh}/#{@tm}/#{pl}_matches.csv"
    f=File.new(fname, "r")
    mat=[]
    inn=[]
    while (line=f.gets)
      if line.index(",")!=nil
        if line.index("\n")!=nil
          line.slice!(line.length-1)
        end
        line.slice!(0)
        line.slice!(line.length-1)
        k= line.split(", ")
        mat << k[0]
        inn << k[1]
      end
    end
    re=rand(mat.length)
    return [mat[re], inn[re]]
  end
end



