namespace :generate do
  desc "Make starting users Vasant Valley"
  task :VVusers => :environment do
    userinfo = []

    IO.foreach 'lib/tasks/VV_names.csv' do |line|
      name = line.split(",").last.split(" ")
      userinfo << { :name => "#{name[0]} #{name[1]}", :email => "#{name[0]}.#{name[1]}".downcase, :class => "#{line.split(",")[0]}" }
    end

    classes = {
      '6A' => Classroom.where(:name => 'VV 6A')[0],
      '6B' => Classroom.where(:name => 'VV 6B')[0],
      '6C' => Classroom.where(:name => 'VV 6C')[0]
    }

    userinfo.each do |userhash|
      $stderr.puts userhash.inspect
      if User.find_by_email(userhash[:email])
        User.find_by_email(userhash[:email]).delete
      end
      user = Student.new( {
        :name => userhash[:name],
        :email => userhash[:email],
        :password => userhash[:password] || "newpass",
        :password_confirmation => userhash[:password] || "newpass",
      } )
      user.confirmed = true


      if user.save
        puts "#{user.name} successfully added"
        classes[ userhash[:class] ].assign! user
      else
        puts "#{user.name} could not be added: #{user.errors.full_messages}"
      end
    end
  end
end
