namespace :oneoffs do
  desc "calculate the points again now that they're being tracked by problem_stats instead of problem_set_stats"
  # NOTE I'm loading it ALL into memory - this should be ok since we don't have that many right now
  # ALSO NOTE this will not work with problems that have been after they're turned yellow again
  task :calculate_points => :environment do 
    pset_stats = ProblemSetStat.all
    pstats = pset_stats.map { |e| e.problem_stat } # problem_stats should be eager loaded

    # set all to 0
    long_ago = Time.new(2002)
    pstats.each { |stat| stat.count = 0; stat.points = 0; stat.correct = 0; stat.stop_green = long_ago }

    # add up each problem
    pstats_hash = Hash[pset_stats.map { |stat| [ [stat.problem_stat.user_id, stat.problem_type_id], stat] }]
    Answer.includes(:problem_type).all.each do |ans|
      key = [ans.user_id, ans.problem_type.id]

      unless pstats_hash[key].nil?
        pstats_hash[key].update_w_ans(ans)
      else
        puts "couldn't find stat for with user #{ans.user_id} and problem_type #{ans.problem_type}"
      end
    end

    # save em all
    pstats_hash.each_value { |stat| stat.save }
  end
end
