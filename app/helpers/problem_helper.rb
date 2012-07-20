module ProblemHelper
  def exp_id(index_s)
    "sp_#{ index_s.gsub(/:/, "_") }"
  end

  def increment_index(index, n = 1)
    ret = index.split(":")
    ret[0] = ret[0].to_i + n
    ret.join(":")
  end

  # NOTE this needs @orig_prob to have been set in the controller...
  # TODO fix this issue
  def render_subprob(subprob, index)
    div_h   = "<div id=\"#{ exp_id(index) }\"><div class=problem>"
    ptext   = render( :partial => 'problem/problem', 
                      :object => subprob, 
                      :locals => {:partialdir => 'problem'}
                    ) 
    div_e   = "</div></div>";

    if subprob.is_a?(QuestionWithExplanation)
      expand = link_to( "Wait, how do I do that?", 
                        problem_expand_path(:id => @orig_prob.id, :index => index), 
                        :method => :post, 
                        :remote => true,
                        :class => "btn btn-success"
                      )
      return (div_h + ptext + div_e + expand).html_safe
    else
      return (div_h + ptext + div_e).html_safe
    end
  end

  def len_to_css_width(len)
    return "width:#{len * 8}px;"
  end
end
