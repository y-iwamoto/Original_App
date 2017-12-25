class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  has_many :schedules,dependent: :destroy
  has_many :spots,dependent: :delete_all
  has_many :social_profiles

  has_many :notifications_of_from_user, foreign_key: "user_id", dependent: :destroy,class_name:"Notification"
  has_many :notificates_of_from_user, through: :notifications_of_from_user, source: :user
  has_many :notifications_of_to_user, foreign_key: "opponent_user_id",class_name:"Notification",dependent:   :destroy
  has_many :notificates_of_to_user, through: :notifications_of_to_user, source: :opponent_user


  validates :username, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }


 #ユーザアカウント更新時にパスワードとパスワード確認が空なら、パスワード部分は無視して更新
  def update_without_current_password(params, *options)

    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

end
