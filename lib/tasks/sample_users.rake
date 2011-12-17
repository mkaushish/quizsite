namespace :db do
  desc "Make starting users thomas and madhav"
  task :useradd => :environment do
    User.create!(:name => "Thomas Ramfjord", :email => "thomas.ramfjord@gmail.com",
                 :password => "newpass", :password_confirmation => "newpass")
    User.create!(:name => "Madhav Kaushish", :email => "madhav.kaushish@gmail.com",
                 :password => "newpass", :password_confirmation => "newpass")
    User.create!(:name => "Per Ramfjord", :email => "PARAMFJORD@stoel.com",
                 :password => "newpass", :password_confirmation => "newpass")
    User.create!(:name => "Nigel Morris", :email => "NMorris@311cameron.com",
                 :password => "newpass", :password_confirmation => "newpass")
  end
end
