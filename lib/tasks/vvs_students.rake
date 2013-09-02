namespace :generate do
    desc "Make Students for Grade 6 and 7 of Vasant Valley School"
    task :create_vvs_6_7_classrooms_with_students => :environment do

        classrooms_with_students = [
            {   :class_name => "6a VVS", 
                :students => ["Aadishree Arora", "Aadya Choudhary", "Aahana Banerjee", "Agastya Khanna", "Amaaya Taneja", "Amba Kapoor",
                                "Anandini Khanna", "Anantveer Singh Badal", "Anya Malhotra", "Arjan Dev Singh Musafir", "Armaan Batra", 
                                "Aryaman Bansal", "Dhruv Singh Chauhan", "Diva Ghosh", "Gayatri Gupta", "Jai Singh Rawat", "Jonathan John",
                                "Kathleen Kyra Ireland", "Krish Garg", "Maahir Sachdeva", "Naira Kothari", "Pranavee Kataria", "Raunak Ujala",
                                "Rohil Bahl", "Saanvi Bhatia", "Shaurya Bhardwaj", "Shiv Sharma", "Tanvi Bahl", "Tia Gulyani", "Vama Borah",
                                "Varad Singh Mann", "Yugansh Sehrawat", "Yuvarat Soni", "Yuvraj Singh Mamik"]
            },
            {   :class_name => "6b VVS", 
                :students => ["Amaaya Vijay Arora", "Aanya Singh", "Adi Singh Vohra", "Allen Binu Alex", "Amiya Kumar", "Armaan Tejpal",
                                "Ashna Suri", "Asmita Shah", "Chandsi Kataria", "Chinmayee", "Devansh R Khanna", "Dhruv Rattan Nashier",
                                "Esha Singh Thakran", "Harnoor Singh", "Idekaa Dang", "Kabir Sharma", "Kartik Kajaria", "Medha Jairath Varma",
                                "Naina Shukla", "Pranay Singh Sandhu", "Raghauv Taneja", "Ransher Singh Manhas", "Reshad Louis Pilgrim",
                                "Sanah Kapur", "Sehej Kaur", "Shubham Kalantri", "Smitee S Oberoi", "Sumona Sarin"]
            },
            {   :class_name => "6c VVS", 
                :students => ["Aadil Anand", "Aadya Tayal", "Aashna Shail Sawhney", "Aditya Parashar", "Adya Jatia", "Adyant Singhal",
                                "Ahmar Farhan Saleh", "Aishwarya Arya", "Anahita Jain", "Anirudh Amrit Kaushik", "Armaana Chawla", "Arnav Sethi",
                                "Arusha Nirvan", "Aryan Sachdeva", "Ayaan Gulyani", "Bhavya Mitra", "Devaki Divan", "Didar Joshua Joseph Rebello",
                                "Ilisha Chauhan", "Karamvir Chopra", "Karan Dhingra", "Krish Aggarwal", "Nandika Saihgal", "Rishad Luthra",
                                "Saiesha Gupta", "Sehyr Malhotra", "Shaurya Sood", "Shiv Mehta", "Shivam Sharma", "Siya Katyal", "Suhasini Takkar",
                                "Swabhanu Saurabh", "Tanvi Singh", "Vidur Jain"]            
            },
            {   :class_name => "7a VVS", 
                :students => ["Advait Sinha", "Ahliyaa Bakshi", "Anhiti Minocha", "Arhaan Jain", "Ayaan Sagar", "Bhanavi Bahl", "Daivik John Alva",
                                "Devashi Jain", "Diya Sharan", "Gauri Uttam", "Ishan Roy", "Jujhar Singh Chadha", "Kabeer Singh Thockchom", 
                                "Krishnesh S Puri", "Kyra Bhalla", "Mahin Bharadwaj", "Mayana Puri", "Nitya Dhingra", "Prisha Kumar", "Raul Singh",
                                "Rhea Chawla", "Rhea Kothari", "Shaurya Sarin", "Shauryavardhan Singh", "Shohom R Dasgupta", "Sia Dawar", 
                                "Suyash Bhatia", "Veeraj Jindal", "Yashoda Nicolle Jayal", "Yuv Arora", "Zoraver Mehta"]
            },
            {   :class_name => "7b VVS", 
                :students => ["Aadya Nath", "Adit Kapoor", "Aditya Venkataraman", "Aman Aryan Roach", "Aman Nayar", "Arushi Bhutani",
                                "Aryan Singh", "Disha Kumari Singh", "Drishti Kumari Singh", "Jagteshwar Singh Bedi", "Jai Arora", "Kabir Singh",
                                "Manya Bharadwaj", "Pranav Jain", "Priyavrat Gupta", "Rabiya Gupta", "Rajveer Sardana", "Rhea Grewal", "Ritvick Bhalla",
                                "Rudrabhishek  Lalwani", "Sahil Armaan Kumar", "Saira Majithia", "Saniya Sidhu", "Serena Bhullar", "Shiv Singh Juneja",
                                "Shyna Kumar", "Suhana Gupta", "Sumer Singh Grewal", "Tanishq Aneja", "Uday Chanana"]
            },
            {   :class_name => "7c VVS", 
                :students => ["Abhijai Mahajan", "Aditya Vikram Singh", "Amay Gupta", "Ananya Mehta", "Aryaman Chawla", "Aryan Bakshi",
                                "Aryan Sadh", "Ashutosh Trivedi", "Avinash Ghosh", "Devansh Gupta", "Dhriti Singh", "Kaira Biswas", "Kuber Malhotra", 
                                "Manveer Singh Chhabra", "Manya Kapur", "Mehr Kohli", "Mohammad Hamza Khan", "Niharika Rao", "Palak Jain",
                                "Prithvi Singh", "Priyam Deka", "Rajveer Singh Kochar", "Reet Chhatwal", "Shreyas Todi", "Shyra Bhalla", "Subiya Asad",
                                "Suryadip Bandyopadhyay", "Talin Sharma", "Vinayak Satsangi", "Zalia Maya"]
            }
        ]

        teacher = User.find_by_email("t.homasramfjord@gmail.com")
        puts "#{teacher.name} found !" unless teacher.blank?
        
        classrooms_with_students.each do |cs_hash|
            classroom = Classroom.new(:name => cs_hash[:class_name])
            classroom.new_password
            classroom.save!
            classroom_teacher = classroom.classroom_teachers.create(:teacher_id => teacher.id) unless classroom.blank?
            unless classroom.blank? and classroom_teacher.blank?
                puts "#{classroom.name} created successfully and assigned to #{teacher.name}"
                
                cs_hash[:students].each do |student|
                    email = student.delete(" ").downcase.concat("@smartergrades.com")
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
                            puts "#{user.name} could not be added: "
                        end
                    end    
                end
            end       
        end
    end
end