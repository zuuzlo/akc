class CouponKohlsCategory < ActiveRecord::Base
  validates_presence_of :coupon, :kohls_category

  belongs_to :coupon
  belongs_to :kohls_category

end
