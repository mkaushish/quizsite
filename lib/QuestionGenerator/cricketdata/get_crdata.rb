
#!/usr/bin/env ruby


class GetCrData
  attr_accessor :data, :var
  def initialize(fname, wh)
    #wh is either odi, test or name
    @file=File.new(fname, "r")
    @wh=wh
  end

  def get_data
    line=@file.gets
    line.slice!(line.length-1)
    @var=line.split(", ")
    @data={}
    for i in 0...@var.length
      @data[@var[i]]=[]
    end
    while (line=@file.gets)
      if line.index("\n")!=nil
        line.slice!(line.length-1)
      end
      val=line.split(", ")
      for i in 0...@var.length
        @data[@var[i]] << val[i]
      end
    end
    var << @wh
    @data[@wh]=@file.path
    if @file.path.rindex("/")!=nil
      @data[@wh]=@file.path.slice(@file.path.rindex("/")+1, @file.path.length)
    end
    @data[@wh].slice!(@data[@wh].index("."), @data[@wh].length)
    @file.close
    [var, @data]
  end
end
