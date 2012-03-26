
#!/usr/bin/env ruby


class GetScore
  attr_accessor :urls
  def initialize(type, beg_year, end_year, beg_match=0, end_match=100000)
    @by=beg_year
    @bm=beg_match
    @ey=end_year
    @em=end_match
    @type=type
  end
  def get_urls
    yct=@by
    mct=@bm
    @urls=[]
    cla=1
    cla=2 if @type=="ODI"
    file2=File.new("./#{@type}/urls_numbers.csv", "a")
    file1=File.new("./#{@type}/urls.csv", "a")
    while yct <= @ey 
      if !File.exists?("./#{@type}/#{yct}.txt")
        `wget   "stats.espncricinfo.com/ci/engine/records/team/match_results.html?class=#{cla};id=#{yct};type=year"  -O "./#{@type}/#{yct}.txt"`
      end
      file=File.new("./#{@type}/#{yct}.txt", "r")
       
      while (line=file.gets)
        line+="#    </a>"
        tmatch=(line.slice(line.index("#")+2, line.index("</a>")-line.index("#")-2))
        puts tmatch
        match=0
        if tmatch!=nil && ["a", "b", "c", "d", "e", "f"].index(tmatch[tmatch.length-1])==nil
         match=tmatch.to_i
        end 
        if line.index("#{@type} #")!=nil && match >= @bm && match <= @em  && match > 0 
          ln=line.slice!(line.index("/"), line.index("html")-line.index("/"))
          url= "stats.espncricinfo.com"+ln+"txt"
          wh=`grep "#{url}" "#{file1.path}"`
          if wh=="" && @urls.index(url)==nil
         #   puts url
            @urls << url
            file2.puts tmatch 
          end
        end

      end
      file.close
      yct+=1 
    end
    puts @urls
    
    file1.puts @urls.join("\n")
    file1.close
    file2.close
    @urls
  end
end
