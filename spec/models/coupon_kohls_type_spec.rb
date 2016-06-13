require 'rails_helper'

RSpec.describe CouponKohlsType, type: :model do
  it { should belong_to(:coupon) }
  it { should belong_to(:kohls_type) }

  it { should validate_presence_of(:coupon) }
  it { should validate_presence_of(:kohls_type) }
end
