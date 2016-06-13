require 'rails_helper'

RSpec.describe KohlsOnly, type: :model do
  it { should have_many(:coupon_kohls_onlies) }
  it { should have_many(:coupons).through(:coupon_kohls_onlies) }
  it { should validate_presence_of(:name) }

  let(:computers) {Fabricate(:kohls_only, name: "computers") }
  let(:pets) { Fabricate(:kohls_only, name: "pets") }
  
  describe "with_coupons" do
    it "should return all kohls categories with coupons end_date after time now with name in alphabit order" do
      coupon = Array.new
      (1..3).each do |i|
        coupon[i] = Fabricate(:coupon, title: "coupon#{i}", end_date: Time.now + i.hour )
        coupon[i].kohls_onlies << computers
        coupon[i].kohls_onlies << pets
      end 
      expect(KohlsOnly.with_coupons).to eq([computers, pets])
    end

    it "should return only kohls category with coupons not out of date" do
      coupon = Array.new
      (1..3).each do |i|
        coupon[i] = Fabricate(:coupon, title: "coupon#{i}", end_date: Time.now - i.hour )
        coupon[i].kohls_onlies << computers
      end

      (4..5).each do |i|
        coupon[i] = Fabricate(:coupon, title: "coupon#{i}", end_date: Time.now + i.hour )
        coupon[i].kohls_onlies << pets
      end  
      expect(KohlsOnly.with_coupons).to eq([pets])
    end
  end
end
