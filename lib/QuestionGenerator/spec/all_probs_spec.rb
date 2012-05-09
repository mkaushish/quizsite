require_relative '../grade6/c1.rb'
require_relative '../grade6/c2.rb'
require_relative '../grade6/c3.rb'
require_relative '../grade6/preg6.rb'

mods = [ PreG6, Chapter1, Chapter2, Chapter3 ]

describe "All Problems:" do
  mods.each do |mod|
    mod::PROBLEMS.each do |prob|
      describe "#{prob}:" do
        it "should accept the .prefix_solve hash in .correct?" do
          tmp = prob.new
          tmp.correct?(tmp.prefix_solve).should be_true
        end
      end
    end
  end
end
