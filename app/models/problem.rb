# == Schema Information
#
# Table name: problems
#
#  id         :integer         not null, primary key
#  problem    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Problem < ActiveRecord::Base
  has_many :problemanswers

  attr_accessible :problem

  before_save :dump_problem

  def after_find
    load_problem
  end

  def dump_problem
    self.problem = ActiveRecord::Base.connection.escape_bytea(Marshal.dump(@prob))
  end

  def load_problem
    @prob = Marshal.load(ActiveRecord::Base.connection.unescape_bytea(self.problem))
  end

  def unpack
    load_problem
  end

  # should be passed the params variable returned by the HTML form
  def correct?(params)
    @prob.correct?(params)
  end

  def solve
    @prob.prefix_solve
  end

  def get_response(params)
    soln = solve
    @response = {}
    soln.each_key { |key| @response[key] = params[key] }
    @response
  end

  def get_packed_response(params)
    Marshal.dump(get_response(params))
  end

  def to_s
    self.prob.type
  end

  def prob
    @prob ||= load_problem
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
