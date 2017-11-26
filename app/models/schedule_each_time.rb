class ScheduleEachTime < ApplicationRecord
  belongs_to :schedule_each_date
  validates_associated :schedule_each_date
  validates :from_time, presence: true, sche_time: true
  validates :to_time, presence: true
  validates_time :to_time, :after => :from_time
end
