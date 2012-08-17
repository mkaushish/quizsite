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

    #
    # Get names from vidya negetan school, and sign them up
    #
    IO.foreach 'lib/tasks/Vidya_names.csv' do |line|
      name = line.split(",").map { |n| n.strip.downcase.capitalize }
      userinfo << { :name => "#{name[0]} #{name[1]}", :email => "#{name[0]}.#{name[1]}@smartergrades.com" }
    end
    IO.foreach 'lib/tasks/VV_names.csv' do |line|
      name = line.split(",").last.split(" ")
      userinfo << { :name => "#{name[0]} #{name[1]}", :email => "#{name[0]}.#{name[1]}" }
    end

    unless User.find_by_email("t.homasramfjord@gmail.com")
      t = Teacher.new(:name => "Thomas Ramfjord", :email => "t.homasramfjord@gmail.com", :password => "blah123", :password_confirmation => "blah123")
      t.confirmed = true
      t.save!
      t.classrooms.create!(:name => "Alpha1")
      t.homeworks.create!(:name => "Chapter1", :problemtypes => Marshal.dump(Chapter1::PROBLEMS))
      t.classrooms.first.assign!(t.homeworks.first)
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
