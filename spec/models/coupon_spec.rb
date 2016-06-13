require 'rails_helper'

RSpec.describe Coupon, type: :model do

  it { should have_many(:kohls_types).through(:coupon_kohls_types) }
  it { should have_many(:coupon_kohls_types).dependent(:destroy) }

  it { should have_many(:kohls_categories).through(:coupon_kohls_categories) }
  it { should have_many(:coupon_kohls_categories).dependent(:destroy) }
  
  it { should validate_presence_of(:id_of_coupon) }
  it { should validate_uniqueness_of(:id_of_coupon) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:link) }
  it { should validate_presence_of(:slug) }

  describe "#time_left" do
    context "has end date" do
      let(:coupon1) { Fabricate(:coupon, title: "coupon1", description: 'this is a good coupon', end_date: Time.now + 1.day) }
      
      it "returns time left until expires in words" do
        expect(coupon1.time_left).to eq("1 day")
      end
    end

    context "no end_date" do
      let(:coupon1) { Fabricate(:coupon, title: "coupon1", description: 'this is a good coupon', end_date: nil) }
      
      it "returns no end date" do
        expect(coupon1.time_left).to eq("No End Date")
      end
    end
  end
  
  describe "#active_coupons" do
  
    (1..3).each do |i|
      let!("coupon#{i}".to_sym) { Fabricate(:coupon, title: "coupon#{i}", end_date: Time.now - i.hour, start_date: Time.now - 12.hour ) }
    end

    (4..5).each do |i|
      let!("coupon#{i}".to_sym) { Fabricate(:coupon, title: "coupon#{i}", end_date: Time.now + i.hour, start_date: Time.now - 12.hour ) }
    end

    it "returns coupons that are valid" do 
      expect(Coupon.active_coupons.size).to eq(2)
    end

    it "returns in correct order" do
      expect(Coupon.active_coupons).to eq([coupon4,coupon5])
    end
  end
end
