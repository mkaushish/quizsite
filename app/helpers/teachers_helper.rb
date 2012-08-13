module TeachersHelper
  def select_class_text
    return @classroom.name unless @classroom.nil?
    "Class Stats"
  end
end
