namespace :db do
  desc "Record starting users as confirmed"
  task :confirm_users => :environment do
    User.where(:confirmation_code => nil).each do |user|
      user.password = "newpass"
      user.password_confirmation = "newpass"
      user.confirmed = true
      $stderr.puts user.to_s
      user.save!
    end
  end
end
