namespace :db do
  desc "Reset the problem_stats field for the vidya users"
  task :reset_vidya_stats => :environment do
    Classroom.where(:name => "Alpha1").first.students.each do |user|
      puts "Recreating stats for #{user.name}"
      user.run_callbacks(:create)
      user.problemanswers.each do |answer|
        # puts "\r#{user.name}: #{answer.pclass}"
        user.update_stats(answer.pclass, answer.correct)
      end
    end
  end
end
