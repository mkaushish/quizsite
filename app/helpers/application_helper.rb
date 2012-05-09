require 'c1'
require 'c2'
require 'c3'
require 'c6'
require 'c7'
require 'c8'
require 'physics'
require 'geo'
# require 'c10'
# require 'c12'
require 'crqu'


module ApplicationHelper

  def title
    return "SmarterGrades" if @title.nil?
    return "#{@title} | SmarterGrades"
  end
  def jsonload
    return "" if @jsonload.nil?
    return "onload=#{@jsonload}"
  end
  def container_height_style
    return "" if @container_height.nil?
    return "style=height:#{@container_height}px;"
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
    @htmlobj_partial ||= 'problem/htmlobj'
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
    ActiveSupport::Base64.encode64(Marshal.dump(obj))
  end
  def m_unpack(marshobj)
    Marshal.load(ActiveSupport::Base64.decode64(marshobj))
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
  def get_smartscore(ptype)
    smartscore = "?"
    if ptype.is_a?(Quiz)
      smartscore = ptype.smartScore
    elsif ptype < QuestionBase
      smartscore = current_user.smartScore(ptype)
    end

    color_class = smartscore_class(smartscore)

    return "<div class=\"smartscore #{color_class}\">#{smartscore}</div>".html_safe
  end

  # Chapter stuff
  @@all_chapters = [CricketQuestions, Chapter1, Chapter2, Chapter3, Chapter6, Chapter7, Chapter8, Geo, Physics]
  @@all_probs = @@all_chapters.map { |chap| chap::PROBLEMS }.flatten
  def all_probs
    @@all_probs
  end
  def all_chapters
    @@all_chapters
  end
end
