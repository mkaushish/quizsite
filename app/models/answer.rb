# == Schema Information
#
# Table name: answers
#    boolean  "correct"
#    integer  "problem_id"
#    binary   "response"
#    datetime "created_at"
#    datetime "updated_at"
#    integer  "user_id"
#    float    "time_taken"
#    string   "notepad"
#    integer  "problem_generator_id" # I think this is no longer used TODO
#    integer  "session_id"
#    string   "session_type"
#    integer  "problem_type_id"
#    
class Answer < ActiveRecord::Base
    include ApplicationHelper

    has_many :comments, :order => "created_at DESC",
                        :dependent => :destroy

    belongs_to :problem
    belongs_to :user

    belongs_to :problem_generator # TODO remove?
    belongs_to :problem_type

    belongs_to :session, :polymorphic => true

     attr_writer :params
    # note, session refers to a practice session not a cookie
    attr_accessible :params, :session, :problem, :problem_id, :correct, :problem_type_id, :response, :problem_generator_id

    validates :problem_id, :presence => true
    validates :response,   :presence => true

    before_validation :parse_params
    before_save       :dump_response

    def parse_params
        if !@params.nil? && self.problem.nil?
            self.problem    = Problem.find @params["problem_id"]
            self.time_taken = @params["time_taken"]
            self.correct    = problem.correct? @params
            self.response   = problem.get_packed_response @params
            self.notepad    = (@params["npstr"].empty? if @params["npstr"]) ? nil : @params["npstr"]
            self.problem_generator = problem.problem_generator
            self.problem_type_id   = problem.problem_generator.problem_type_id
        end
        self
    end
  
    def response_hash
        @response_hash ||= m_unpack(self.response)
    end

    def dump_response
        unless @response_hash.nil? || self.response != nil
            self.response = m_pack(@response_hash)
        end
    end

    def problem_stat
        ProblemStat.where(:user_id => user_id, :problem_type_id => problem_type_id).first
    end
end