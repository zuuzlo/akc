class CouponKohlsType < ActiveRecord::Base
  
  validates_presence_of :coupon, :kohls_type

  belongs_to :coupon
  belongs_to :kohls_type
end
