# == Schema Information
#
# Table name: modder_photos
#
#  id         :bigint           not null, primary key
#  height     :integer
#  index      :integer          not null
#  photo      :string           not null
#  uuid       :string           not null
#  width      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  modder_id  :bigint           not null
#
# Indexes
#
#  index_modder_photos_on_modder_id  (modder_id)
#
class ModderPhoto < ApplicationRecord

  THUMB_HEIGHT = 280 * 2

  belongs_to :modder

  mount_uploader :photo, ModderPhotoUploader

  before_create do |modder_photo|
    modder_photo.uuid ||= SecureRandom.urlsafe_base64(20)
  end

  def thumb_display_width
    (0.5 * width.to_f * (THUMB_HEIGHT.to_f / height.to_f)).round
  end

  def thumb_display_height
    (THUMB_HEIGHT.to_f / 2).round
  end

end
