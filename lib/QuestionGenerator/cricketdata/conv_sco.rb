require_relative './cricket.rb'
#!/usr/bin/env ruby


class ConvSco
  def initialize(type, mst, men)
    @type=type
    @st=mst
    @en=men
  end
  def output()
    file=File.new("./"+@type+"/urls.csv", "r")
    for i in 0...@en
      url=file.gets
      if i >= @st-1
        if url.index("\n")!=nil
          url.slice!(url.index("\n"), url.length)
        end
        scr=SingleMatch.new("http://"+url)
        puts scr.sc
        scr.basicinfo
        scr.innings
        scr.batbowl_out
      end
    end
  end
end

