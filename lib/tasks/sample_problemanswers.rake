namespace :generate do
  task :answers => :environment do
    users = [ "thomas.ramfjord@gmail.com", "madhav.kaushish@gmail.com" ]
    users.map { |email| User.find_by_email(email) }.each do |user|
      user.problem_set_instances.each do |ch|
        ch::problem_types.each do |pr|
          10.times do
            prob=pr.problem_generators[0].spawn
            user.answers.create(
              :problem  => prob, 
              :correct  => rand < 0.80)
          end
        end
      end
    end
  end
end

