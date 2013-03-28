module ProblemsHelper
	# renders a tohtml object in a certain directory
	def render_tohtml(locals, obj)
		# $stderr.puts locals.inspect
		path = 'problems'
		if obj.answer_view? && !locals[:partial_dir].nil?
			path = locals[:partial_dir]
		end

		render partial: "#{path}/tohtml/#{obj.partial}", object: obj, locals: locals
	end
end
