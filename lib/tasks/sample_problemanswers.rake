namespace :generate do
  task :problemanswers => :environment do
    users = [ "thomas.ramfjord@gmail.com", "madhav.kaushish@gmail.com" ]
    users.map { |email| User.find_by_email(email) }.each do |user|
      chap=[Chapter1, Chapter2, Chapter3, Chapter4, Chapter6, Chapter7]
      chap.each do |ch|
        ch::PROBLEMS.each do |pr| 
          10.times do
            prob=Problem.new
            prob.my_initialize(pr)
            prob.save
            user.problemanswers.create(
              :problem  => prob, 
              :correct  => rand < 0.90
              :response => Marshal.dump({}))
          end
        end
      end
    end
  end
end


