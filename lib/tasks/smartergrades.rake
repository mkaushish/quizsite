namespace :generate do
  desc "Generate the smartergrades classroom and admin user"
  task :smartergrades => :environment do
    sg = Admin.find_by_email("admin@smartergrades.com") || 
         Admin.create!(name: "SmarterGrades",
                       email: "admin@smartergrades.com",
                       password: "H@iR0f&",
                       password_confirmation: "H@iR0f&",
                       confirmed: true)

    if Classroom.smarter_grades.nil?
      Classroom.create name: "SmarterGrades 6"
    end

    puts "smartergrades user and grade 6 class are in the database"
  end
end
