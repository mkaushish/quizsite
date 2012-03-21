require 'c1'
require 'c2'
require 'c3'
require 'c6'
require 'c7'

module ApplicationHelper
  def title
    return "Smarter Grades" if @title.nil?
    return "#{@title} | Smarter Grades"
  end
  def jsonload
    return "" if @jsonload.nil?
    return @jsonload
  end
  def container_height_style
    return "" if @container_height.nil?
    return "style=height:#{@container_height}px;"
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

  def pscore_class(pscore)
    p = pscore.to_i
    return "pscore_95" if p >= 95
    return "pscore_90" if p >= 90
    return "pscore_80" if p >= 80
    return "pscore_70" if p >= 70
    return "pscore_60" if p >= 60
    return "pscore_35" if p >= 35
    return "pscore_0"
  end
end
