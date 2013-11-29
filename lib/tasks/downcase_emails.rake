namespace :db do
  desc "downcase all stored emails for case insensitive finds"
  task :downcase_emails => :environment do
    User.all.each do |user|
      if user.email =~ /[A-Z]/
        $stderr.print "#{user.email} downcased to "
        user.email = user.email.downcase
        if user.save(:validate => false)
          $stderr.puts "#{user.email}"
        else
          $stderr.puts "#{user.email} : FAILURE"
        end
      end
    end
  end
end
