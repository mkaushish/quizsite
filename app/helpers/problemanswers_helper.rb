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
				ret += radio_button_tag(elt.name, field) + "\n" + label_tag(elt.name, field) + "<br>"
			end
			return ret
		elsif elt.is_a? Dropdown
			return select_tag(elt.name, elt.fields.map { |f| [f.to_s, f.to_s] } )
		elsif elt.is_a? CheckBox
			ret += label_tag elt.name, elt.label + "\n" unless elt.label.nil?
			ret += check_box_tag elt.name
		end
		#		<% if elt.is_a? RadioButton %>
		#			<% elt.fields.each do |field| %>
		#				<%= radio_button_tag elt.name, field %>
		#				<%= label_tag elt.name, field %> <br>
		#			<% end %>
		#		<% elsif elt.is_a? Dropdown %>
		#			<%= select_tag elt.name, elt.fields.map { |f| [f.to_s, f.to_s] } %>
		#		<% elsif elt.is_a? TextField %>
		#			<%= label_tag elt.name, elt.label %> <br>
		#			<%= text_field_tag elt.name %>
		#		<% elsif elt.is_a? CheckBox %>
		#			<%= label_tag elt.name, elt.label %> <br>
		#			<%= check_box_tag elt.name %>
		#		<% end %>
	end
end
