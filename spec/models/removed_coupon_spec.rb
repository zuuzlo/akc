require 'rails_helper'

RSpec.describe RemovedCoupon, type: :model do
  it { should validate_presence_of(:id_of_coupon) }
end
