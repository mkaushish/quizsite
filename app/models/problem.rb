class Problem < ActiveRecord::Base
	has_many :problemanswers

	attr_accessor :prob
	attr_accessible :problem

	before_save :dump_problem

	def after_find
		@prob = Marshal.load self.problem
	end

	def dump_problem
		self.problem = Marshal.dump @prob
	end

	def load_problem
		@prob = Marshal.load self.problem
	end

	def unpack
		load_problem
	end

	# should be passed the params variable returned by the HTML form
	def correct?(params)
		@prob.correct?(params)
	end

	def my_initialize(type)
		unless type.is_a? Class
			raise "Problem's initialize must be passed a class"
		end

		@prob = type.new
		unless @prob.is_a? QuestionBase
			raise "Problem's initialize must be passed a class which extends QuestionBase"
		end
	end

	def response_from_params(params)
		params.each_key do |key|
			answer = params[key]
			cur = get_inst(key)

			answer = answer.to_i cur.is_a? Fixnum
			answer = answer.to_f cur.is_a? Float

			set_inst key, answer
		end
	end

	def set_response
		return nil if @prob.nil?
		format = @prob.ans_format
		@response_fields = []

		#TODO change me - this is a horrible system
		if (format.is_a? Fixnum) || (format.is_a? Float)
			add_response_field(:ans)
			@ans = format
		elsif format.is_a? Array
			for i in 0...format.length do
				add_response_field "ans#{i}".to_sym
				set_inst "ans#{i}", format[i]
			end
		else
			$stderr.puts "REJECTED MOTHERFUCKER! format = #{format}"
		end
		$stderr.puts "\n\n#{"*"*20}\nHEY I'm GETTING CALLED with a #{@prob.class}\nresponse_fields: #{response_fields}, format = #{@prob.ans_format}\n#{"*"*20}\n"
	end

	def text
		@prob.text
	end

	def response_fields
		@response_fields
	end

	# def correct?
	#	format = @prob.ans_format
	#	if format.is_a?(Fixnum) || format.is_a?(Float)
	#		return @prob.correct? @ans
	#	elsif format.is_a? Array
	#		# I know this could be done with map, but order must be ensured
	#		results = Array.new(@response_fields.length)
	#		@response_fields.each_with_index do |field, i|
	#			results[i] = instance_variable_get "@#{field}".to_sym
	#		end
	#		return @prob.correct? results
	#	else
	#		raise "Only Arrays and Fixnums implemented currently"
	#	end
	#end

	private

	def set_inst(name, val)
		instance_variable_set "@#{name}", val
	end

	def get_inst(name)
		instance_variable_get "@#{name}"
	end

	def add_response_field(vname)
		@response_fields ||= []
		define_singleton_method vname do
				instance_variable_get "@#{vname}"
		end
		define_singleton_method "#{vname}=" do |arg|
				instance_variable_set "@#{vname}", arg
		end
		@response_fields << vname
	end
end
