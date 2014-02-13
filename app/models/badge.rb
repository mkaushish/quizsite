class Badge < ActiveRecord::Base
  	# attr_accessible :title, :body
  	belongs_to :student, counter_cache: :badges_count
    belongs_to :merit_given_by, :class_name => "Teacher",
                                :foreign_key => "teacher_id"



  	# LEVELS  => POINTS #
  	# 1       => 100    # 
  	# 2		  => 1000	#
  	# 3		  => 5000   #
  	# 4		  => 20000	#
  	# 5 	  => 50000  #

    after_create :update_badges_counters_for_student

    def self.levels
        ["1","2","3","4","5"]
    end

    def self.get_badges(student, pset, ptype)
        #Badge.create_all_fake_badges(student)
        result                              = student.problem_set_instances_num_problem_problem_stats_blue
        answers_correct_with_problem_type   = student.answers_correct_with_problem_type_id
        answers_correct                     = answers_correct_with_problem_type.map{ |v| v[0] }
        
        unless result.blank?
            _result_count                   = result.count{ |v| v[1] == true }
            Badge.BadgeAPSD( student, result )                          unless result.map{ |v| v[1] }.include? false                        #[LEVEL 5]# 
            Badge.BadgePSB( student, result.select{ |v| v[1] == true} ) unless _result_count == 0                        #[LEVEL 3]#
            
            [5, 10].each { |v| Badge.BadgeNPSB(student, v) if _result_count >= v }                                       #[LEVEL 4]#
            
            # Badge.BadgeCAPSWAD(student, result)                     #[LEVEL 2]#
        end
        
        [ [ 5, 5 ], [ 5, 10 ], [ 5, 15 ], [ 10, 5 ], [ 10, 10 ], [ 10, 15 ] ].each { |v| Badge.BadgeNQCIARFNT( student, answers_correct, v[0], v[1] ) unless answers_correct.first( v[0] ).include? false } unless answers_correct.blank? #[LEVEL 3]#
        
        if ptype.nil?
            problem_types_name              = student.problem_types_blue_name
            
            Badge.BadgePTTQCIARFTO(student, answers_correct_with_problem_type, 5)   unless answers_correct_with_problem_type.blank?
            Badge.BadgePTB(student, problem_types_name)                             unless problem_types_name.blank?       #[LEVEL 1]#    
            
        else
            pty                             = ProblemType.find_by_id(ptype)
            Badge.BadgePTB_1(student, pty) #[LEVEL 1]#    
        end
    end

    def self.all_badges(object) # For array of all badges that a classroom / student can get # # you can change classrooms to students or vice-versa #
        badge_1 = []
        badge_2 = []
        badge_3 = []
        badge_4 = []
        badge_5 = []
        object.problem_sets.includes(:problem_types).order('id ASC').each do |pset|
            badge_3.push(["Badge" + pset.name + "B", "#{pset.name} Problem Set Blue", 3])

            pset.problem_types.each do |ptype|
                badge_1.push(["Badge" + ptype.name + "B", "#{ptype.name} Problem Type Blue", 1])
                badge_2.push(["Badge" + ptype.name + "TQC", "5 Questions Correct in a Row for the First Time of #{ptype.name}", 2])         
            end
        end
        
        # @badges += [["BadgeCAPSWAD", "Problem Set Completed Within a Day", 2],["BadgeTRQC", "10 red Questions Correct", 2]]
        badge_5 << ["BadgeAPSD", "All Problem Sets Blue", 5]

        for i in 0...2
            for j in 0...3
                badge_3 << ["Badge#{(i+1)*5}QCIARF#{(j+1)*5}T", "#{(i+1)*5} Questions Correct in a Row for the #{(j+1)*5} Time", 3]
            end
            badge_4 << ["Badge#{(i+1)*5}PSB", "#{(i+1)*5} Problem Sets Blue", 4]
        end
    
        @badges = badge_1 + badge_2 + badge_3 + badge_4 + badge_5
        return @badges
    end

    # Badge for all problem sets done [LEVEL 5] #
	def self.BadgeAPSD( student, result )
        @has_BadgeAPSD = student.badges.find_by_badge_key("BadgeAPSD")
        if @has_BadgeAPSD.nil?
            student.points += 50000
            student.save
            student.news_feeds.create(:content => "Congrats! You have won a new Badge: All problem sets done ", :feed_type => "badge", :user_id => student.id)
            student.badges.create(:name => "All Problem Sets Blue", :badge_key => "BadgeAPSD", :level => 5)
        end
    end

	# Badge for getting problem set blue [LEVEL 3] #
	def self.BadgePSB( student, result )
		result.each do |res|
            problem_set_name = res[0]
            problem_stats_blue_count = res[2]

            @has_BadgePSB = student.badges.find_by_badge_key("Badge#{problem_set_name}B")
            if @has_BadgePSB.nil?
                if problem_stats_blue_count == 0
                    student.points += 5000
                    student.save
                    student.news_feeds.create(:content => "Congrats! You have won a new Badge: #{problem_set_name} Blue !!", :feed_type => "badge", :user_id => student.id)
                    student.badges.create(:name => "#{problem_set_name} Problem Set Blue", :badge_key => "Badge#{problem_set_name}B", :level => 3)
                elsif problem_stats_blue_count == 1
                    @has_Warning = student.news_feeds.find_by_feed_type("#{problem_set_name}_warning")
                    student.news_feeds.create(:content => "Need 1 problem type to get #{problem_set_name} Blue!!", :feed_type => "#{problem_set_name}_warning", :user_id => student.id) if @has_Warning.nil?
                end
            end
        end
    end

    # Badge for getting n problem sets blue [LEVEL 4]#
    def self.BadgeNPSB( student, n )
    	@has_BadgeNPSD = student.badges.find_by_badge_key("Badge#{n}PSD") 
        
        if @has_BadgeNPSD.nil?
            student.points += 20000
            student.save
            student.news_feeds.create(:content => "Congrats! You have won a new Badge: #{n} problem sets done!!", :feed_type => "badge", :user_id => student.id)
            student.badges.create(:name => "#{n} Problem Sets Blue", :badge_key => "Badge#{n}PSD", :level => 4)
        end
    end

	

	# Badge for getting n questions correct in a row for n times [LEVEL 3] #
	def self.BadgeNQCIARFNT(student, answers, n, times)
        a = 0
        b = 0
        answers.each do |correct|
            ( correct == true ) ? ( a += 1 ) : ( a = 0 )
            if a == n
                b += 1
                a = 0
            end
            if b == times
                @has_BadgeNQCIARFNT = student.badges.find_by_badge_key("Badge#{n}QCIARF#{times}T") 
                if @has_BadgeNQCIARFNT.nil?
                    student.points += 5000
                    student.save
                    student.news_feeds.create(:content => "Congrats! You have won a new Badge: #{n} questions correction in a row #{times} times!!", :feed_type => "badge", :user_id => student.id)
                    student.badges.create(:name => "#{n} Questions Correct in a Row #{times} Times", :badge_key => "Badge#{n}QCIARF#{times}T", :level => 3)
                end 
            end
        end
    end

    # Badge for getting problem type blue [LEVEL 1]#
    def self.BadgePTB(student, problem_types_name)
        problem_types_name.each do |problem_type_name|
            @has_BadgePTB = student.badges.find_by_badge_key("Badge#{problem_type_name}B")
            if @has_BadgePTB.nil?
                student.points += 100
                student.save
                student.news_feeds.create(:content => "Congrats! You have won a new Badge: #{problem_type_name} Blue !!", :feed_type => "badge", :user_id => student.id)
                student.badges.create(:name => "#{problem_type_name} Problem Type Blue", :badge_key => "Badge#{problem_type_name}B", :level => 1)
            end 
        end
    end

    # Badge for getting 10 questions correct in a problem type in row for first time [LEVEL 2] #
    def self.BadgePTTQCIARFTO(student, answers, n)
        _answers = answers.sort {|a,b| a[1] <=> b[1]}
        _problem_type_ids = _answers.collect {|v| v[1]}.uniq
        _true_problem_type_ids = []
        _problem_type_ids.each { |problem_type_id|  _true_problem_type_ids.push problem_type_id if _answers.select{ |v| v[1] == problem_type_id }.first(10).count == 10 and !_answers.select{ |v| v[1] == problem_type_id }.first(10).collect{ |v| v[0] }.include? false }
        unless _true_problem_type_ids.blank?
            _true_problem_type_ids.each do |problem_type_id|
                problem_type = ProblemType.find_by_id(problem_type_id)
                @has_BadgePTTQCIARFTO = student.badges.find_by_badge_key("Badge#{problem_type.name}TQC")
                if @has_BadgePTTQCIARFTO.nil?
                    student.points += 1000
                    student.save
                    student.news_feeds.create(:content => "Congrats! You have won a new Badge: #{n} questions correct in a row for the first time only of #{problem_type.name}", :feed_type => "badge", :user_id => student.id)
                    student.badges.create(:name => "#{n} Questions Correct in a Row for the First Time of #{problem_type.name}", :badge_key => "Badge#{problem_type.name}TQC", :level => 2)         
                end
            end
        end
    end

    
    def self.BadgePTB_1(student, pty)
        problem_type=pty
        if student.badges.find_by_badge_key("Badge#{problem_type.name}B").nil?
            if student.problem_stats.where("problem_type_id = ?", pty.id).last.green?
                student.points += 100
                student.save
                student.news_feeds.create(:content => "Congrats! You have won a new Badge: #{problem_type.name} Blue !!", :feed_type => "badge", :user_id => student.id)
                student.badges.create(:name => "#{problem_type.name} Problem Type Blue", :badge_key => "Badge#{problem_type.name}B", :level => 1)
            end 
        end
    end

    # Badge for completing a problem set within a day [LEVEL 2]#
    # def self.BadgeCAPSWAD(student, result)
    #   @has_BadgeCAPSWAD = student.badges.find_by_badge_key("BadgeCAPSWAD")
    #     if @has_BadgeCAPSWAD.nil?
    #       if result.select{ |v| v[3] == Date.today }.count > 0 == true
    #             student.points += 1000
    #             student.save
    #             student.news_feeds.create(:content => "Congrats! You have won a new Badge: Completing a problem set within a day", :feed_type => "badge", :user_id => student.id)
    #             student.badges.create(:name => "Problem Set Completed Within a Day",  :badge_key => "BadgeCAPSWAD", :level => 2)
    #       end
    #     end
    # end

    # def self.create_all_fake_badges(student)
    #     student.problem_sets.each do |pset|
    #         student.badges.create(:badge_key=> "Badge#{pset.name}B", :name=> "#{pset.name} Problem Set Blue", :level=> 3)
    #         pset.problem_types.each do |ptype|
    #             student.badges.create(:badge_key=> "Badge#{ptype.name}B", :name=> "#{ptype.name} Problem Type Blue", :level=> 1)
    #         end
    #     end
    #     student.badges.create(:badge_key=> "BadgeCAPSWAD", :name=> "Problem Set Completed Within a Day", :level=> 2)
    #     student.badges.create(:badge_key=> "BadgeAPSD", :name=> "All Problem Sets Blue", :level=> 5)
    #     for i in 0...2
    #         for j in 0...3
    #             student.badges.create(:badge_key=> "Badge#{(i+1)*5}QCIARF#{(j+1)*5}TO", :name=> "#{(i+1)*5} Questions Correct in a Row for the #{(j+1)*5} Time", :level=> 3)
    #         end
    #             student.badges.create(:badge_key=> "Badge#{(i+1)*5}QCIARFTO", :name=> "#{(i+1)*5} Questions Correct in a Row for the First Time", :level=> 2)
    #             student.badges.create(:badge_key=> "Badge#{(i+1)*5}PSB", :name=> "#{(i+1)*5} Problem Sets Blue", :level=> 4)
    #     end
    # end

    private

    def update_badges_counters_for_student
        student = self.student
        _levels = student.badges.pluck(:level)
        student["badges_level_#{self.level}_count"] = _levels.count(self.level)
        student.save
    end
end