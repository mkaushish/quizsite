class Student < User
  
  attr_accessor :old_password, :new_password, :confirm_password
  attr_accessible :old_password, :new_password, :confirm_password
  
  has_many :classroom_assignments
  has_many :classrooms, :through => :classroom_assignments
  has_many :teachers, :through => :classrooms
  # after_create :assign_class #TODO broken

  def problem_history(*ptypes)
    ptypes_list = ptypes
    if ptypes[0].is_a? Array
      ptypes_list = ptypes[0]
    end

    answers.where(:problem_type_id => ptypes_list)
           .order("created_at DESC")
           .includes(:problem)
  end

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

  def is_all_problem_sets_done?(pset_instances)
    @check = Array.new
    pset_instances.each do |pset|
      @check = @check.push (pset.problem_stats.count - pset.problem_stats.blue.count) == 0
    end
    total = @check.length
    true_count = @check.select {|v| v =="true"}.count
    return (total - true_count) == 0
  end

  private

  def assign_class
    if !@class
      @class = Classroom.where(:name => "SmarterGrades 6").first
    end
    @class.assign!(self)
  end


end
