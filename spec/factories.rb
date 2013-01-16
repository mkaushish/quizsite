require 'factory_girl'

FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  sequence :name do |n|
    "Abishek #{n}"
  end

  factory :user do
    email
    name
    password "mypassword"
    password_confirmation "mypassword"
    after(:build) { |user| user.class.skip_callback(:create, :after, :add_default_problem_sets) }

    factory :with_default_problem_sets do
      after(:create) { |user| user.send(:add_default_problem_sets) }
    end
  end

  factory :student, :parent => :user, :class => 'Student' do
    points 10
  end

  factory :teacher, :parent => :user, :class => 'Teacher' do
  end

  sequence :problem_name do |n|
    "How to make #{n} Math Problem#{n > 1 ? "s":""}"
  end

  factory :problem_type do
    problem_name
  end

  factory :quiz_stat do
    user
    problem_type
    remaining 2
  end
end
