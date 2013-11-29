class CreateStudents < ActiveRecord::Migration
  	def change
    	change_table :users do |t|
      		t.string :type
    	end
  	end
end
