class Thumbnail < ApplicationRecord
  include ActiveModel::Validations
  belongs_to :schedule
  mount_uploader :image, ImageUploader
  validates :image,
    :presence => true,
    :file_size => {
        :maximum => 1.megabytes.to_i
    }
end
