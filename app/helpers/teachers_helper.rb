module TeachersHelper
  def select_class_text
    return @classroom.name unless @classroom.nil?
    "Class Stats"
  end

  def classrooms
    if current_user.email == "t.homasramfjord@gmail.com" || current_user.email == "m.adhavkaushish@gmail.com"
      @classrooms ||= Classroom.all
    else
      @classrooms ||= current_user.classrooms
    end
  end
end
