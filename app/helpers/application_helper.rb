require 'grade6'

module ApplicationHelper

  def title
    return "SG - SmarterGrades"
    return "SG - #{@title}"
  end

  def fastnav?
    !@fastnav.nil?
  end

  def selected?(s)
    return "active" if @nav_selected == s
    return ""
  end

  def adderror(string)
    if flash[:errors].nil?
      flash[:errors] = [ string ]
    else
      flash[:errors] << string
    end
  end

  def geterrors
    flash[:errors] ||= []
    flash[:errors]
  end

  def add_multitext_field_link(qb_name, link_name = "+")
    # data-partial same as in _multihtmlobj.html.erb
    link_to link_name, '#',
      :template => text_field_tag("#{qb_name}__num_", nil, :class => 'mt_field').gsub(/"/,"'").html_safe,
      :class => "add_mt_field"
    #, "data-partial" => text_field_tag("#{qb_name}__num_", nil, :class => 'mt_field'),
  end

  def del_multitext_field_link(link_name = "-")
    link_to link_name, "#", :class => "del_mt_field"
  end

  def htmlobj_partial
    @htmlobj_partial ||= 'problems/htmlobj'
  end

  def htmlobj_partial=(partial)
    @htmlobj_partial = partial
  end

  def htmlobj_locals
    @htmlobj_locals ||= {}
  end

  def htmlobj_locals=(locals)
    @htmlobj_locals = locals
  end

  def m_pack(obj)
    Base64.encode64(Marshal.dump(obj))
  end

  def m_unpack(marshobj)
    Marshal.load(Base64.decode64(marshobj))
  end

  def smartscore_class(smartscore)
    return "smartscore_unknown" if smartscore == "?"
    p = smartscore.to_i
    return "smartscore_95" if p >= 95
    return "smartscore_90" if p >= 90
    return "smartscore_80" if p >= 80
    return "smartscore_70" if p >= 70
    return "smartscore_60" if p >= 60
    return "smartscore_35" if p >= 35
    return "smartscore_0"  if p >= 0
    return "smartscore_unknown"
  end

  # Gets the html for a smartscore
  # ptype can be a Quiz object or a subclass of QuestionBase
  def get_smartscore(stat)
    smartscore = stat.smart_score
    color_class = smartscore_class(smartscore)

    return "<div class=\"smartscore\" style='float:left;'>#{smartscore}</div>".html_safe
  end

  # Chapter stuff
  def all_probs
    CHAPTERS.map { |chap| chap::PROBLEMS }.flatten
  end

  def all_chapters
    CHAPTERS
  end

  def nav_elts_path
    return "students/nav_elts" if current_user.is_a? Student
    return "teachers/nav_elts" if current_user.is_a? Teacher
    return "coaches/nav_elts" if current_user.is_a? Coach
    "shared/default_nav_elts"
  end

  #
  # gets the first half of an array for a double column interface
  # n is the number of column elements that fit the screen
  #
  def first_half(arr, n)
    if arr.length >= n * 2
      arr[0..(arr.length / 2)]
    elsif arr.length >= n + 3
      arr[0...n]
    elsif arr.length >= n
      arr[0...(arr.length - 3)]
    else
      arr 
    end
  end

  def second_half(arr, n)
    arr - first_half(arr, n)
  end

  def putd(date)
    date.strftime "%e %B, %Y"
  end

  # f is the FormBuilder
  # attribute is the model attribute
  # field_method is the method of f used to create the form
  # field_options are the options given to that method
  def render_field_block(f, klass, attribute, field_method, field_options)
    render :partial => 'shared/form_field',
           :locals => {f: f, klass: klass, attr: attribute, type: field_method, opts: field_options}
  end

  def acquired_points
    "Points you acquired"
  end

  def percentage(value,total)
    ((value*100)/total)
  end
  
  def date_of_last(day,date)
    newdate  = Date.parse(day)
    delta = newdate > date.to_date ? 0 : 7
    newdate + delta - 7
  end

  def event_time_format(time)
      now = Time.now
      if now - time > 7.days
        l(time, :format => :short)
      else
        distance_of_time_in_words(time, now, true) + ' ago'
      end
  end

  def total_correct_wrong_answers(student, start_time, end_time)
    student.total_correct_wrong_answers(start_time, end_time)
  end

  def total_correct_wrong_problem_set_instance_answers(problem_set_instance)
    problem_set_instance.total_correct_wrong_problem_set_instance_answers
  end

  def total_correct_wrong_problem_type_answers(problem_type)
    problem_type.total_correct_wrong_problem_type_answers
  end

  def answers_correct(student)
    student.answers_correct
  end
  
  def answers_correct_problem_type(student, problem_type)
    student.answers_correct_problem_type(problem_type)
  end

  def problem_stats_correct_and_total(student, problem_type)
    student.problem_stats_correct_and_total(problem_type)
  end

  def problem_set_instances_problem_set(student, problem_set)
    student.problem_set_instances_problem_set(problem_set)
  end

  def problem_type_answers_correct(problem_type)
    problem_type.answers_correct
  end

  def problem_type_student_answers_correct(problem_type, student)
    problem_type.student_answers_correct(student)
  end
end