namespace :generate do
  desc "generate the default database, problems and up"
  task :defaults do
    Rake::Task["generate:smartergrades"].invoke
    Rake::Task["generate:problem_types"].invoke # also creates problem_sets
    Rake::Task["generate:users"].invoke
  end
end
