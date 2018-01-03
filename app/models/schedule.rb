require 'date'
class Schedule < ApplicationRecord
  belongs_to :user
  has_many :schedule_each_dates,dependent: :destroy
  has_many :thumbnails,dependent: :destroy, inverse_of: :schedule
  accepts_nested_attributes_for :thumbnails, reject_if: :all_blank, allow_destroy: true
  validates :title, presence: true,length: { maximum: 100 }
  validates :from_date, presence: true, date: true
  validates :to_date, presence: true, date: true

end
