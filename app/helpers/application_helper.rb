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
  
  def badgekey

    @badges = ["BadgeAPSD", "BadgeCAPSWAD","BadgeTRQC"]
    @badges_name = ["All Problem Sets Blue", "Problem Set Completed Within a Day", "10 red Questions Correct"]
    @badge_level = [5, 2, 2]
    for i in 0...2
      @badges << "Badge#{(i+1)*5}PSB"
      @badges_name << "#{(i+1)*5} Problem Sets Blue"
      @badge_level << 4
    end
    for i in 0...2
      @badges << "Badge#{(i+1)*5}QCIARFTO"
      @badges_name << "#{(i+1)*5} Questions Correct in a Row for the First Time"
      @badge_level << 2
    end
    for i in 0...2
      for j in 0...3
        @badges << "Badge#{(i+1)*5}QCIARF#{(j+1)*5}TO"
        @badges_name << "#{(i+1)*5} Questions Correct in a Row for the #{(j+1)*5} Time"
        @badge_level << 3
      end
    end
    current_user.problem_sets.each do |pset|
      @badges.push("Badge" + pset.name + "B")
      @badges_name << "#{pset.name} Problem Set Blue"
      @badge_level << 3
    end
    current_user.problem_sets.each do |pset|
      pset.problem_types.each do |ptype|
        @badges.push("Badge" + ptype.name + "B")
        @badges_name << "#{ptype.name} Problem Type Blue"
        @badge_level << 1
      end
    end
    return [@badges, @badges_name, @badge_level]
  end 

  def date_of_last(day,date)
    newdate  = Date.parse(day)
    delta = newdate > date.to_date ? 0 : 7
    newdate + delta - 7
  end

  def correct_answers(student, problem_type)
    student.correct_answers(problem_type)
  end

  def problem_stats_correct_and_total(student, problem_type)
    student.problem_stats_correct_and_total(problem_type)
  end
end