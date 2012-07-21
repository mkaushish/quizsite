namespace :generate do
  desc "Make starting users thomas and madhav"
  task :users => :environment do
    userinfo = [
      { :name => "Thomas Ramfjord",      :email => "thomas.ramfjord@gmail.com", :password => "blah123" },
      { :name => "Madhav Kaushish",      :email => "madhav.kaushish@gmail.com" },
      { :name => "Madhav Kaushish",      :email => "m.adhavkaushish@gmail.com", :idtype => Teacher } #,
      # { :name => "Sanjeev Bikhchandani", :email => "sanjeev@naukri.com" },
      # { :name => "Andrea Kalyn",         :email => "akalyn@oberlin.edu" },
      # { :name => "Mary Kay Gray",        :email => "mary.gray@oberlin.edu" },
      # { :name => "Akhil Dhawan",         :email => "akhildhawan@gmail.com" },
      # { :name => "Rajshree Sood",        :email => "rajyashreesood@yahoo.com" },
      # { :name => "Sandhya Saini",        :email => "sandhyas@vasantvalley.org" },
      # { :name => "Anirudh Bhatnagar",    :email => "smita.bhatnagar@gmail.com" },
      # { :name => "Sample User",          :email => "sample.user@gmail.com" },
      # { :name => "Karan Bedi",           :email => "karan.bedi@nowhere.com" }
    ]

    unless User.find_by_email("t.homasramfjord@gmail.com")
      t = Teacher.create!(:name => "Thomas Ramfjord", :email => "t.homasramfjord@gmail.com", :password => "blah123", :password_confirmation => "blah123")
      t.classrooms.create(:name => "Alpha1")
    end

    userinfo.each do |userhash|
      unless User.find_by_email(userhash[:email])
        klass = userhash[:idtype] || Student
        user = klass.new( {
          :name => userhash[:name],
          :email => userhash[:email],
          :password => userhash[:password] || "newpass",
          :password_confirmation => userhash[:password] || "newpass",
        } )
        user.confirmed = true

        if user.save!
          puts "#{user.name} successfully added"
        else
          puts "#{user.name} could not be added: "
        end
      end
    end
  end
end
