FactoryGirl.define do
  factory :user do
    sequence(:first_name)  { |n| "FirstName #{n}" }
    sequence(:last_name)  { |n| "LastName #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end

    factory :reviewer do
    end

    factory :reviewed do
    end
  end

  factory :micropost do
    content "Lorem ipsum"
    user
  end

  factory :review do
    content "Lorem ipsum"
    reviewer
    reviewed
  end

  factory :group do
    name "LFNY"
  end
end