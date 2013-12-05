require_relative '../grade6'

mods = [ PreG6, Chapter1, Chapter2, Chapter3, Chapter4, Chapter6, Chapter7, Chapter8 ]

describe "All Problems:" do
  mods.each do |mod|
    mod::PROBLEMS.each do |prob|
      describe "#{prob}:" do
        it "should accept the .prefix_solve hash in .correct?" do
          $stderr.puts "****creating #{prob.to_s}"
          tmp = prob.new
          $stderr.puts "****getting solution"
          soln = tmp.prefix_solve
          $stderr.puts "****testing"
          tmp.correct?(soln).should be_true
        end
      end
    end
  end
end
