# == Schema Information
#
# Table name: modders
#
#  id               :bigint           not null, primary key
#  description      :string
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
end
