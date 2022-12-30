# == Schema Information
#
# Table name: modder_photos
#
#  id         :bigint           not null, primary key
#  index      :integer          not null
#  photo      :string           not null
#  uuid       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  modder_id  :bigint           not null
#
# Indexes
#
#  index_modder_photos_on_modder_id  (modder_id)
#
class ModderPhoto < ApplicationRecord
  belongs_to :modder

  mount_uploader :photo, ModderPhotoUploader

  before_create do |modder_photo|
    modder_photo.uuid ||= SecureRandom.urlsafe_base64(20)
  end
end
