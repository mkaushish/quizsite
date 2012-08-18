namespace :db do
  desc "Reset the problem_stats field for all the users"
  task :reset_problem_stats => :environment do
    puts "Calling user create callbacks!"
    User.find_each do |user|
      print user.run_callbacks(:create) ? "+" : "-"
    end

    puts "\nCalling problemanswer create callbacks"
    Problemanswer.find_each do |answer|
      print answer.run_callbacks(:create) ? "+" : "-"
    end
    puts "\nDone!"
  end
end
