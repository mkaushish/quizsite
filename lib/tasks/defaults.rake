namespace :generate do
  desc "generate the default database, problems and up"
  task :defaults do
    Rake::Task["generate:smartergrades"].invoke
    Rake::Task["generate:master_problem_sets"].invoke
    Rake::Task["generate:users"].invoke
  end
end
