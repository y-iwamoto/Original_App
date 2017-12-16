class UserMailer < ApplicationMailer
  default :from => ENV['GMAIL_ADRESS']

  def send_signup_email(user,root_url)
    @user = user
    @root_url = root_url
    mail( :to => @user.email,
    :subject => '登録完了' )
  end
  def send_signup_admin_email(user,root_url)
    @user = user
    @root_url = root_url + 'admin/'
    @admin_user = AdminUser.all
    @admin_user.each do |admin_user|
      mail( :to => admin_user.email,
      :subject => '新規ユーザ追加' )
    end
  end

end
