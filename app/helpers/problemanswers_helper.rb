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
	end

	# Takes as input the solution hash from problem.solve, and the InputField,
	# and returns the solution associated with said field in string form
	def field_soln(solnhash, field)
		solnhash[ToHTML::rm_prefix(field.name)].to_s
	end
end
