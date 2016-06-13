require 'rails_helper'

RSpec.describe KohlsCategory, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:slug) }
  it { should have_many(:coupon_kohls_categories) }
  it { should have_many(:coupons).through(:coupon_kohls_categories) }
end
