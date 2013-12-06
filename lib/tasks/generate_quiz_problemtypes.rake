namespace :generate do
  desc "add in the quiz_problem_types for the Quizzes already in the database"
  task :quiz_problem_types => :environment do
    require 'grade6' 

    # cache the ptypes lazily
    ptypes_hash = Hash.new { |hash, key| hash[key] = ProblemType.find_by_klass(key) }

    Quiz.find_each do |quiz|
      if quiz.problem_types.empty?
        $stderr.puts "generating quiz_problem_types for #{quiz.id} #{quiz.name} owned by user #{quiz.user_id}"
        quiz.ptypes.each do |ptype|
          $stderr.print (quiz.add_problem_type ptypes_hash[ptype.to_s]) ? "+" : "-"
        end
      end
    end
  end
end
