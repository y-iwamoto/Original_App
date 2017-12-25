class IntroductionController < ApplicationController
  def index
    @users = User.all
    #@notification = current_user.notifications_of_from_user.build(opponent_user_id: current_user.id)
  end
  def post
     #require "pry"
     #binding.pry
    #raise
    @user = User.find_by(id: params[:notification][:opponent_user_id])
    #@user = User.find_by(username: params[:name],email: params[:email]);
    if @user != nil
      # params[:notification][:read_flg] = false
      # params[:notification][:user_id] = @user.id
      # params[:notification][:opponent_user_id] = current_user.id
      # last_notification = Notification.last
      # notification_id = Notification.last == nil ? 1 : last_notification.id
      # params[:notification][:id] = notification_id
      # params[:notification][:created_at] = DateTime.now
      # params[:notification][:updated_at] = DateTime.now
      # notification = params[:notification].permit(:id,:read_flg, :user_id, :opponent_user_id,:created_at,:updated_at)

      if current_user.notifications_of_from_user.create!(user_id: @user.id,opponent_user_id: current_user.id)
        Pusher['user' + @user.id.to_s + 'channel'].trigger('push_created', {
          message: current_user.username + "さんから通知です"
        })
        flash[:success] = "通知を送信しました"
        redirect_to introduction_index_path
      else
        flash[:error] = "通知送信に失敗しました"
        redirect_to introduction_index_path
      end
    else
      flash[:error] = "対象ユーザがいません"
      redirect_to introduction_index_path
    end
  end

end
