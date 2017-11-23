class ScheduleEachDate < ApplicationRecord
  belongs_to :schedule
  validates :sche_date, presence: true

end
