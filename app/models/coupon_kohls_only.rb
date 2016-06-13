class CouponKohlsOnly < ActiveRecord::Base
  validates_presence_of :coupon, :kohls_only

  belongs_to :coupon
  belongs_to :kohls_only
end
