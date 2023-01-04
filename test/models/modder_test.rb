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
require "test_helper"

class ModderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
