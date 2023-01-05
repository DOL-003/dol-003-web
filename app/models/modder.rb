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
#  uuid             :string
#  vetting_status   :string
#  website_url      :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_modders_on_name            (name) USING gin
#  index_modders_on_slug            (slug) UNIQUE
#  index_modders_on_user_id         (user_id)
#  index_modders_on_vetting_status  (vetting_status)
#
class Modder < ApplicationRecord

  FEATURED_LINK_OPTIONS = [
    ['Website', 'website_url'],
    ['Etsy shop', 'etsy_shop'],
    ['Twitter handle', 'twitter_username']
  ]

  STATUS_ACTIVE = 'active'
  STATUS_INACTIVE = 'inactive'
  STATUS_BANNED = 'banned'

  STATUS_OPTIONS = [
    ['Active', STATUS_ACTIVE],
    ['Inactive', STATUS_INACTIVE]
  ]

  VETTING_STATUS_VETTED = 'vetted'
  VETTING_STATUS_REJECTED = 'rejected'

  belongs_to :user
  has_many :modder_services
  has_many :modder_photos, -> { order(index: :asc) }

  attribute :status, :string, default: 'active'
  validates :status, inclusion: { in: [STATUS_ACTIVE, STATUS_INACTIVE, STATUS_BANNED] }

  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :bio, length: { maximum: 500 }
  validates :slug, presence: true, uniqueness: true
  validates :city, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :vetting_status, inclusion: { in: [VETTING_STATUS_VETTED, VETTING_STATUS_REJECTED] }, allow_blank: true
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

  before_create do |modder|
    modder.uuid ||= SecureRandom.urlsafe_base64(20)
  end

  mount_uploader :logo, ModderLogoUploader

  scope :order_by_proximity, -> (latitude, longitude) {
    select('*').select(sanitize_sql_array(['|/((? - latitude::DECIMAL) ^ 2 + (? - longitude::DECIMAL) ^ 2) as distance', latitude, longitude])).order(distance: :asc)
  }

  scope :name_similar_to, ->(query) {
    quoted_query = ActiveRecord::Base.connection.quote_string(query)
    where('name % :query', query:).
      order(Arel.sql("similarity(name, '#{quoted_query}') desc"))
  }

  scope :vetted, -> { where(vetting_status: VETTING_STATUS_VETTED) }
  scope :random, -> (limit) { order('random()').limit(limit) }
  scope :has_photos, -> { where.associated(:modder_photos).group(:id) }

  def to_param
    slug
  end

  def self.featured_modders
    vetted.has_photos.random(3)
  end

  def featured_link_url
    return '' if featured_link.blank?

    case featured_link
    when 'website_url'
      website_url
    when 'etsy_shop'
      etsy_url
    when 'twitter_username'
      twitter_url
    end
  end

  def featured_link_text
    case featured_link
    when 'website_url'
      'Visit website'
    when 'etsy_shop'
      'Etsy shop'
    when 'twitter_username'
      'Twitter profile'
    end
  end

  def etsy_url
    "https://#{etsy_shop}.etsy.com"
  end

  def twitter_url
    "https://twitter.com/#{twitter_username}"
  end

  def formatted_twitter_username
    twitter_username[0] == '@' ? twitter_username : "@#{twitter_username}"
  end

  def active?
    status == STATUS_ACTIVE
  end

  def inactive?
    !active?
  end

  private

  def generate_slug
    self.slug = name.parameterize
  end
end
