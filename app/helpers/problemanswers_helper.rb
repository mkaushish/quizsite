#require 'tohtml'
include ToHTML

module ProblemanswersHelper
	def render_inputfield(elt)
		raise "render_inputfield can only be called on InputField" unless elt.is_a? InputField
		ret = ""

		if elt.is_a? TextField
			ret += label_tag(elt.name, elt.label) + "\n" unless elt.label.nil?
			ret += text_field_tag elt.name
			return ret
		elsif elt.is_a? RadioButton
			elt.fields.each do |field|
				ret += radio_button_tag(elt.name, field) + "\n" + label_tag(elt.name, field) + " <br>".html_safe
			end
			return ret
		elsif elt.is_a? Dropdown
			return select_tag(elt.name, elt.fields.map { |f| [f.to_s, f.to_s] } )
		elsif elt.is_a? CheckBox
			ret += label_tag elt.name, elt.label + "\n" unless elt.label.nil?
			ret += check_box_tag elt.name
		end
		ret
	end

	def render_soln_field(soln, resp, elt)
		ret = '<div class="field">'
		if elt.is_a? TextField
			ret += label_tag(elt.name, elt.label) + "\n" unless elt.label.nil?
			ret += "<div class=\"correct\">".html_safe
			ret += text_field_tag(elt.name+"soln", nil, 
														:placeholder => soln[elt.name],
														:disabled => true)
			ret += "</div>\n</div class=\"incorrect\">".html_safe
			ret += text_field_tag(elt.name+"resp", nil, 
														:placeholder => resp[elt.name],
														:disabled => true)
			ret += "</div>".html_safe
		elsif elt.is_a? RadioButton
			elt.fields.each do |field|
				checked = false
				if field.to_s == soln[elt.name].to_s
					ret += '<div class="correct">'.html_safe
					checked = true
				elsif field.to_s == resp[elt.name].to_s
					ret += '<div class="incorrect">'.html_safe
					checked = true
				end

				ret += check_box_tag(field, "1", checked, :disabled => true) + "\n" + label_tag(elt.name, field) + " <br>".html_safe

				if field.to_s == soln[elt.name].to_s || field.to_s == resp[elt.name].to_s
					ret += '</div>'.html_safe
				end
			end
		end
		return ret + '</div>'
	end

	# Takes as input the solution hash from problem.solve, and the InputField,
	# and returns the solution associated with said field in string form
	def field_soln(solnhash, field)
		solnhash[ToHTML::rm_prefix(field.name)].to_s
	end
end
