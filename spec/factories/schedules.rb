FactoryGirl.define do
  factory :schedule do
    user
    from_date "2017-12-10"
    to_date "2017-12-31"
    title "title"
    memo "memo"
  end
  factory :user do
    email "test@example.com"
    password "test123"
    username "test"
  end
  factory :schedule_feature ,class: Schedule do
    user_id 1
    from_date "2017-12-10"
    to_date "2017-12-31"
    title "title"
    memo "memo"
  end
end
