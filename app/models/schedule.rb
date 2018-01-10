require 'date'
class Schedule < ApplicationRecord
  belongs_to :user
  has_many :schedule_each_dates,dependent: :destroy
  has_many :thumbnails,dependent: :destroy, inverse_of: :schedule
  accepts_nested_attributes_for :thumbnails, reject_if: :all_blank, allow_destroy: true
  validates :title, presence: true,length: { maximum: 100 }
  validates :from_date, presence: true, date: true
  validates :to_date, presence: true, date: true
  after_validation :date_cannot_be_in_the_past


  def date_cannot_be_in_the_past
    if errors.messages[:from_date].empty? && errors.messages[:to_date].empty?
      if from_date.strftime('%Y-%m-%d') > to_date.strftime('%Y-%m-%d')
        errors.add(:from_date, "終了日付よりも過去の日付は使用できません")
      end
    end
  end

end
