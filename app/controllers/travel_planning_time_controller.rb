class TravelPlanningTimeController < ApplicationController
  before_action :set_schedule_date, only: [:show,:edit, :update, :destroy,:show_spot_roting]
  def show
    #対象スケジュール日付に紐づくスケジュール時間帯別が１軒もない場合は、スケジュール時間帯別を新規作成
    if @schedule_each_date.schedule_each_times.empty?
      @schedule_each_date.schedule_each_times.new(schedule_id: @schedule_each_date.schedule_id, schedule_each_date_id: @schedule_each_date.id, user_id:@schedule_each_date.user_id)
    end
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
  def show_spot_roting
    #今持っているスケジュール日付に存在する時間帯データから場所データを取得
    spotAry = Array[]
    @schedule_each_date.schedule_each_times.each do |schedule_each_time|
      @spot = Spot.find(schedule_each_time.place_id)
      #スポットデータがあれば配列に格納
      if @spot.present?
        spotAry.push(@spot)
      end
    end
    #上記処理でスポットの配列にデータがあれば、GoogleMapに表示するマーカー作成用のハッシュデータを作成
    if !spotAry.empty?
      @hash = Gmaps4rails.build_markers(spotAry) do |spot, marker|
        marker.lat spot.latitude
        marker.lng spot.longitude
        marker.infowindow spot.name
      end
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @hash.to_json }
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
