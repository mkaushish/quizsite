namespace :db do
  desc "Make starting users thomas and madhav"
  task :useradd => :environment do
    #User.create!(:name => "Per Ramfjord", :email => "PARAMFJORD@stoel.com",
    #             :password => "newpass", :password_confirmation => "newpass")
    #User.create!(:name => "Nigel Morris", :email => "NMorris@311cameron.com",
    #             :password => "newpass", :password_confirmation => "newpass")
    userinfo = [
      { :name => "Thomas Ramfjord",      :email => "thomas.ramfjord@gmail.com"},
      { :name => "Madhav Kaushish",      :email => "madhav.kaushish@gmail.com"},
      { :name => "Sanjeev Bikhchandani", :email => "sanjeev@naukri.com" },
      { :name => "Andrea Kalyn",         :email => "akalyn@oberlin.edu" },
      { :name => "Mary Kay Gray",        :email => "mary.gray@oberlin.edu" },
      { :name => "Akhil Dhawan",         :email => "akhildhawan@gmail.com" },
      { :name => "Rajshree Sood",        :email => "rajyashreesood@yahoo.com" },
      { :name => "Sandhya Saini",        :email => "sandhyas@vasantvalley.org" },
      { :name => "Anirudh Bhatnagar",    :email => "smita.bhatnagar@gmail.com" },
      { :name => "Karan Bedi",           :email => "karan.bedi@nowhere.com" }
    ]

    userinfo.each do |userhash|
      if User.find_by_email(userhash[:email]).nil?
        User.create!(userhash.merge({:password => "newpass", :password_confirmation => "newpass"}))
      end
    end
    userhash = { :name => "Example User", :email => "exampleuser@gmail.com" }
    if User.find_by_email(userhash[:email]).nil?
      User.create!(userhash.merge({:password => "examplepassword", :password_confirmation => "examplepassword"}))
    end
  end
end
