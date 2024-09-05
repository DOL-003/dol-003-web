# == Schema Information
#
# Table name: modders
#
#  id                 :bigint           not null, primary key
#  bio                :string
#  city               :string
#  discord_username   :string
#  etsy_shop          :string
#  featured_link      :string
#  instagram_username :string
#  latitude           :string
#  logo               :string
#  longitude          :string
#  name               :string           not null
#  slug               :string           not null
#  status             :string           not null
#  twitter_username   :string
#  uuid               :string
#  vetting_status     :string
#  visibility         :string           not null
#  website_url        :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :bigint
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
    ['Twitter handle', 'twitter_username'],
    ['Instagram handle', 'instagram_username'],
    ['Discord username', 'discord_username']
  ]

  STATUS_ACTIVE = 'active'
  STATUS_INACTIVE = 'inactive'
  STATUS_BANNED = 'banned'

  STATUS_OPTIONS = [
    ['Active', STATUS_ACTIVE],
    ['Inactive', STATUS_INACTIVE]
  ]

  VISIBILITY_VISIBLE = 'visible'
  VISIBILITY_HIDDEN = 'hidden'

  VISIBILITY_OPTIONS = [
    ['Visible', VISIBILITY_VISIBLE],
    ['Hidden', VISIBILITY_HIDDEN]
  ]

  VETTING_STATUS_VETTED = 'vetted'
  VETTING_STATUS_REJECTED = 'rejected'

  VETTING_STATUS_OPTIONS = [
    ['Vetted', VETTING_STATUS_VETTED],
    ['Rejected', VETTING_STATUS_REJECTED],
    ['None', nil]
  ]

  belongs_to :user, optional: true
  has_many :modder_services
  has_many :modder_photos, -> { order(index: :asc) }

  attribute :status, :string, default: STATUS_ACTIVE
  validates :status, inclusion: { in: [STATUS_ACTIVE, STATUS_INACTIVE, STATUS_BANNED] }

  attribute :visibility, :string, default: VISIBILITY_VISIBLE
  validates :visibility, inclusion: { in: [VISIBILITY_VISIBLE, VISIBILITY_HIDDEN] }

  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :bio, length: { maximum: 1000 }
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
  validates :instagram_username,
    presence: { message: 'Featured link must be present' },
    if: -> { featured_link == 'instagram_username' }
  validates :discord_username,
    presence: { message: 'Featured link must be present' },
    if: -> { featured_link == 'discord_username' }

  validates :website_url, url: { message: 'Must be a valid URL' }, allow_blank: true
  validates :etsy_shop, length: { in: 3..50, message: 'Must be at least 3 letters' }, allow_blank: true
  validates :twitter_username, length: { in: 2..50, message: 'Must be at least 2 characters' }, allow_blank: true
  validates :instagram_username, length: { in: 2..50, message: 'Must be at least 2 characters' }, allow_blank: true
  validates :discord_username, length: { in: 2..32, message: 'Must be at least 2 characters' }, allow_blank: true

  before_validation :generate_slug, if: :will_save_change_to_name?

  before_create do |modder|
    modder.uuid ||= SecureRandom.urlsafe_base64(20)
  end

  mount_uploader :logo, ModderLogoUploader

  scope :order_by_proximity, lambda  { |latitude, longitude|
    select('*').select(sanitize_sql_array(['|/((? - latitude::DECIMAL) ^ 2 + (? - longitude::DECIMAL) ^ 2) as distance', latitude, longitude])).order(distance: :asc)
  }

  scope :name_similar_to, lambda { |query|
    quoted_query = ActiveRecord::Base.connection.quote_string(query)
    where('name % :query', query:).
      order(Arel.sql("similarity(name, '#{quoted_query}') desc"))
  }

  scope :vetted, -> { where(vetting_status: VETTING_STATUS_VETTED) }
  scope :random, -> (limit) { order('random()').limit(limit) }
  scope :has_logo, -> { where('logo is not null') }
  scope :has_photos, -> { where.associated(:modder_photos).group(:id) }
  scope :active, -> { where(status: STATUS_ACTIVE) }
  scope :visible, -> { where(visibility: VISIBILITY_VISIBLE) }

  def to_param
    slug
  end

  def self.featured_modders
    active.vetted.has_logo.has_photos.random(3)
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
    when 'instagram_username'
      instagram_url
    end
  end

  def featured_link_text
    case featured_link
    when 'website_url'
      'Visit website'
    when 'etsy_shop'
      etsy_shop_name
    when 'twitter_username'
      formatted_twitter_username
    when 'instagram_username'
      formatted_instagram_username
    when 'discord_username'
      discord_username
    end
  end

  def etsy_url
    "https://#{etsy_shop_name}.etsy.com"
  end

  def etsy_shop_name
    return '' unless etsy_shop.present?

    subdirectory_match = etsy_shop.match /(?:https?:\/\/)?(?:www\.)?etsy\.com\/shop\/([^\/]+)/
    subdomain_match = etsy_shop.match /(?:https?:\/\/)?([^.]+)\.etsy\.com/
    if subdirectory_match.present?
      subdirectory_match[1]
    elsif subdomain_match.present?
      subdomain_match[1]
    else
      etsy_shop
    end
  end

  def twitter_url
    "https://twitter.com/#{formatted_twitter_username}"
  end

  def formatted_twitter_username(at: true)
    return '' unless twitter_username.present?

    prefix = at ? '@' : ''
    url_match = twitter_username.match /(?:https?:\/\/)?(?:www\.)?twitter\.com\/([^\/?]+)/
    if url_match.present?
      "#{prefix}#{url_match[1]}"
    else
      username = twitter_username[0] == '@' ? twitter_username[1..] : twitter_username
      "#{prefix}#{username}"
    end
  end

  def instagram_url
    "https://instagram.com/#{formatted_instagram_username}"
  end

  def formatted_instagram_username
    return '' unless instagram_username.present?

    url_match = instagram_username.match /(?:https?:\/\/)?(?:www\.)?instagram\.com\/([^\/?]+)/
    if url_match.present?
      url_match[1]
    else
      instagram_username
    end
  end

  def active?
    status == STATUS_ACTIVE
  end

  def inactive?
    !active?
  end

  def visible?
    visibility == VISIBILITY_VISIBLE
  end

  def hidden?
    visibility == VISIBILITY_HIDDEN
  end

  def vetted?
    vetting_status == VETTING_STATUS_VETTED
  end

  def unclaimed?
    user_id.blank?
  end

  private

  def generate_slug
    self.slug = name.parameterize
  end
end
