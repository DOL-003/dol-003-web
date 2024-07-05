require "administrate/base_dashboard"

class ModderDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    bio: Field::String,
    city: Field::String,
    discord_username: Field::String,
    etsy_shop: Field::String,
    featured_link: Field::String,
    instagram_username: Field::String,
    latitude: Field::String,
    logo: Field::String,
    longitude: Field::String,
    modder_photos: Field::HasMany,
    modder_services: Field::HasMany,
    name: Field::String,
    slug: Field::String,
    status: Field::String,
    twitter_username: Field::String,
    user: Field::BelongsTo,
    uuid: Field::String,
    vetting_status: Field::String,
    website_url: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    bio
    city
    discord_username
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    bio
    city
    discord_username
    etsy_shop
    featured_link
    instagram_username
    latitude
    logo
    longitude
    modder_photos
    modder_services
    name
    slug
    status
    twitter_username
    user
    uuid
    vetting_status
    website_url
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    bio
    city
    discord_username
    etsy_shop
    featured_link
    instagram_username
    latitude
    logo
    longitude
    modder_photos
    modder_services
    name
    slug
    status
    twitter_username
    user
    uuid
    vetting_status
    website_url
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how modders are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(modder)
  #   "Modder ##{modder.id}"
  # end
end
