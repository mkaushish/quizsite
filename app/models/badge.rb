class Badge < ActiveRecord::Base
  	# attr_accessible :title, :body
  	belongs_to :student

  	# LEVELS  => POINTS #
  	# 1       => 100    # 
  	# 2		  => 1000	#
  	# 3		  => 5000   #
  	# 4		  => 20000	#
  	# 5 	  => 50000  #

	def self.get_badges(student)
        result = student.problem_set_instances_num_problem_problem_stats_blue

        unless result.blank?
            Badge.BadgeAPSD(student, result)
            Badge.BadgePSB(student, result)
            Badge.BadgeCAPSWAD(student, result)
            Badge.BadgeNPSB(student, result, 5)
            Badge.BadgeNPSB(student, result, 10)
        end

        answers = student.answers_correct
        unless answers.blank?
            Badge.BadgeNQCIARFTO(student, answers, 5)
            Badge.BadgeNQCIARFTO(student, answers, 10)
            Badge.BadgeNQCIARFNT(student, answers, 5, 5)
            Badge.BadgeNQCIARFNT(student, answers, 5, 10)
            Badge.BadgeNQCIARFNT(student, answers, 5, 15)
            Badge.BadgeNQCIARFNT(student, answers, 10, 5)
            Badge.BadgeNQCIARFNT(student, answers, 10, 10)
            Badge.BadgeNQCIARFNT(student, answers, 10, 15)
        end

        problem_types_name = student.problem_types_blue_name
        unless problem_types_name.blank?
            Badge.BadgePTB(student, problem_types_name)    
        end
    end

    # Badge for all problem sets done [LEVEL 5]#
	def self.BadgeAPSD(student,result)
        @has_BadgeAPSD = student.badges.find_by_badge_key("BadgeAPSD")
        if @has_BadgeAPSD.nil?
            result_length = result.length
            true_count = 0
            result.each do |res|
                true_count += 1 if res[1] == true
            end
            if result_length == true_count
                student.points += 50000
                student.save
                student.news_feeds.create(:content => "Congrats! You have won a new Badge: All problem sets done ", :feed_type => "badge", :user_id => student.id)
                student.badges.create(:name => "All Problem Sets Blue", :badge_key => "BadgeAPSD", :level => 5)
        	end
        end
    end

	# Badge for getting problem set blue [LEVEL 3] #
	def self.BadgePSB(student,result)
		result.each do |res|
            problem_set_name = res[0]
            problem_set_blue = res[1]
            problem_stats_blue_count = res[2]
           
            if problem_set_blue == true

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
    end

    # Badge for getting n problem sets blue [LEVEL 4]#
    def self.BadgeNPSB(student, result, n)
    	@has_BadgeNPSD = student.badges.find_by_badge_key("Badge#{n}PSD") 
        
        if @has_BadgeNPSD.nil?
            result_length = result.length
            true_count = result.select{ |v| v[1] == "true" }.count
            if true_count == n
                student.points += 20000
                student.save
                student.news_feeds.create(:content => "Congrats! You have won a new Badge: #{n} problem sets done!!", :feed_type => "badge", :user_id => student.id)
                student.badges.create(:name => "#{n} Problem Sets Blue", :badge_key => "Badge#{n}PSD", :level => 4)
            end
        end
    end

	# Badge for completing a problem set within a day [LEVEL 2]#
	def self.BadgeCAPSWAD(student, result)
		@has_BadgeCAPSWAD = student.badges.find_by_badge_key("BadgeCAPSWAD")
        if @has_BadgeCAPSWAD.nil?
        	if result.select{ |v| v[3] == Date.today }.count > 0 == true
                student.points += 1000
                student.save
                student.news_feeds.create(:content => "Congrats! You have won a new Badge: Completing a problem set within a day", :feed_type => "badge", :user_id => student.id)
                student.badges.create(:name => "Problem Set Completed Within a Day",	:badge_key => "BadgeCAPSWAD", :level => 2)
			end
        end
	end

    # Badge for n questions correct in a row for the first time only [LEVEL 2]#
    def self.BadgeNQCIARFTO(student, answers, n)
        @has_BadgeNQCIARFTO = student.badges.find_by_badge_key("Badge#{n}QCIARFTO")
        if @has_BadgeNQCIARFTO.nil?                 
            answers_with_limit = answers.first(n)
            true_count = answers_with_limit.select{ |v| v }.count
            if true_count == n
                student.points += 1000
                student.save
                student.news_feeds.create(:content => "Congrats! You have won a new Badge: #{n} questions correct in a row for the first time only ", :feed_type => "badge", :user_id => student.id)
                student.badges.create(:name => "#{n} Questions Correct in a Row for the First Time", :badge_key => "Badge#{n}QCIARFTO", :level => 2)
            end
        end
    end

	# Badge for getting n questions correct in a row for n times [LEVEL 3] #
	def self.BadgeNQCIARFNT(student, answers, n, times)
        a = 0
        b = 0
        answers.each do |correct|
            if correct == true
                a += 1
            else
                a = 0
            end
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
end