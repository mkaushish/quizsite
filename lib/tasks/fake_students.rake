namespace :generate do
    desc "Generate Fake Students With name as Sample Student Number"
    task :fake_students => :environment do
        def to_email(name) ; "#{name.gsub(/ /, '.')}@smartergrades.com".downcase ; end
        def student(i) ; "Sample Student #{i}" ; end
        
        i = 1
        n = 90
        (student(i)..student(n)).each do |student|
            User.find_by_email(to_email(student)).delete if User.find_by_email(to_email(student))
            user = Student.new( {
                                :name  => student,
                                :email => to_email(student),
                                :password => "testing",
                                :password_confirmation => "testing",
                    } )
            user.confirmed = true

            if user.save
                puts "#{user.name} successfully added"
            else
                puts "#{user.email} could not be added: "
            end
        end
    end
end
