module User
  def init(user)
  end
end

Factory.define :teacher do |user|
  User::init(user)
end

Factory.define :student do |user|
  User::init(user)
end

Factory.define :problem do |p|
end

Factory.define :problemanswer do |pa|
end
