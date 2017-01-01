require 'rails_helper'

RSpec.describe KohlsOnliesController, type: :controller do
  describe "GET #show" do
    let!(:coupon1) { Fabricate(:coupon, code: 'BUYNOW', description: 'good car', end_date: Time.now + 1.hour ) }
    let!(:coupon2) { Fabricate(:coupon, code: nil, description: 'fast car', end_date: Time.now + 1.hour ) }
    let!(:coupon3) { coupon3 = Fabricate(:coupon, code: nil, description: 'fast dog', end_date: Time.now + 1.hour ) }
    let!(:cat) { Fabricate(:kohls_only) }
    before do
      [coupon1, coupon2, coupon3].each do | coupon |
        cat.coupons << coupon
      end

      xhr :get, :show, id: cat.id
    end

    it "returns http success" do

      expect(response).to render_template('shared/display_coupons') 
    end

    it "assigns right kohls_category" do
      expect(assigns(:category)).to eq(cat)
    end

    it "loads all the coupons" do
      expect(assigns(:coupons).count).to eq(3)
    end
  end
end
