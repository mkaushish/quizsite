namespace :db do
  desc "Record starting users as confirmed"
  task :confirm_users => :environment do
    User.where(:confirmed => false).each do |user|
      user.confirmed = true
      if user.save(:validate => false)
        $stderr.puts "#{user.name} confirmed"
      else
        $stderr.puts "#{user.name} NOT confirmed"
      end
    end
  end
end
