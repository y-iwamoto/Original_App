class Notification < ApplicationRecord
  belongs_to :user, class_name: "User"
  belongs_to :opponent_user, class_name: "User"
  validates :user_id, presence: true
  validates :opponent_user_id, presence: true
end
