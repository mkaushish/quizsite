class Problemanswer < ActiveRecord::Base
	belongs_to :problem

	before_save :dump_response
	
	def dump_response
		unless @response_hash.nil? || self.response != nil
			self.response = Marshal.dump @response_hash
		end
	end

	def response_hash
		@response_hash ||= Marshal.load self.response
		@response_hash
	end
end
