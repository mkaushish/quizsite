class CreateUsers < ActiveRecord::Migration
  	def change
    	create_table :users do |t|
			t.string 	:name
			t.string 	:email, unique: true, null: false
			t.string 	:encrypted_password
			t.string 	:salt
			t.binary 	:pscores
			t.string 	:confirmation_code
			t.boolean 	:confirmed, :default => false
			t.integer 	:points, :default => 0
			t.string 	:first_name
			t.string	:last_name
			t.string	:gender
			t.string 	:uid
			t.string	:profile_link
			t.string	:picture_link
			t.string	:provider
			t.string 	:image
			t.string	:confirmation_token

    		t.timestamps
    	end
    	add_index :users, :email, :unique => true
  	end
end