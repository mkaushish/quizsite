namespace :db do
  desc "Reset the problem_stats for vidya questions"
  task :reset_vidya_stats => :environment do
    vasant_trial_time = Time.local(2012, 8, 17, 10)

    puts "\nCalling problemanswer create callbacks"
    Problemanswer.find_each(:conditions => ["created_at < ?", vasant_trial_time]) do |answer|
      answer.run_callbacks(:create)
      # puts answer.created_at 
    end
    puts "\nDone!"
  end
end
