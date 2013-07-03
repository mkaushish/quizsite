class Badge < ActiveRecord::Base
  	# attr_accessible :title, :body
  	belongs_to :student

  	# LEVELS  => POINTS #
  	# 1       => 100    # 
  	# 2		  => 1000	#
  	# 3		  => 5000   #
  	# 4		  => 20000	#
  	# 5 	  => 50000  #


	# Badge for all problem sets done [LEVEL 5]#
	def self.BadgeAPSD(student)
        @result = Array.new
        student.problem_set_instances.order("id").each do |pset|
            @result = @result.push (pset.num_problems - pset.problem_stats.blue.count) == 0
        end
        result_length = @result.length
        true_count = @result.select {|v| v =="true"}.count
        if (result_length- true_count) == 0
        	@has_BadgeAPSD = student.badges.find_by_badge_key("BadgeAPSD") 
			student.news_feeds.create(:content => "Congrats! You have won a new Badge: All problem sets done ", :feed_type => "badge", :user_id => student.id) if @has_BadgeAPSD.nil?
        	if @has_BadgeAPSD.nil?
        		student.points += 50000
        		student.save
        		student.badges.create(:name => "All problem sets done", :badge_key => "BadgeAPSD", :level => 5)
        	end
		end
    end

	# Badge for getting problem set blue [LEVEL 3] #
	def self.BadgePSB(student)
		@result = Array.new
        student.problem_set_instances.each do |pset|
            unless pset.problem_stats.blank?
            	total_minus_blue = pset.num_problems - pset.problem_stats.blue.count
            	
            	if total_minus_blue == 0
            		pset_name = pset.problem_set.name
            		@has_BadgePSB = student.badges.find_by_badge_key("BadgePSB")
            		student.news_feeds.create(:content => "Congrats! You have won a new Badge: #{pset_name} Blue !!", :feed_type => "badge", :user_id => student.id) if @has_BadgePSB.nil?
            		if @has_BadgePSB.nil?
            			student.points += 5000
            			student.save
            			student.badges.create(:name => "#{pset_name} Blue !!", :badge_key => "BadgePSB", :level => 3)
          		  	end
        	
        		elsif 10*(total_minus_blue) < pset.num_problems
        		
        			pset_name = pset.problem_set.name
        			@has_Warning = student.news_feeds.find_by_feed_type("#{pset_name}_warning")
        			student.news_feeds.create(:content => "Need #{pset.problem_stats.count - pset.problem_stats.blue.count} problem types to get #{pset_name} Blue!!", :feed_type => "#{pset_name}_warning", :user_id => student.id) if @has_Warning.nil?

        	
        		elsif total_minus_blue == 1
        			pset_name = pset.problem_set.name
        			@has_Warning = student.news_feeds.find_by_feed_type("#{pset_name}_warning")
        			student.news_feeds.create(:content => "Need 1 problem type to get #{pset_name} Blue!!", :feed_type => "#{pset_name}_warning", :user_id => student.id) if @has_Warning.nil?
        		end	
      	end
        end
    end


    # Badge for getting problem type blue [LEVEL 1]#
    def self.BadgePTB(student)
    	student.problem_set_instances.order("id").each do |pset|
    		pset.problem_stats.blue.map(&:problem_type_id).each do |ptype|
    			problem_type = ProblemType.find_by_id(ptype)
    			@has_BadgePTB = student.badges.find_by_badge_key("Badge#{problem_type.name}B")
            	if @has_BadgePTB.nil?
            		student.points += 100
            		student.save
            		student.badges.create(:name => "#{problem_type.name} Blue !!", :badge_key => "Badge#{problem_type.name}B", :level => 1)
            	end	
        	end
    	end
    end

    # Badge for getting n problem sets blue [LEVEL 4]#
    def self.BadgeNPSB(student, n)
    	@result = Array.new
        student.problem_set_instances.order("id").each do |pset|
            @result = @result.push (pset.num_problems - pset.problem_stats.blue.count) == 0
        end
        result_length = @result.length
        true_count = @result.select {|v| v =="true"}.count
        if true_count == n
        	@has_BadgeNPSD = student.badges.find_by_badge_key("Badge#{n}PSD") 
        	if @has_BadgeNPSD.nil?
        		student.points += 20000
        		student.save
        		student.badges.create(:name => "#{n} problem sets done", :badge_key => "Badge#{n}PSD", :level => 4)
        	end
		end
    end

	# Badge for n questions correct in a row for the first time only [LEVEL 2]#
	def self.BadgeNQCIARFTO(student, n)
		@b = student.answers.order("created_at DESC").limit(n).map(&:correct)
		
		unless @b.blank?
			@a = @b.select{|v| v == true}.count
			result = @b.length - @a
			if result == 0
				@has_BadgeNQCIARFTO = student.badges.find_by_badge_key("Badge#{n}QCIARFTO")
				
				if @has_BadgeNQCIARFTO.nil?
					student.points += 1000
					student.save
                    student.news_feeds.create(:content => "Congrats! You have won a new Badge: #{n} questions correct in a row for the first time only ", :feed_type => "badge", :user_id => student.id)
					student.badges.create(:name => "#{n} questions correct in a row for the first time only", :badge_key => "Badge#{n}QCIARFTO", :level => 2)
				end					
			end
		end
	end

	# Badge for completing a problem set within a day [LEVEL 2]#
	def self.BadgeCAPSWAD(student)
		@result = student.problem_set_instances.includes(&:problem_stats).map(&:stop_green)
		unless @result.blank?
			if @result.select{|v| v == Date.today}.count > 0 == true
				@has_BadgeCAPSWAD = student.badges.find_by_badge_key("BadgeCAPSWAD")
				student.news_feeds.create(:content => "Congrats! You have won a new Badge: Completing a problem set within a day", :feed_type => "badge", :user_id => student.id) if @has_BadgeCAPSWAD.nil?

				if @has_BadgeCAPSWAD.nil?
					student.points += 1000
					student.save
					student.badges.create(:name => "Completing a problem set within a day",	:badge_key => "BadgeCAPSWAD")
				end					
			end
		end	
	end

	# Badge for getting first 10 red questions correct [LEVEL 1]#
	def self.BadgeTRQC(student)
		@result = student.answers.order("created_at DESC").where(:correct => true).count == 10
		unless @result.blank?
			if @result == true
				@has_BadgeTRQC = student.badges.find_by_badge_key("BadgeTRQC")

				student.news_feeds.create(:content => "Congrats! You have won a new Badge: First 10 red questions correct ", :feed_type => "badge", :user_id => student.id) if @has_BadgeTRQC.nil?

				if @has_BadgeTRQC.nil?
					student.points += 100
					student.save
					student.badges.create(:name => "First 10 red questions correct", :badge_key => "BadgeTRQC")
				end					
			end
		end
	end

	# Badge for getting n questions correct in a row for n times [LEVEL 3] #
	def self.BadgeNQCIARFNT(student, n, times)
		a = 0
		b = 0
		student.answers.order("created_at DESC").map(&:correct).each do |correct|
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
    	    		student.badges.create(:name => "#{n} questions correction in a row #{times} times", :badge_key => "Badge#{n}QCIARF#{times}T", :level => 3)
          		end	
          	end
		end
	end
end
