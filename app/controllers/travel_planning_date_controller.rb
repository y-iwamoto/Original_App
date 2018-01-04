require "date"
class TravelPlanningDateController < ApplicationController
  def index
    #画像アップロードでエラーがでてきたときや画面更新した時のためにセッションに格納
    session[:schedule_id] = params[:schedule_id]
    @schedule_id = session[:schedule_id]
    @schedule_each_date = ScheduleEachDate.where(schedule_id: @schedule_id).order(:created_at).first
    gon.firstDay  = @schedule_each_date.sche_date
    respond_to do |format|
      format.html
    end
  end
  def upload_prepare
    @schedule = Schedule.includes(:thumbnails).order("thumbnails.created_at").find(session[:schedule_id])
    #画像が0件の時に作成
    if @schedule.thumbnails.empty?
      @schedule.thumbnails.new(schedule_id: @schedule.id, user_id:@schedule.user_id)
    end
  end
  def upload
    #1件でも登録しようとした場合や既存データがあり全て削除した場合
    if params[:schedule] != nil
      @schedule = Schedule.find(params[:schedule][:thumbnails_attributes]["0"]["schedule_id"])
      if @schedule.update(thumbnail_params)
        flash[:success] = "画像を登録しました"
        redirect_to travel_planning_date_upload_prepare_path
      else
        flash[:error] = "画像の登録に失敗しました"
        render :upload_prepare
      end
    #初めて登録する際に、フォームを全て削除した状態で登録ボタンを押された場合
    else
      @schedule = Schedule.find(session[:schedule_id])
      flash[:error] = "画像の登録に失敗しました"
      redirect_to travel_planning_date_upload_prepare_path
    end
  end
  private
  def thumbnail_params
    params.require(:schedule).permit(:id, thumbnails_attributes: [:id,:schedule_id, :user_id,:image,:image_cache, :_destroy])
  end
end
