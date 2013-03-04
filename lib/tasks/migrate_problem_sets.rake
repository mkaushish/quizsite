namespace :oneoffs do
  desc "make new default problem sets and reassign the current homeworks for our beta group"
  task :update_problem_sets => :environment do 
    me = Teacher.find_by_email "t.homasramfjord@gmail.com"

    psets = ProblemSet.where(user_id: nil)
    psets.each do |ps| 
      ps.user_id = me.id
      ps.save!
      puts "#{ps.name} saved to owner #{ps.user_id}"
    end

    puts "changed user id of problem sets SUCCESS"
  end
end
