# == Schema Information
#
# Table name: modders
#
#  id               :bigint           not null, primary key
#  bio              :string
#  etsy_shop        :string
#  featured_link    :string
#  name             :string           not null
#  slug             :string           not null
#  status           :string           not null
#  twitter_username :string
#  website_url      :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_modders_on_slug     (slug) UNIQUE
#  index_modders_on_user_id  (user_id)
#
class Modder < ApplicationRecord
  belongs_to :user

  attribute :status, :string, default: 'active'

  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :bio, length: { maximum: 500 }
  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug, if: :will_save_change_to_name?

  def to_param
    slug
  end

  private

  def generate_slug
    self.slug = name.parameterize
  end
end
