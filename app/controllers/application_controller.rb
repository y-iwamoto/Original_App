class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  add_flash_types :success, :info, :warning, :danger
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :current_notifications, if: :signed_in?

  def after_sign_in_path_for(resource)
      travel_planning_index_path
  end
  def current_notifications
     @notifications_count = Notification.where(user_id: current_user.id).where(read_flg: false).count
   end
  protected
    def sign_in_required
        redirect_to new_user_session_url unless user_signed_in?
    end
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
      devise_parameter_sanitizer.permit(:account_update, keys: [:username])
    end

end
