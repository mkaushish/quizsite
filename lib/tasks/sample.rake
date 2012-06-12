namespace :db do
  task :sampleuser => :environment do
    user=User.find_by_email("sample.user@gmail.com")
    chap=[Chapter1, Chapter2, Chapter3, Chapter4, Chapter6, Chapter7]
    chap.each do |ch|
      user.quizzes.new(:problemtypes => ch::PROBLEMS, :name => ch.to_s)
      ch::PROBLEMS.each do |pr| 
        10.times do
          prob=Problem.new
          prob.my_initialize(pr)
          prob.save
          user.problemanswers.create(
            :problem  => prob, 
            :correct  => [true, false].sample,
            :response => Marshal.dump({}))
        end
      end
    end
  end
end


