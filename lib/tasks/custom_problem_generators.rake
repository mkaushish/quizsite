namespace :generate do
  desc "add custom_problem_generators for problem_types that don't have them"
  task :custom_problem_generators => :environment do
    ProblemType.includes(:problem_generators).find_each do |ptype|
      if ptype.custom_problems_generator.nil?
        pgen = ptype.problem_generators.new(:klass => nil)
        if pgen.save
          puts "SUCCESS: custom problem generator for #{ptype}"
        else
          puts "FAILURE: couldn't create pgen for #{ptype}"
        end
      end
    end
  end
end
