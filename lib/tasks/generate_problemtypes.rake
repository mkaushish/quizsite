namespace :generate do
  desc "add in the problem_types and default problem_generators for the smarter grades problems"
  task :problem_types => :environment do
    require 'grade6'

    CHAPTERS.each do |chapter|
      puts "CHAPTER #{chapter::TITLE}"

      # first ensure all the problem_types exist
      ptypes = []
      chapter::PROBLEMS.each do |problem|
        puts "\t#{problem.type}"
        pt = ProblemType.find_by_name(problem.type)
        if pt.nil?
          pt = ProblemType.new(:name => problem.type)
          puts "\t\ttype: #{pt.save ? "success" : "failure"}"
        else
          puts "\t\ttype already exitst!"
        end

        # and all of our default smartergrades problem generators
        pg = pt.problem_generators.where("klass NOTNULL")
        if pg.empty?
          new_pg = pt.problem_generators.build(:klass => problem.to_s)
          print "\t\tgenerator: "
          if new_pg.save
            puts "success"
          else
            puts "failure: #{new_pg.errors.full_messages}"
          end
        else
          puts "\t\tgenerator already exitst!"
        end

        ptypes << pt
      end

      # Make the chapter problem set, and set it's problem_types to those we've just created
      problem_set = ProblemSet.find_by_name(chapter::TITLE) || ProblemSet.create(:name => chapter::TITLE)
      problem_set.problem_types = ptypes

      print "\tPROBLEM SET for #{problem_set.name}: "
      if problem_set.save
        puts "successfully created"
      else
        puts "faild: " + problem_set.errors.full_messages
      end
    end
  end
end
