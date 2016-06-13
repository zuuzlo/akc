class RemovedCoupon < ActiveRecord::Base
  validates :id_of_coupon, presence: true
end
