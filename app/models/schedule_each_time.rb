class ScheduleEachTime < ApplicationRecord
  belongs_to :schedule_each_date
  validates_associated :schedule_each_date
  validates :from_time, presence: true, sche_time: true
  validates :to_time, presence: true
  validates_time :to_time, :after => :from_time
  
  validate :add_error_place_id
  validate :check_number_of_schedule_each_times

  def add_error_place_id
    # place_idが空のときにエラーメッセージを追加する(選択式用にカスタマイズ)
    if place_id.blank?
      errors[:place_id] << "は必ず選択して下さい"
    end
  end

  def check_number_of_schedule_each_times
    # 対象スケジュール日付に紐づく時間帯別データが９件目の時エラー(地図でのスポット表示の最大数に合わせる)
   if schedule_each_date && schedule_each_date.schedule_each_times.count > 7
    errors[:schedule_each_times] << "はこれ以上登録できません"
   end
  end
end
