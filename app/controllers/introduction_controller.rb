class IntroductionController < ApplicationController
  def index
    @schedules = Schedule.where(user_id: current_user.id)
  end
  def post
    @user = User.find_by(username: params[:name],email: params[:email]);
    if @user != nil
      if @user.notifications_of_from_user.create!(user_id: @user.id,opponent_user_id: current_user.id,introduce_flg: true, content:params[:schedule] )
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
