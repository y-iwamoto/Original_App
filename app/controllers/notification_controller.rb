class NotificationController < ApplicationController
  def index
    @chng_read_flg = true
    if params['read_flg'] != nil && params['read_flg'] ==  "1"
      @notifications = current_user.notifications_of_from_user.where(read_flg: true)
      @chng_read_flg = false
    else
      @notifications = current_user.notifications_of_from_user.where(read_flg: false)
    end
  end

  def show
    #招待の通知内容を確認する場合
    if params[:content] == nil
      @spots = Spot.where(user_id:params[:user_id])
      @schedules = Schedule.includes(:schedule_each_dates => :schedule_each_times).find_by(user_id:params[:user_id] ,id:params[:schedule_id])
    #通常の通知内容を確認する場合
    else
      @content = params[:content]
    end
  end
  def update
    notification = current_user.notifications_of_from_user.find(params[:notification_id])
    if notification != nil
      notification.update_attribute(:read_flg, params[:read_flg])
    end
    redirect_to notification_index_path
  end

  def destroy
    notification = current_user.notifications_of_from_user.find(params[:notification_id])
    if notification != nil && notification.destroy
      flash[:success] = "対象の通知を削除しました"
    else
      flash[:error] = "対象の通知削除に失敗しました"
    end
    redirect_to notification_index_path
  end
end
