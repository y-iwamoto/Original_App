require 'date'
class Schedule < ApplicationRecord
  has_many :schedule_each_dates
  validates :title, presence: true,length: { maximum: 100 }
  validates :from_date, presence: true, date: true
  validates :to_date, presence: true, date: true

end
