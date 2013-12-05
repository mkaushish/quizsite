
#!/usr/bin/env ruby
require "date"
MONTHS=["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
class SingleMatch
  attr_accessor :sc
  def initialize(fname)
    qq=false
    if fname.index("http")!=nil 
      `wget #{fname} -O temp.txt`
      qq=true
      fname="temp.txt"
    end
    file=File.new(fname, "r")
    @sc=[]
    mno=0
    type=""
    while (line=file.gets)
      k=line.index("\n")
      if k!=nil
        puts line
        @sc << line.slice(0 , k) 
        if line.slice(0,k).index("ODI # ")!=nil
          mno=line.slice(0,k).slice(line.slice(0,k).index("ODI # ")+6,4).rstrip
          type="ODI"
        end
        if line.slice(0,k).index("Test # ")!=nil
          mno=line.slice(0,k).slice(line.slice(0,k).index("Test # ")+7,4).rstrip
          type="Test"
        end

      else @sc << line
      end 
    end
    puts @sc
    file.close
    st=0
    while @sc[st]==""
      @sc.slice!(st)
      st+=1
    end
    if qq==true
      puts "\n\n mno: #{mno} \n\n" 
      `mv temp.txt #{mno}.txt`
      `mv #{mno}.txt ./#{type}/matches`
    end
  end
  def basicinfo()
    puts @sc[0]
    @type=@sc[0].slice(0,@sc[0].index("#")-1)
    @matchno=@sc[0].slice(@sc[0].index("#{@type} # ")+6,@sc[0].length).to_i
    check=File.new("./#{@type}/mat.csv", "a")
    check.puts @matchno
    @series=@sc[1]
    inda=2
    while @sc[inda].index(" v ")==nil
      inda+=1
    end
    tm=@sc[inda].index(" v ")
    @teams=[@sc[inda].slice(0,tm), @sc[inda].slice(tm+3, @sc[2].length)]
    @where=@sc[inda+1]
    dt=String.new(@sc[inda+2])
    @maxovers=@sc[4].slice(@sc[inda+2].index(" (")+2, 2)
    dt=dt.slice!(0,dt.index(" ("))
    day=dt.slice!(0,dt.index(" "))
    if day.index(",")!=nil
      day.slice!(day.index(","), day.length)
    end
    puts day=day.to_i
    dt.slice!(dt.index(" "))
    while dt.index(",")!=nil
      dt.slice!(0, dt.index(",")+1)
      dt.lstrip!
    end
    if dt[0].to_i < 10 && dt[0].to_i > 0
      dt.slice!(0, dt.index(" "))
      dt.lstrip!
    end
    
    puts dt
    dt.lstrip!
    mn=dt.slice!(0, dt.index(" "))
    puts mn
    
    mn=mn.slice(0,mn.length-1) if mn[mn.length-1]==","
    mn.lstrip!
    month=MONTHS.index(mn)+1
    kkk=month-1
    kkk=11 if kkk==0
    puts sc[inda]
    puts MONTHS[kkk]
    if sc[inda+2].index(MONTHS[kkk])!=nil
      month=kkk
    end
    puts dt+"p"
    dt.lstrip!
    year=dt.slice!(dt.length-4,4).to_i
    puts year
    puts "[#{year}, #{month}, #{day}]"
    @date=Date.new(year.to_i,month.to_i,day.to_i)
    @sc.slice!(0,@sc.index("")+1)
    @result=@sc[0].slice(@sc[0].index("Result: ")+8,@sc[0].length)
    if @result.index("won")!=nil
      tm=@teams[0]
      if @result.index(@teams[0])==nil
        tm=@teams[1]
      end
      if @result.index(tm) < @result.index("won")
        @result=tm
      else @result=@teams[((@teams.index(tm)+1) % 2)]
      end
    else @result="draw"
    end
    @sc.slice!(0,@sc.index("")+1)
    @toss=@teams.index(@sc[0].slice(sc[0].index("Toss: ")+6,sc[0].length))
    @umpires=@sc[1].slice(@sc[1].index("Umpires: ")+9, @sc[1].length)
    for i in 2...@sc.length
      if ind=@sc[i].index(" of the match: ")
        @mom=@sc[i].slice(ind+15, @sc[i].length)
        break
      end
    end
    @sc.slice!(0,@sc.index("")+1)
    [@type, @matchno, @series, @teams, @where, @maxovers, @date, @result, @toss, @umpires, @mom]
  end
  EXPAND={"R" => "Runs",
    "B" => "Balls",
    "M" => "Minutes",
    "4" => "Fours",
    "6" => "Sixes"}
  ORD=["Runs", "Minutes", "Balls", "Fours", "Sixes"]
  EXPANDBOWL={"O" => "Overs",
    "M" => "Maidens",
    "R" => "Runs",
    "W" => "Wickets"}
  BOWLORD=["Overs", "Maidens", "Runs", "Wickets"]
  def innings()
    @captain=[]
    @wk=[]
    @bat=[]
    @total=[]
    @dnb=[]
    @bowl=[]
    ov=0
    @batorder=[]

    while @sc[0].index("***")==nil && @sc[0].index("<END>")==nil  && @sc[1].index("***")==nil && @sc[0].index("Note:")==nil
      puts "here"+sc[0]
      if sc[0].index(" team:")!=nil
        dn=""
        sh=1
        while sc[sh]!="" 
          puts sc[sh]
          dn+=" "+sc[sh].lstrip.rstrip
          puts dn
          sh+=1
        end
        @dnb[ov]=dn.split(", ")
        for i in 0...@dnb[ov].length
          if @dnb[ov][i][0]=="*"
            @dnb[ov][i].slice!(0)
          end
          if @dnb[ov][i][0]=="+"
            @dnb[ov][i].slice!(0)
          end
        end
        @batorder[ov]=(@batorder[ov-1]+1) % 2        
        break
      end
      while @sc[0].index(" innings")==nil
        @sc.slice!(0)
      end
      keep=String.new(@sc[0])
      bf=@sc[0].slice(0, sc[0].index(" innings"))
      if bf.index("1st")!=nil
        bf.slice!(bf.index("1st")-1, bf.length)
      end
      if bf.index("2nd")!=nil
        bf.slice!(bf.index("2nd")-1, bf.length)
      end
      @batorder[ov]=@teams.index(bf)

      wh=@sc[0].slice(@sc[0].index(" R "), @sc[0].length)
      wh.slice!(0)
      @wh=[]
      ww=[]
      while wh!=""
        @wh << EXPAND[wh.slice(0)]
        ww << wh.slice!(0)
        while wh.slice(0)==" "
          wh.slice!(0)
        end
      end

      @sc.slice!(0)
      bat1=[]
      while @sc[0].index("Extras  ")==nil
        puts @sc[0]
        str=String.new(@sc[0])
        wer=String.new(@sc[0])
        name=str.slice!(0, 22)
        puts str
        name.rstrip!
        if name[0]=="*"
          name.slice!(0)
          @captain[ov]=name
          @captain[ov].slice!(0) if @captain[ov][0]=="+"
        end
        if name[0]=="+"
          name.slice!(0)
          @wk[ov]=name
        end
        how1=""
        how2=""
        str
        if str.index(" b ")!=nil
          inde=str.index(" b ")
          tem=str.slice(0,str.index(" b "))
          how1=tem
          str=str.slice(inde, str.length)
          #puts how1.index("  ")
          #puts how1
          #puts str 
          how1=how1.rstrip
          puts "\n\n["+str+"]\n\n"
          
          qq=str.index("  ")
          if qq==nil
            for l in 0...str.length
              if str[l].to_i < 10 && str[l].to_i > 0
                qq=l
              end
            end
          end
          how2=str.slice!(str.index(" b ")+1, qq-1)
          how2.slice!(0,2)
        else 
          how1=str.slice!(0,str.index("  "))
        end
        str.lstrip!
        puts str

        run=[]
        str+=" "
        keep+=" "
        puts keep
        puts ww
        for i in 0...ww.length
          sh=keep.index(" "+ww[i]+" ")
          for r in 0...4
            if wer[sh-r]==" "
              cc=r
              break
            end
          end
          #puts "here"+wer+"\n#{cc},#{sh}"
          run[i]=wer.slice(sh-cc+1, cc+1)
          if run[i] !=nil
            puts run[i]
            run[i].lstrip!
            run[i]="na" if run[i]==""
          end
        end
        run.to_s
        @sc.slice!(0)
        bat1 <<  ([name, how1, how2]+run) 
      end
      @bat << bat1
      @sc.slice!(0)
      @total[ov]=@sc[0].slice(@sc[0].length-3, 4)
      while @total[ov][0]==" "
        @total[ov].slice!(0)
      end
      @dnb[ov]=[]
      while @sc[0].index("Bowling")==nil
        if @sc[0].index("DNB: ")!=nil
          dn=@sc[0].slice(5,@sc[0].length)
          val=1
          while @sc[val]!=""
            dn+=" "+ @sc[val].lstrip!
            val+=1
          end
          if dn[dn.length-1]=="."
            dn.slice!(dn.length-1)
          end
          @dnb[ov]=dn.split(", ")
          for i in 0...@dnb[ov].length
            if @dnb[ov][i][0]=="*"
              @dnb[ov][i].slice!(0)
              @captain[ov]=@dnb[ov][i]
              @captain[ov].slice!(0) if @captain[ov][0]=="+"
            end
            if @dnb[ov][i][0]=="+"
              @dnb[ov][i].slice!(0)
              @wk[ov]=@dnb[ov][i]
            end
          end
        end
        @sc.slice!(0)
      end
      @wb=[]
      keepb=String.new(@sc[0])
      flb=String.new(@sc[0])
      flb.slice!(0, flb.index("  "))
      flb.lstrip!
      while flb!=""
        @wb << flb.slice!(0)
        flb.lstrip!
      end
      @sc.slice!(0)
      bowl1=[]
      @sc[0]
      while @sc[0]!=""
        name=@sc[0].slice(0,@sc[0].index("  "))
        ball=[]
        @sc[0].slice!(@sc[0].index(" ("),@sc[0].length) if @sc[0].index(" (")!=nil
        @sc[0]
        @wb.to_s
        keepb+=" "
        for i in 0...@wb.length
          nde= keepb.index(" "+@wb[i]+" ")
          bow=@sc[0].slice(nde-1, 5)
          bow.lstrip!
          bow.rstrip!
          ball << bow
        end
        bowl1 << [name]+ball
        @sc.slice!(0)
      end
      @bowl << bowl1
      ov+=1
      @sc.slice!(0)
      @sc[0]
    end
    fixbowl 
    for i in 0...@wb.length
      @wb[i]=EXPANDBOWL[@wb[i]]
    end
    [@batorder, @wh, @bat, @total, @dnb, @captain, @wk, @wb, @bowl]
    @bat
    [@batorder.join(", "), @bowlorder.join(", ")]
    @dnb
  end

  def output
    basicinfo
    innings
    file=File.new("#{@type}_"+@matchno.to_s, "w")
    for i in 0...@bat.length
      for j in 0...@bat[i].length
        file.puts @bat[i][j][0] +"\n\n"
      end
    end 
    file.close
  end

  def fixbowl
    @bowlorder=[]
    for co in 0...@batorder.length
      @bowlorder[co]=(@batorder[co]+1) % 2
    end
    puts @bowlorder

    for ch in 0...@bowl.length
      sh=5
      for i in 0...@dnb.length
        if @bowlorder[ch]==@batorder[i]
         sh=i
        end
      end
      for i in 0...@bowl[ch].length
        if @bat[sh]!=nil
          for j in 0...@bat[sh].length
            if @bat[sh][j][0].index(@bowl[ch][i][0])!=nil
              @bowl[ch][i][0]=@bat[sh][j][0]
            end
          end
        end
        for k in 0...@dnb[sh].length
          if @dnb[sh][k].index(@bowl[ch][i][0])!=nil
            @bowl[ch][i][0]=@dnb[sh][k]
          end
        end
      end
    end
    @bowl
  end
  def bat_file(innings, order, wh, matplay)
    against=@teams[@bowlorder[innings]]
    out = [matplay, @date, (innings+1).to_s, (order+1).to_s, against]
    for i in 1...@bat[innings][order].length
      out << @bat[innings][order][i]
    end
    out.join(", ")
  end

  def bowl_file(innings, order, wh, matplay)

    against=@teams[@batorder[innings]]
    out = [matplay, @date, (innings+1).to_s, (order+1).to_s, against]
    for i in 1...@bowl[innings][order].length
      out << @bowl[innings][order][i]
    end
    out.join(", ")
  end 
 
  def bat_matches_template
    ["Match", "Innings"]  
  end 

  def bowl_matches_template
    ["Match", "Innings"]  
  end

  def bat_template(innings, order, nm)

    ([nm, "Date", "Innings", "Batting Order", "Against", "How out 1", "How out 2"]+ORD).join(", ")+"\n"

  end

  def bowl_template(innings, order, nm)
    ([nm, "Date", "Innings", "Bowling Order", "Against"]+BOWLORD).join(", ")+"\n"
  end


  def batbowl_out

    for i in 0...@teams.length
      `mkdir #{@type}/"#{@teams[i]}"`
      `mkdir #{@type}/"#{@teams[i]}"/bat`
      `mkdir #{@type}/"#{@teams[i]}"/bowl`
    end
    file1=[File.new("./#{@type}/"+@teams[0]+"/batsmen.csv", "a"), File.new("./#{@type}/"+@teams[1]+"/batsmen.csv", "a")]
    putbat=[]
    for wh in 0...@bat.length
      for j in 0...@bat[wh].length

        fn="./#{@type}/"+@teams[@batorder[wh]]+"/batsmen.csv"
        infile=`grep "#{@bat[wh][j][0]}" "#{file1[@batorder[wh]].path}"`

        @bat[wh][j][0]+"HERE"

        if infile=="" && putbat.index([@bat[wh][j][0],@batorder[wh]])==nil  
          file1[@batorder[wh]].puts @bat[wh][j][0]
          putbat << [@bat[wh][j][0], @batorder[wh]]
        end
        exist=File.exists?("./#{@type}/"+@teams[@batorder[wh]]+"/bat/"+@matchno.to_s+".csv")
        file=File.new("./#{@type}/"+@teams[@batorder[wh]]+"/bat/"+@matchno.to_s+".csv", "a")
        if !exist
          file.puts bat_template(wh,j, "Name")
        end 
        boo= `grep "#{@bat[wh][j][0]}, #{@date.to_s}, #{wh+1}" "#{file.path}"`
        if boo==""
          file.puts bat_file(wh, j, "bat", @bat[wh][j][0])
        end
        file.close
        exist=File.exists?("./#{@type}/"+@teams[@batorder[wh]]+"/bat/"+@bat[wh][j][0]+".csv")
        file=File.new("./#{@type}/"+@teams[@batorder[wh]]+"/bat/"+@bat[wh][j][0]+".csv", "a")
        if !exist
          file.puts bat_template(wh,j,"Match")
        end 
        boo= `grep "#{@matchno}, #{@date.to_s}, #{wh+1}" "#{file.path}"`
        if boo==""
          file.puts bat_file(wh, j, "bat", @matchno)
        end
        file.close
        puts "./#{@type}/#{@teams[@batorder[wh]]}/bat/#{@bat[wh][j][0]}_matches.csv"
        exist=File.exists?("./#{@type}/#{@teams[@batorder[wh]]}/bat/#{@bat[wh][j][0]}_matches.csv")

        file=File.new("./#{@type}/#{@teams[@batorder[wh]]}/bat/#{@bat[wh][j][0]}_matches.csv", "a")
        if !exist
          file.puts  bat_matches_template
        end
        boo= `grep ",#{@matchno}, #{wh+1}," "#{file.path}"`
        if boo==""
          file.puts ",#{@matchno}, #{wh+1},"
        end
        file.close
      end
    end
    file1[0].close
    file1[1].close

    file2=[File.new("./#{@type}/"+@teams[0]+"/bowlers.csv", "a"), File.new("./#{@type}/"+@teams[1]+"/bowlers.csv", "a")]
    putbowl=[]
    
    puts @bowlorder.join(", ")
    for wh in 0...@bowl.length
      for j in 0...@bowl[wh].length

        fn="./#{@type}/"+@teams[@bowlorder[wh]]+"/bowlers.csv"
        puts infile=`grep "#{@bowl[wh][j][0]}" "#{fn}"`
        if infile=="" && putbowl.index([@bowl[wh][j][0],@bowlorder[wh]])==nil
          file2[@bowlorder[wh]].puts @bowl[wh][j][0]
          putbowl << [@bowl[wh][j][0],@bowlorder[wh]]
        end
        exist=File.exists?("./#{@type}/"+@teams[@bowlorder[wh]]+"/bowl/"+@matchno.to_s+".csv")
        file=File.new("./#{@type}/"+@teams[@bowlorder[wh]]+"/bowl/"+@matchno.to_s+".csv", "a")
        if !exist
          file.puts  bowl_template(wh,j,"Name")
        end
        boo= `grep "#{@bowl[wh][j][0]}, #{@date.to_s}, #{wh}" "#{file.path}"`
        if boo==""  
          file.puts bowl_file(wh, j, "bowl", @bowl[wh][j][0])
        end
        file.close
        exist=File.exists?("./#{@type}/"+@teams[@bowlorder[wh]]+"/bowl/"+@bowl[wh][j][0]+".csv")
        file=File.new("./#{@type}/"+@teams[@bowlorder[wh]]+"/bowl/"+@bowl[wh][j][0]+".csv", "a")
        if !exist
          file.puts  bowl_template(wh,j,"Match")
        end
        boo= `grep "#{@matchno}, #{@date.to_s}, #{wh}" "#{file.path}"`
        if boo==""  
          file.puts bowl_file(wh, j, "bowl", @matchno)
        end
        file.close

        exist=File.exists?("./#{@type}/#{@teams[@bowlorder[wh]]}/bowl/#{@bowl[wh][j][0]}_matches.csv")
        file=File.new("./#{@type}/#{@teams[@bowlorder[wh]]}/bowl/#{@bowl[wh][j][0]}_matches.csv", "a")
        if !exist
          file.puts bowl_matches_template
        end
        puts boo= `grep ",#{@matchno}, #{wh+1}," "#{file.path}"`
        if boo==""
          puts file.path
          file.puts(",#{@matchno}, #{wh+1},")
        end
        file.close
      end
    end
    file2[0].close
    file2[1].close

  end
end 



