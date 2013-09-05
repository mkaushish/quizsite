namespace :generate do
    desc "Make Students for Grade 6 and 7 of Vasant Valley School"
    task :create_vvs_7a_classrooms_with_students => :environment do

        classrooms_with_students = [
            {   :class_name => "7a VVS", 
                :students => ["Advait Sinha", "Ahliyaa Bakshi", "Anhiti Minocha", "Arhaan Jain", "Ayaan Sagar", "Bhanavi Bahl", "Daivik John Alva",
                                "Devashi Jain", "Diya Sharan", "Gauri Uttam", "Ishan Roy", "Jujhar Singh Chadha", "Kabeer Singh Thockchom", 
                                "Krishnesh S Puri", "Kyra Bhalla", "Mahin Bharadwaj", "Mayana Puri", "Nitya Dhingra", "Prisha Kumar", "Raul Singh",
                                "Rhea Chawla", "Rhea Kothari", "Shaurya Sarin", "Shauryavardhan Singh", "Shohom R Dasgupta", "Sia Dawar", 
                                "Suyash Bhatia", "Veeraj Jindal", "Yashoda Nicolle Jayal", "Yuv Arora", "Zoraver Mehta"]
            }
        ]

        teacher = User.find_by_email("t.homasramfjord@gmail.com")
        puts "#{teacher.name} found !" unless teacher.blank?
        
        classrooms_with_students.each do |cs_hash|
            classroom = Classroom.find_by_name(cs_hash[:class_name])
            classroom ||= Classroom.new(:name => cs_hash[:class_name])
            classroom.new_password
            classroom.save!
            unless classroom.blank?
                classroom_teacher = classroom.classroom_teachers.find_by_teacher_id(teacher.id) 
                classroom_teacher ||= classroom.classroom_teachers.create(:teacher_id => teacher.id) unless classroom.blank?
            end
            unless classroom.blank? and classroom_teacher.blank?
                puts "#{classroom.name} created successfully and assigned to #{teacher.name}"
                
                cs_hash[:students].each do |student|
                    email = student.delete(" ").downcase.concat("@smartergrades.com")
                    user = User.find_by_email(email)
                    unless user
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
                            puts "#{user.name} could not be added: "
                        end
                    else 
                        classroom_assigment = user.classroom_assignments.find_by_classroom_id(classroom.id) 
                        if classroom_assigment
                            puts "#{classroom.name} not assigned to #{user.name}"
                        else classroom.assign! user
                            puts "#{classroom.name} assigned to #{user.name} successfully"
                        end
                    end    
                end
            end       
        end
    end
end