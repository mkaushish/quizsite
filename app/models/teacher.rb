class Teacher < User
  has_many :homeworks, :foreign_key => 'user_id'
  has_many :classroom_teachers, :dependent => :destroy
  has_many :classrooms, :through => :classroom_teachers
  has_many :problem_sets, :foreign_key => 'user_id'

  attr_accessor :old_password, :new_password, :confirm_password
  attr_accessible :old_password, :new_password, :confirm_password

  # we can't do below, afaik, but we don't want to anyway - every time we want a group of
  # students for a teacher, we will want the students associated with a certain classroom,
  # and if not we can just get the students manually
  # has_many :students, :through => :classrooms

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