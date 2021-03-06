require 'rails_helper'

class FakesController < ApplicationController
  include LoadCoupons
end

describe FakesController do
  let(:cat1) { Fabricate(:kohls_category) }
  
  describe "#load_coupons" do
  
    it "sets @coupons that are not expired in category" do
      coupon = Array.new
      (1..3).each do |i|
        coupon[i] = Fabricate(:coupon, title: "coupon#{i}", code: "CODE#{i}", end_date: Time.now - i.hour, start_date: Time.now - 12.hour )
        coupon[i].kohls_categories << cat1
      end

      (4..5).each do |i|
        coupon[i] = Fabricate(:coupon, title: "coupon#{i}", code: nil, end_date: Time.now + i.hour, start_date: Time.now - 12.hour )
        coupon[i].kohls_categories << cat1
      end 
      subject.load_coupons(cat1)
      expect(assigns(:coupons)).to eq([coupon[4], coupon[5]])
    end

    it "sets @coupons to empty of there are no coupons in cat" do
      subject.load_coupons(cat1)
      expect(assigns(:coupons)).to eq([])
    end
  end

  describe "#load_coupon_offer_code" do
    context "has coupon code, no offers" do
      before do
        coupon1 = Fabricate( :coupon, code: 'now', end_date: Time.now + 1.hour, start_date: Time.now - 12.hour )
        coupon1.kohls_categories << cat1
        subject.load_coupon_offer_code(Coupon.all)
      end

      it "sets @codes_count" do
        expect(assigns(:codes_count)).to eq(1)
      end

      it "sets @offers_count to 0" do
        expect(assigns(:offers_count)).to eq(0)
      end
    end

    it "sets @offers_count" do
      coupon1 = Fabricate( :coupon, code: nil, end_date: Time.now + 1.hour, start_date: Time.now - 12.hour )
      coupon1.kohls_categories << cat1
      subject.load_coupon_offer_code(Coupon.all)
      expect(assigns(:offers_count)).to eq(1)
    end
  end

  describe "#load_cal_picts" do
    it "sets @cal_coupons" do
      coupon = Array.new
      (1..5).each do |i|
        coupon[i] = Fabricate(:coupon, title: "coupon#{i}", end_date: Time.now + i.hour, start_date: Time.now - 12.hour )
        coupon[i].kohls_categories << cat1
      end 
      subject.load_cal_picts(Coupon.all)
      expect(assigns(:cal_coupons).count).to eq(5)
    end
  end

  describe "#coupon_codes" do
    (1..3).each do |i|
      let!("coupon#{i}".to_sym) { Fabricate(:coupon, title: "coupon#{i}", code: "CODE#{i}", end_date: Time.now + i.hour, start_date: Time.now - 12.hour ) }
    end

    (4..5).each do |i|
      let!("coupon#{i}".to_sym) { Fabricate(:coupon, title: "coupon#{i}", code: nil, end_date: Time.now + i.day, start_date: Time.now - 12.hour ) }
    end

    it "should return 3 coupon codes" do
      expect(subject.coupon_codes(Coupon.all)).to eq(3)
    end
  end

  describe "#coupon_offers" do
    (1..3).each do |i|
      let!("coupon#{i}".to_sym) { Fabricate(:coupon, title: "coupon#{i}", code: "CODE#{i}", end_date: Time.now + i.hour, start_date: Time.now - 12.hour ) }
    end

    (4..5).each do |i|
      let!("coupon#{i}".to_sym) { Fabricate(:coupon, title: "coupon#{i}", code: nil, end_date: Time.now + i.day, start_date: Time.now - 12.hour ) }
    end
    
    it "should return 2 coupon codes" do
      expect(subject.coupon_offers(Coupon.all)).to eq(2)
    end
  end 
end