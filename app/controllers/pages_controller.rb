require 'c1'
class PagesController < ApplicationController
    def home
        # $stderr.puts "!@#" * 30 + "\n#{current_user.class}"
        case current_user.class.to_s
            when "Student"
                deny_access_user_not_confirmed && return unless current_user.confirmed == true
                redirect_to studenthome_path
                
            when "Teacher"
                deny_access_user_not_confirmed && return unless current_user.confirmed == true
                redirect_to teacherhome_path

            when "Coach"
                deny_access_user_not_confirmed && return unless current_user.confirmed == true
                redirect_to coachhome_path
        else 
            @nav_selected = "home"
            @problem_types = ProblemType.limit(5)
        end
        
        if defined? params[:ptypes]
            case params[:ptypes]
                when 'all'
                    @problem_types = ProblemType.all
                    respond_to { |format| format.js}
            end
        end
    end

    def what_is_it
    end

  def graph
    @title = "Graph"
    @nav_selected = "features"
  end
  def mathematicians
    @title = "Mathematicians"
  end

  def datagr
    @title = "Data Graph"
    @nav_selected = "features"
  end

    def graph
        @title = "Graph"
        @nav_selected = "features"
    end

    def datagr
        @title = "Data Graph"
        @nav_selected = "features"
    end

    def notepad
        @title = "Notepad"
        @nav_selected = "features"
    end

    def draw
        @title = "Draw"
        @nav_selected = "features"
        @problem = Problem.new(:ptype => Geo::BisectLine)
        @problem.save
    end

    def check_drawing
        @lastproblem = Problem.find(params["problem_id"])
        @correct = @lastproblem.correct?(params);
        if @correct
            @problem = Problem.new(:ptype => Geo::BisectLine)
            @problem.save
            @problem.text.each { |p| @newstartshapes = p.encodedStartShapes if p.is_a?(GeometryField) }
            $stderr.puts "NEWSTARTSHAPES SET TO #{@newstartshapes}"
        end
        respond_to { |format| format.js }
    end

    # GET access_denied
    def access_denied
    end
end
