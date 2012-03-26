
#!/usr/bin/env ruby
require_relative './grade7ops.rb'
require_relative '../questionbase'
require_relative '../tohtml.rb' 
include ToHTML




module Chapter1

  class FindIntegers
    def initialize
      wh=rand(2)
      wh=-1 if wh==0
      @ch=rand(2)
      @ch=-1 if @ch==0
      @num=(rand(30)+1)*wh 
    end

    def solve
      {"ans1" => 0, "ans2" => @num*@ch} 
    end

    def correct?(params)
      num1=HTMLObj::get_result("ans1", params).to_i
      num2=HTMLObj::get_result("ans2", params).to_i
      return true if num1+@ch*num2==@num
      return false
    end

    def text
      t=""
      t="sum" if @ch==1
      t="difference" if @ch==-1
      [TextField.new("Find two integers whose #{t} is #{@num}"), TextField.new("ans1", "First Number"), TextField.new("ans2", "Second Number")]
    end
  end
end
