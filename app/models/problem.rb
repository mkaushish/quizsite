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
    attr_accessible :problem, :user_id, :problem_generator_id, :body, :explanation

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

    def self.import(file)
        spreadsheet = open_spreadsheet(file)
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
            row = Hash[[header, spreadsheet.row(i)].transpose]
            problem = Problem.new
            debugger
            problem.attributes = row.to_hash.slice(*accessible_attributes)
            # problem.save!
        end
    end
    
    def self.open_spreadsheet(file)
        case File.extname(file.original_filename)
            when ".csv"     then Roo::CSV.new(file.path)
            when ".xls"     then Roo::Excel.new(file.path)
            when ".xlsx"    then Roo::Excelx.new(file.path)
            when ".ods"     then Roo::OpenOffice.new(file.path)
            
            else raise "Unknown file type: #{file.original_filename}"
        end
    end
end