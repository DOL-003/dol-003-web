# == Schema Information
#
# Table name: modders
#
#  id               :bigint           not null, primary key
#  bio              :string
#  city             :string
#  etsy_shop        :string
#  featured_link    :string
#  latitude         :string
#  logo             :string
#  longitude        :string
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

  FEATURED_LINK_OPTIONS = [
    ['Website', 'website_url'],
    ['Etsy shop', 'etsy_shop'],
    ['Twitter handle', 'twitter_username']
  ]

  belongs_to :user
  has_many :modder_services
  has_many :modder_photos, -> { order(index: :asc) }

  attribute :status, :string, default: 'active'

  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :bio, length: { maximum: 500 }
  validates :slug, presence: true, uniqueness: true
  validates :city, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :featured_link, inclusion: { in: FEATURED_LINK_OPTIONS.map { |opt| opt[1] } }

  validates :website_url,
    presence: { message: 'Featured link must be present' },
    if: -> { featured_link == 'website_url' }
  validates :etsy_shop,
    presence: { message: 'Featured link must be present' },
    if: -> { featured_link == 'etsy_shop' }
  validates :twitter_username,
    presence: { message: 'Featured link must be present' },
    if: -> { featured_link == 'twitter_username' }

  validates :website_url, url: { message: 'Must be a valid URL' }, allow_blank: true
  validates :etsy_shop, length: { in: 3..50, message: 'Must be at least 3 letters' }, allow_blank: true
  validates :twitter_username, length: { in: 2..50, message: 'Must be at least 2 letters' }, allow_blank: true

  before_validation :generate_slug, if: :will_save_change_to_name?

  mount_uploader :logo, ModderLogoUploader

  scope :order_by_proximity, -> (latitude, longitude) {
    select('*').select(sanitize_sql_array(['|/((? - latitude::DECIMAL) ^ 2 + (? - longitude::DECIMAL) ^ 2) as distance', latitude, longitude])).order(distance: :asc)
  }

  def to_param
    slug
  end

  private

  def generate_slug
    self.slug = name.parameterize
  end
end
