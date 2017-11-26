class ScheduleEachDate < ApplicationRecord
  belongs_to :schedule
  has_many :schedule_each_times, dependent: :destroy, inverse_of: :schedule_each_date
  accepts_nested_attributes_for :schedule_each_times, reject_if: :all_blank, allow_destroy: true
  validates :sche_date, presence: true

end
