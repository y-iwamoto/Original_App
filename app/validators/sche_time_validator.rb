class ScheTimeValidator < ActiveModel::EachValidator
  private def validate_each(record, attribute, value)
    #今回対象としているスケジュールの日付内で、登録または更新対象のスケジュール時間帯別以外のデータを取得
    @schedule_each_times = ScheduleEachTime.where(schedule_id: record['schedule_id'],schedule_each_date_id: record['schedule_each_date_id'],user_id: record['user_id']).where.not(id: record['id']).order(:from_time)
    #登録・更新対象のスケジュール時刻と周辺スケジュール時刻不整合チェック
    @schedule_each_times.each do |schedule_each_times|
      #今回修正対象のto_timeが既存のデータにあるfrom_time以上になるレコードをチェック対象とする
      if record['to_time'].strftime("%H:%M") >= schedule_each_times.from_time.strftime("%H:%M")
        #今回修正レコードのfrom_timeが比較対象のto_timeより小さければ、不整合でエラー
        if record['from_time'].strftime("%H:%M") < schedule_each_times.to_time.strftime("%H:%M")
          record.errors.add(attribute, "を、対象スケジュールの前のスケジュール滞在終了時刻よりも以降の時刻を入力してください。")
        end
      end
    end
  end
end
