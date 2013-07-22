class Coach < User
  	attr_accessor :old_password, :new_password, :confirm_password
	attr_accessible :name, :old_password, :new_password, :confirm_password

  	has_many :relationships, :dependent => :destroy
  	has_many :students, :through => :relationships

  	def change_password(old_pass, new_pass, confirm_pass)
        if self.encrypted_password == encrypt(old_pass)
            p "password_verified"
            if new_pass = confirm_pass
                self.password = new_pass
                self.password_confirmation = confirm_pass
                if self.save
                    p "Sucess"
                end
            else
                p "Hey, your password doesn't match it's confirmation!"
            end
        else
            p "Hey, your Old password doesn't match!"
        end
    end
end
