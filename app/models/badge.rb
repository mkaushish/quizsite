class Badge < ActiveRecord::Base
  	# attr_accessible :title, :body
  	belongs_to :student

  	# LEVELS  => POINTS #
  	# 1       => 100    # 
  	# 2		  => 1000	#
  	# 3		  => 5000   #
  	# 4		  => 20000	#
  	# 5 	  => 50000  #

   def self.get_badges(student, pset, ptype)
        #Badge.create_all_fake_badges(student)
        result = student.problem_set_instances_num_problem_problem_stats_blue
        unless result.blank?
            Badge.BadgeAPSD(student, result)                        #[LEVEL 5]#
            Badge.BadgePSB(student, result)                         #[LEVEL 3]#
            # Badge.BadgeCAPSWAD(student, result)                     #[LEVEL 2]#
            Badge.BadgeNPSB(student, result, 5)                     #[LEVEL 4]#
            Badge.BadgeNPSB(student, result, 10)                    #[LEVEL 4]#
        end

        answers_correct_with_problem_type = student.answers_correct_with_problem_type_id
        answers_correct = answers_correct_with_problem_type.map{ |v| v[0] }
        unless answers_correct.blank?
            Badge.BadgeNQCIARFNT(student, answers_correct, 5, 5)    #[LEVEL 3]#
            Badge.BadgeNQCIARFNT(student, answers_correct, 5, 10)   #[LEVEL 3]#
            Badge.BadgeNQCIARFNT(student, answers_correct, 5, 15)   #[LEVEL 3]#
            Badge.BadgeNQCIARFNT(student, answers_correct, 10, 5)   #[LEVEL 3]#
            Badge.BadgeNQCIARFNT(student, answers_correct, 10, 10)  #[LEVEL 3]#
            Badge.BadgeNQCIARFNT(student, answers_correct, 10, 15)  #[LEVEL 3]#
        end
        if ptype.nil?
            unless answers_correct_with_problem_type.blank?
                Badge.BadgePTTQCIARFTO(student, answers_correct_with_problem_type, 5)
            end

            problem_types_name = student.problem_types_blue_name
            unless problem_types_name.blank?
                Badge.BadgePTB(student, problem_types_name) #[LEVEL 1]#    
            end
        else
            pty=ProblemType.find_by_id(ptype)
            Badge.BadgePTTQCIARFTO_1(student, answers_correct_with_problem_type.select{|v| v==ptype}, 5, pty)
            Badge.BadgePTB_1(student, pty) #[LEVEL 1]#    
        end
    end

    def self.all_badges(student)
        badge_1=[]
        badge_2=[]
        badge_3=[]
        badge_4=[]
        badge_5=[]
        student.problem_sets.order('id ASC').each do |pset|
            badge_3.push(["Badge" + pset.name + "B", "#{pset.name} Problem Set Blue", 3])

            pset.problem_types.order('id ASC').each do |ptype|
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
    
        @badges=badge_1+badge_2+badge_3+badge_4+badge_5
        return @badges
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
	# def self.BadgeCAPSWAD(student, result)
	# 	@has_BadgeCAPSWAD = student.badges.find_by_badge_key("BadgeCAPSWAD")
 #        if @has_BadgeCAPSWAD.nil?
 #        	if result.select{ |v| v[3] == Date.today }.count > 0 == true
 #                student.points += 1000
 #                student.save
 #                student.news_feeds.create(:content => "Congrats! You have won a new Badge: Completing a problem set within a day", :feed_type => "badge", :user_id => student.id)
 #                student.badges.create(:name => "Problem Set Completed Within a Day",	:badge_key => "BadgeCAPSWAD", :level => 2)
	# 		end
 #        end
	# end


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

    # Badge for getting 10 questions correc in row for first time [LEVEL 2] #
    def self.BadgePTTQCIARFTO(student, answers, n)
        count = 0
        answers.each_with_index do |answer, index|
            unless index == 0
                if answer[index].eql? answer[index - 1]
                    count += 1
                    if count == n
                        problem_type = ProblemType.find_by_id(answer[1].to_i)
                        @has_BadgePTTQCIARFTO = student.badges.find_by_badge_key("Badge#{problem_type.name}TQC")
                        if @has_BadgePTTQCIARFTO.nil?
                            student.points += 1000
                            student.save
                            student.news_feeds.create(:content => "Congrats! You have won a new Badge: #{n} questions correct in a row for the first time only of #{problem_type.name}", :feed_type => "badge", :user_id => student.id)
                            student.badges.create(:name => "#{n} Questions Correct in a Row for the First Time of #{problem_type.name}", :badge_key => "Badge#{problem_type.name}TQC", :level => 2)         
                        end
                    end
                else
                    count = 0
                end
            end
        end
    end
    def self.BadgePTTQCIARFTO_1(student, answers, n, pty)
        problem_type = pty
        @has_BadgePTTQCIARFTO = student.badges.find_by_badge_key("Badge#{problem_type.name}TQC")
        if @has_BadgePTTQCIARFTO.nil?
            if answers.first(n).select{|v| v[0]=="true"}.count == 5
            student.points += 1000
            student.save
            student.news_feeds.create(:content => "Congrats! You have won a new Badge: #{n} questions correct in a row for the first time only of #{problem_type.name}", :feed_type => "badge", :user_id => student.id)
            student.badges.create(:name => "#{n} Questions Correct in a Row for the First Time of #{problem_type.name}", :badge_key => "Badge#{problem_type.name}TQC", :level => 2)         
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
end