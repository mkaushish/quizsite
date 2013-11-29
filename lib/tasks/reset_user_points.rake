namespace :db do
	desc "update points for each user in the users table"
	task :reset_user_points => :environment do
     	User.includes(:problem_stats).find_each do |user|
	       	total_points = user.problem_stats.map(&:points).reduce(:+)
			unless total_points.nil?
				user.points = total_points
				
			else
				user.points = 0
			end
			$stderr.print "#{user.id}: #{user.name}'s points set to #{user.points}: "
			if user.save(:validate => false)
				p "SUCCESS"
			else
				p user.errors.full_messages
			end
		end
   	end
end
