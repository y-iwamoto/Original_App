class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    callback_from :facebook
  end

  def google_oauth2
    callback_from :google_oauth2
  end

  private

  def callback_from(provider)
    @omniauth = request.env['omniauth.auth']
    #認証権限情報があったらプロファイル情報とユーザ情報を取得しにいく
    if @omniauth.present?
      #ProviderとuIDからユーザのプロファイル情報取得
      @profile = SocialProfile.where(provider: @omniauth['provider'], uid: @omniauth['uid']).first
      #ユーザのメールが一意であるため、認証権限情報のメールからユーザを取得
      user = User.find_by(email: @omniauth['info']['email'])
      #プロファイル情報が取得できなければ、新規でプロファイル情報とユーザ情報を設定する
      unless @profile
        @profile = SocialProfile.where(provider: @omniauth['provider'], uid: @omniauth['uid']).new
        @profile.user = user || User.create!(username: @omniauth['info']['name'],email: @omniauth['info']['email'],password: Devise.friendly_token.first(8))
        @profile.save!
      end
      #ユーザが存在すれば、旅行計画画面へ遷移
      if user != nil && user.persisted?
        sign_in_and_redirect user, event: :authentication
        set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
      #ユーザが存在しなければ、ユーザ新規作成画面へ遷移
      else
        user.reset_confirmation!
        flash[:warning] = "認証用のメールアドレスが存在しないため、新規でユーザを作成ください"
        redirect_to finish_signup_path(user)
      end
    else
      flash[:danger] = "対象プロバイダーの認証用データが存在しません"
      redirect_to root_url and return
    end
 end
end
