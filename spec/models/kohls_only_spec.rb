require 'rails_helper'

RSpec.describe KohlsOnly, type: :model do
  it { should have_many(:coupon_kohls_onlies) }
  it { should have_many(:coupons).through(:coupon_kohls_onlies) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:kc_id) }
  
  describe "#with_coupons" do
    let(:computers) {Fabricate(:kohls_only, name: "computers") }
    let(:pets) { Fabricate(:kohls_only, name: "pets", kc_id: 2) }
    
    (1..3).each do |i|
      let("coupon#{i}".to_sym) { Fabricate(:coupon, title: "coupon#{i}", end_date: Time.now + i.hour ) }
      let("coupon#{i+3}".to_sym) { Fabricate(:coupon, title: "coupon#{i+3}", end_date: Time.now - i.hour ) }
    end

    before do
      [coupon1, coupon2, coupon3].each do | coupon |
        coupon.kohls_onlies << computers
      end
      [coupon4, coupon5, coupon6].each do | coupon |
        coupon.kohls_onlies << pets
      end
    end
    
    it "should return all kohls categories with coupons end_date after time now with name in alphabit order" do
      expect(KohlsOnly.with_coupons).to eq([computers])
    end
  end
end
