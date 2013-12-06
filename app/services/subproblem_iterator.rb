class SubproblemIterator
	# problem should be a Problem from the database, not a question base
	# index should be the index string of either following form
	# => sp_0_1
	# => 0_1
	def initialize(problem, index)
		@root = problem.problem
		set_cur_i id_to_i(index)
	end

	def cur_a
		@cur_i
	end

	def cur_i
		i_to_id @cur_i
	end

	def to_id
		@cur_i.join("_")
	end

	def cur
		@cur ||= get_sp(@cur_i)
	end

	def prev_i
		i_to_id @prev_i
	end

	def prev
		@prev ||= get_sp(@prev_i)
	end

	def increment
		while nested? && last?
			set_cur_i @cur_i.pop
		end

		if !nested? && last?
			set_cur_i []
		else
			@cur_i[-1] = @cur_i.last + 1
			set_cur_i @cur_i
		end
		$stderr.puts("INCREMENTED I: #{@cur_i.inspect}, #{@prev_i.inspect}")
	end

	def last_correct?(params)
		cur.correct? params
	end

	def last?
		tmp = @cur_i.clone
		tmp.pop
		parent = get_sp(tmp)
		@cur_i.last >= parent.explanation.length - 1
	end

	def nested?
		@cur_i.length > 1
	end

	private

		def set_cur_i(i)
			@cur_i = i
			@prev_i = decrement_i(@cur_i) unless i.last == 0
			@cur = nil
			@prev = nil
		end

		def get_sp(i)
			$stderr.puts "CALLING GET_SP FOR INDEX #{i.inspect}"
			r_get_sp = lambda do |i, cur|
				return cur if i == []

				explanation = cur.explanation
				cur_i = i.shift
				nxt = explanation[cur_i]

				r_get_sp.call(i, nxt)
			end

			r_get_sp.call(i.clone, @root)
		end

		def id_to_i(id)
			id.sub(/sp_/, "").split("_").map(&:to_i)
		end

		def i_to_id(i)
			"sp_#{i.join "_"}"
		end

		def decrement_i(i)
			ret = i.clone
			last = ret.pop
			if last > 0
				return ret.push (last-1)
			else
				return ret
			end
		end
end