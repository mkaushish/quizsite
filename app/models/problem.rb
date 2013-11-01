# == Schema Information
#
# Table name: problems
#
#  id         :integer         not null, primary key
#  problem    :string
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#

require 'questionbase'

class Problem < ActiveRecord::Base
    include ApplicationHelper
    has_many :answers
    has_one :problem_type, :through => :problem_generator
    has_one :quiz_problem
    
    belongs_to :problem_generator
    belongs_to :user
    
    attr_writer :problem # so these can be accessible variables in the constructor
    attr_accessible :problem, :user_id, :problem_generator_id, :body

    before_save :dump_problem

    auto_html_for :body do
        html_escape
        image
        youtube(:width => 400, :height => 250)
        link :target => "_blank", :rel => "nofollow"
        simple_format
    end

    def dump_problem
        self.serialized_problem = m_pack problem
    end

    def problem
        return nil if self.serialized_problem.nil? && @problem.nil?
        @problem ||= m_unpack self.serialized_problem
    end

    def question_base
        return problem
    end

    def ptype
        @ptype ||= problem.class
    end

    # should be passed the params variable returned by the HTML form
    def correct?(params)
        problem.correct?(params)
    end

    def solve
        problem.prefix_solve
    end

    def get_response(params)
        @response ||= params.select { |k, v| k =~ /^qbans_/ }
    end

    def get_packed_response(params)
        m_pack(get_response(params))
    end

    def to_s
        problem.type
    end

    def text
        problem.text
    end

    def custom?
        (problem.class < CustomProblem) && true # for some reason that was giving nil for a while
    end
end