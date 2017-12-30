ActiveAdmin.register_page "Dashboard" do
  page_action :transmit, method: :post
  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    panel "Recent Posts" do
       ul do
        notifications.map do |notification|
          li "内容：" + notification.content + " 送信先ユーザ：" + notification.user.try(:username)
        end
      end
    end
    render "partial_form"
  end # content

  controller do
    def index
      @users = User.all
      @user = User.find(current_admin_user.id)
      @notifications = @user.notifications_of_to_user.where(introduce_flg: false).limit(5)
    end
    def transmit
      @user = User.find_by(id: params[:user]);
      if @user != nil
        if @user.notifications_of_from_user.create!(user_id: @user.id,opponent_user_id: current_admin_user.id,introduce_flg: false, content:params[:text_field] )
          Pusher['user' + @user.id.to_s + 'channel'].trigger('push_created', {
            message: "管理者から通知です"
          })

          flash[:success] = "通知を送信しました"
          redirect_to admin_dashboard_path
        else
          logger.error("通知送信に失敗しました")
          redirect_to admin_dashboard_path
        end
      else
        flash[:error] = "対象ユーザがいません"
        redirect_to admin_dashboard_path
      end
    end
  end
end
