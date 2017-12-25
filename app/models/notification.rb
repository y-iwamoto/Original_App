class Notification < ApplicationRecord
  belongs_to :notifications_of_from_user, class_name: "User"
  belongs_to :notifications_of_to_user, class_name: "User"
end
