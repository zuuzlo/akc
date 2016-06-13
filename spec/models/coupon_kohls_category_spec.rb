require 'rails_helper'

RSpec.describe CouponKohlsCategory, type: :model do
  it { should belong_to(:coupon) }
  it { should belong_to(:kohls_category) }

  it { should validate_presence_of(:coupon) }
  it { should validate_presence_of(:kohls_category) }
end
