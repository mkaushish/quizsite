require 'factory_girl'

FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  factory :user do
    email
    sequence(:name) { |n| "Abishek #{n}" }
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

  factory :problem_type do
    sequence(:name) { "ProblemType #{n}" }
  end

  factory :quiz_stat do
    user
    problem_type
    remaining 2
  end

  factory :problem_set_problem do
    problem_type
    problem_set
  end

  factory :problem_set do
    sequence(:name) { |n| "Chapter#{n}" }

    factory :full_problem_set do 
      ignore do
        ptypes_count 5
      end

      after(:create) do |problem_set, evaluator|
        FactoryGirl.create_list(:problem_set_problem, evaluator.ptypes_count, problem_set: problem_set)
      end
    end
  end
end
