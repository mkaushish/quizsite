namespace :generate do
    desc "Make Students for Grade 6 and 7 of Shiv Nadar School Gurgaon"
    task :create_6_7_package_for_sns => :environment do

        classrooms_with_students = [
            {   :class_name => "SNS G6",
                :students => [ "Aanjaney Kumar", "Aayushi Sharma", "Akansha Jhunjhunwala", "Anay Krishnan", "Arnav Gulati", "Atikant Rathee",
                                "G.S. Charita", "Jney Puri", "Khushi Narang", "Khushi Yadav", "Kshitij Agarwal", "Manan Vaid",
                                "Manik Jhorad", "Prakhar Rai", "Sai Satyapraksh Biswal", "Soham Mukhopadhyay", "Tia Chopra", "Vansh Kapoor" ]
            },
            
            {   :class_name => "SNS G7", 
                :students => [ "Aayush Garg", "Abhiluv Anand", "Amaan Andirat", "Ayush Virmani", "Drishti Mangar", "Paarth Chawla",
                                "Rishit Pachar", "Riya Yadav", "Sahil Singh Manral", "Sanjana Vadapalli", "Shlok Singh", "Simrat Dhaliwal",
                                "Surya Teja Anumolu",  "Vanshika Jain", "Varun", "Yajat Uppal" ]
            }
        ]

        teacher = User.find_by_email("t.homasramfjord@gmail.com")
        puts "#{teacher.name} found !" unless teacher.blank?
        
        classrooms_with_students.each do |cs_hash|
            classroom = Classroom.find_by_name(cs_hash[:class_name])
            classroom ||= Classroom.new(:name => cs_hash[:class_name])
            classroom.new_password
            classroom.save!
            classroom_teacher = classroom.classroom_teachers.create(:teacher_id => teacher.id) unless classroom.blank?
            unless classroom.blank? and classroom_teacher.blank?
                puts "#{classroom.name} created successfully and assigned to #{teacher.name}"
                
                cs_hash[:students].each do |student|
                    email = student.delete(" ").downcase.concat("@sns.edu.in")
                    unless User.find_by_email(email)
                        klass = Student
                        user = klass.new({
                            :name => student,
                            :email => email,
                            :password => "smartergrades",
                            :password_confirmation => "smartergrades",
                            :confirmed => true
                        })
                        if user.save!
                            puts "#{user.name} successfully added"
                            if classroom.assign! user
                                puts "#{classroom.name} assigned to #{user.name} successfully"
                            else
                                puts "#{classroom.name} not assigned to #{user.name}"
                            end
                        else
                            puts "#{user.name} could not be added"
                        end
                    end    
                end
            end       
        end

        sns_teachers = [    
                            { :name => "Meenambika Menon", :email => "meenambika@sns.edu.in" }, 
                            { :name => "Bijo Thomas", :email => "bijo@sns.edu.in" },
                            { :name => "Anuradha Sen", :email => "anuradha.sen@sns.edu.in" } 
                        ]

        sns_teachers.each do |sns_teacher|
            teacher = Teacher.find_by_email(sns_teacher[:email])
            teacher ||= Teacher.create(:name => sns_teacher[:name], :email => sns_teacher[:email], :password => "smartergrades", :password_confirmation => "smartergrades", :confirmed => true)
            classrooms_with_students.each do |cs_hash|
                classroom = Classroom.find_by_name(cs_hash[:class_name])
                classroom_teacher = classroom.classroom_teachers.find_by_teacher_id(teacher.id) unless classroom.blank?
                classroom_teacher ||= classroom.classroom_teachers.create(:teacher_id => teacher.id) unless classroom.blank?
                
                puts "#{classroom.name} created successfully and assigned to #{teacher.name}" unless classroom.blank? and classroom_teacher.blank?
            end
        end            
    end
end