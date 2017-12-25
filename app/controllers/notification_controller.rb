class NotificationController < ApplicationController
  def index
    @notifications = current_user.notifications.where(read_flg: false)
  end

  def show
  end
end
