class TravelPlanningTimeController < ApplicationController
  before_action :set_schedule_date, only: [:show,:edit, :update, :destroy]
  def show
    getSpotAll
  end

  def update
    if @schedule_each_date.update(schedule_date_params)
      flash[:success] = "スケジュールを更新しました"
      redirect_to travel_planning_time_path
    else
      getSpotAll
      render :show
    end
  end

  private
  #マスタテーブル該当データを表示させるため、場所名をセレクトボックスで全件入れて準備
  def getSpotAll
    @spots = Spot.all.pluck(:name, :id)
    @spots.unshift(["選択してください。", ""])
  end
  #対象のスケジュール日付とその日付に紐付く時間帯データも合わせて取得
  def set_schedule_date
      @schedule_each_date = ScheduleEachDate.includes(:schedule_each_times).order("schedule_each_times.from_time,schedule_each_times.to_time").find(params[:id])
  end
  def schedule_date_params
       params.require(:schedule_each_date).permit(:id,:user_id,:schedule_id, schedule_each_times_attributes: [:id,:from_time,:to_time,:place_id,:user_id,:schedule_id,:memo,:_destroy])
  end
end
