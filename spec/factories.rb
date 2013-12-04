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

  factory :message do
    subject "Lorem ipsum"
    body "Lorem ipsum"
    user
  end

  factory :scholarship do
    degree "Master"
    field "Math"
    user
    school
    start_date 1995
    end_date 2003
  end

  factory :lesson do
    title "Lorem ipsum"
    content "Lorem ipsum"
    price 50
    user
  end

  factory :category do
    name "Math"
  end

  factory :review do
    content "Lorem ipsum"
    reviewer
    reviewed
    rating 4
  end

  factory :group do
    name "LFNY"
  end

  factory :school do
    name "Ecole Polytechnique"
  end
end