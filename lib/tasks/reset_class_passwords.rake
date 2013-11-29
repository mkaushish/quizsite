namespace :reset do
  desc "reset all of the class passwords in the database"
  task :class_passwords => :environment do
    Classroom.find_each(&:new_password)
  end
end
