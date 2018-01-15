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
  factory :schedule_many_create ,class: Schedule do
    user_id 1
    from_date "2017-12-10"
    to_date "2017-12-31"
    title { FactoryGirl.generate(:titles) }
    memo "memo"
  end
  sequence :titles do |n|
  "test#{n}"
  end
  factory :schedule_many_dates_create ,class: Schedule do
    user_id 1
    from_date  { FactoryGirl.generate(:from_dates) }
    to_date "2017-12-31"
    title "title"
    memo "memo"
  end
  sequence :from_dates do |n|
    "2017-12-#{n}"
  end

  factory :schedule_with_each_date ,class: Schedule do
    user_id 1
    from_date "2017-12-10"
    to_date "2017-12-10"
    title "title"
    memo "memo"
    after(:create) do |schedule_with_each_date|
      1.times { create(:schedule_each_date, schedule_id: schedule_with_each_date.id) }
    end
  end
  factory :schedule_each_date do
    user_id 1
    schedule_id 1
    sche_date '2017-12-10'
  end
end
