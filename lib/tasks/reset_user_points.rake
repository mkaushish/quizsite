namespace :db do
	desc "update points for each user in the users table"
	task :reset_user_points => :environment do
     	User.find_each do |user|
	       	user.problem_stats.map(&:points).reduce(:+)
			user.save
		end
   	end
end
