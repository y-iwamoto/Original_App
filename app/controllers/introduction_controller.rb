class IntroductionController < ApplicationController
  def index
  end
  def post
    require "pry"
    binding.pry
    user = User.find_by(username: params[:name],email: params[:email]);
    if user != nil
      Notification.create(my_user_id: user.id, opponent_user_id: current_user.id)
      Pusher.trigger("user_"+ user.id.to_s + "_channel",'push_created', {
        message: current_user.username + "さんから通知です"
      })
      flash[:success] = "通知を送信しました"
      redirect_to introduction_index_path
    else
      flash[:error] = "対象ユーザがいません"
      render introduction_index_path
    end
  end
end
