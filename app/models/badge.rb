class Badge < ActiveRecord::Base
  	# attr_accessible :title, :body
  	belongs_to :student

	# Badge for all problem sets done #
	def self.BadgeAPSD(student)
        @result = Array.new
        student.problem_set_instances.each do |pset|
            @result = @result.push (pset.problem_stats.count - pset.problem_stats.blue.count) == 0
        end
        result_length = @result.length
        true_count = @result.select {|v| v =="true"}.count
        if (result_length- true_count) == 0
        	@has_BadgeAPSD = student.badges.find_by_badge_key("BadgeAPSD") || student.badges.create(:name => "All problem sets done",
															:badge_key => "BadgeAPSD")
		end
    end

	# Badge for n questions correct in a row for the first time only #
	def self.BadgeFNQCIARFTO(student)
		@b = student.answers.order("created_at DESC").limit(5).map(&:correct)
		
		unless @b.blank?
			@a = @b.select{|v| v == true}.count
			result = @b.length - @a
			debugger
			if result == 0
				@has_BadgeFNQCIARFTO = student.badges.find_by_badge_key("BadgeFNQCIARFTO")
				@has_BadgeFNQCIARFTO = student.badges.create(:name => "N questions correct in a row for the first time only",
																:badge_key => "BadgeFNQCIARFTO") if @has_BadgeFNQCIARFTO.nil?
			end
		end
	end

	# Badge for completing a problem set within a day #
	def self.BadgeCAPSWAD(student)
		@result = student.problem_set_instances.includes(&:problem_stats).map(&:stop_green)
		unless @result.blank?
			if @result.select{|v| v == Date.today}.count > 0 == true
				@has_BadgeCAPSWAD = student.badges.find_by_badge_key("BadgeCAPSWAD")
				@has_BadgeCAPSWAD = student.badges.create(:name => "Completing a problem set within a day",
																:badge_key => "BadgeCAPSWAD") if @has_BadgeCAPSWAD.nil?
			end
		end	
	end

	# Badge for getting first 10 red questions correct #
	def self.BadgeTRQC(student)
		@result = student.answers.order("created_at DESC").where(:correct => true).count == 10
		unless @result.blank?
			if @result == true
				@has_BadgeTRQC = student.badges.find_by_badge_key("BadgeTRQC")
				@has_BadgeTRQC ||= student.badges.create(:name => "First 10 red questions correct",
																:badge_key => "BadgeTRQC") if @has_BadgeTRQC.nil?
			end
		end
	end
end
