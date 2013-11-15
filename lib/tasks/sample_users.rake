namespace :generate do
    desc "Make starting users thomas and madhav"
    task :users => :environment do
        userinfo = [
            { :name => "Thomas Ramfjord",      :email => "thomas.ramfjord@gmail.com", :password => "blah123" },
            { :name => "Madhav Kaushish",      :email => "madhav.kaushish@gmail.com" },
            { :name => "Amandeep Singh",       :email => "amandeep.bhamra@gmail.com", :password => "testing" }, #,
            { :name => "Madhav Kaushish",      :email => "m.adhavkaushish@gmail.com", :idtype => Teacher }
          
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
            t = Teacher.new(:name => "Thomas Ramfjord", :email => "t.homasramfjord@gmail.com", :password => "blah123", :password_confirmation => "blah123")
            t.confirmed = true
            t.save!
            classroom = Classroom.new name: "Test"
            classroom.new_password
            if classroom.save
                classroom_teacher = t.classroom_teachers.create(:classroom_id => classroom.id)  
                puts "Test teacher and classroom successfully saved"
            else
                puts "COULDN'T SAVE TEST CLASS!"
            end
            classroom = Classroom.find_by_name("SmarterGrades 6")
            ProblemSet.all.each do |ps| 
                classroom.assign! ps
            end
        end

        classroom = Classroom.find_by_name("SmarterGrades 6")
        teacher = Teacher.find_by_email("t.homasramfjord@gmail.com")
        thomas_as_sgclassroom__teacher = teacher.classroom_teachers.create(:classroom_id => classroom.id)  
        userinfo.each do |userhash|
            unless User.find_by_email(userhash[:email])
                klass = userhash[:idtype] || Student
                user = klass.new( {
                    :name => userhash[:name],
                    :email => userhash[:email],
                    :password => userhash[:password] || "newpass",
                    :password_confirmation => userhash[:password] || "newpass",
                    :confirmed => true
                } )
                if user.save!
                    puts "#{user.name} successfully added"
                    unless user.class == Teacher
                        if classroom.assign! user
                            puts "#{classroom.name} assigned to #{user.name} successfully"
                        else
                            puts "#{classroom.name} not assigned to #{user.name}"
                        end
                    end
                else
                    puts "#{user.name} could not be added: "
                end
            end
        end
    end
end