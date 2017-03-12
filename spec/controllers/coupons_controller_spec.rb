require 'rails_helper'

RSpec.describe CouponsController, type: :controller do

  describe "GET #index" do
    let!(:coupon1) { Fabricate(:coupon, code: 'BUYNOW', description: 'good car', end_date: Time.now + 3.hour ) }
    let!(:coupon2) { Fabricate(:coupon, code: nil, description: 'fast car', end_date: Time.now + 1.hour ) }
    let!(:coupon3) { Fabricate(:coupon, code: nil, description: 'fast dog', end_date: Time.now + 2.hour ) }

    before { get :index }
    
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "load coupons in order" do
      expect(assigns(:coupons)).to eq([coupon2, coupon3, coupon1])
    end

    it "have 1 @codes_count" do
      expect(assigns(:codes_count)).to eq(1)
    end

    it "have 2 @offers_count" do
      expect(assigns(:offers_count)).to eq(2)
    end

    it "have 3 @cal_coupons" do
      expect(assigns(:cal_coupons).count).to eq(3)
    end
  end

  describe "GET #search" do
    it "returns http success" do
      get :search
      expect(response).to have_http_status(:success)
    end
    context "with search term" do
      let!(:coupon1) { coupon1 = Fabricate(:coupon, code: 'BUYNOW', description: 'good car', end_date: Time.now + 1.hour ) }
      let!(:coupon2) { coupon2 = Fabricate(:coupon, code: nil, description: 'fast car', end_date: Time.now + 1.hour ) }
      let!(:coupon3) { coupon3 = Fabricate(:coupon, code: nil, description: 'fast dog', end_date: Time.now + 1.hour ) }
      
      before { get :search, search_term: 'car' }

      it "set @coupons where coupons description has search term" do   
        expect(assigns(:coupons)).to eq([coupon1, coupon2])
      end

      it "set @term to search term" do     
        expect(assigns(:term)).to eq('car')
      end

      it "set @codes_count" do      
        expect(assigns(:codes_count)).to eq(1)
      end

      it "set @offers_count" do   
        expect(assigns(:offers_count)).to eq(1)
      end
    end

    context "with blank search term" do
      let!(:coupon1) { coupon1 = Fabricate(:coupon, code: 'BUYNOW', description: 'good car', end_date: Time.now + 1.hour ) }
      let!(:coupon2) { coupon2 = Fabricate(:coupon, code: nil, description: 'fast car', end_date: Time.now + 1.hour ) }
      let!(:coupon3) { coupon3 = Fabricate(:coupon, code: nil, description: 'fast dog', end_date: Time.now + 1.hour ) }
      
      before { get :search, search_term: '' }

      it "set @coupons where coupons description has search term" do   
        expect(assigns(:coupons)).to eq([])
      end
    end
  end

  describe "GET #tab_all" do
    it "returns http success" do
      get :tab_all
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #tab_coupon_codes" do
    it "returns http success" do
      get :tab_coupon_codes
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #tab_offers" do
    it "returns http success" do
      get :tab_offers
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #coupon_link" do
    it "returns http success" do
      get :coupon_link, id: 100
      expect(response).to have_http_status(302)
    end

    let!(:coupon1) { coupon1 = Fabricate(:coupon, code: 'BUYNOW', description: 'good car', end_date: Time.now + 3.hour ) }

    context "no user source id 1" do
      before { get :coupon_link, id: coupon1.id }

      it "should redirect to link of coupon plus added" do
        expect(response).to redirect_to coupon1.link + "&u1=akc"
      end
    end


    context "coupon doesn't exist" do
      let!(:coupon2) { coupon2 = Fabricate(:coupon, code: 'BUYNOW', description: 'good car', end_date: Time.now + 3.hour ) }
      before do
        get :coupon_link, id: 100
      end

      it "should redirect to link of last coupon plus added" do
        expect(response).to redirect_to coupon2.link + "&u1=akc"
      end
    end
  end

  describe "GET #reveal_code_link" do
    let!(:coupon2) { Fabricate(:coupon, code: 'BUYNOW', description: 'good car', end_date: Time.now + 3.hour ) }
    it "returns http success" do
      xhr :get, :reveal_code_link, id: coupon2.id, format: :js
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    let!(:coupon1) { Fabricate(:coupon, code: 'BUYNOW', description: 'good car', end_date: Time.now - 3.hour ) }
    let!(:coupon2) { Fabricate(:coupon, code: nil, description: 'fast car', end_date: Time.now - 1.hour ) }
    let!(:coupon3) { Fabricate(:coupon, code: nil, description: 'fast dog', end_date: Time.now - 2.hour ) }

    let!(:coupon4) { Fabricate(:coupon, code: 'BUYNOW', description: 'good car', end_date: Time.now + 3.hour ) }
    let!(:coupon5) { Fabricate(:coupon, code: nil, description: 'fast car', end_date: Time.now + 1.hour ) }
    let!(:coupon6) { Fabricate(:coupon, code: nil, description: 'fast dog', end_date: Time.now + 2.hour ) }

    before do
      xhr :get, :show, id: coupon1.id, format: 'html'
    end

    it "returns http success" do
      
      expect(response).to have_http_status(:success)
    end

    it "has @coupon" do
      expect(assigns(:coupon)).to eq(coupon1)
    end

    it "has @simular_coupons" do
      expect(assigns(:coupons)).to include(coupon4,coupon5,coupon6)
    end

    it "@simular_coupons has 3" do
      expect(assigns(:coupons).count).to eq(3)
    end
  end

  describe "GET #add_comment" do
    let!(:coupon1) { Fabricate(:coupon, code: 'BUYNOW', description: 'good car', end_date: Time.now + 3.hour ) }

    before do
      xhr :get, :add_comment, id: coupon1.id, format: 'js'
    end

    it "returns http success" do   
      expect(response).to have_http_status(:success)
    end

    it "has @coupon" do
      expect(assigns(:coupon)).to eq(coupon1)
    end
  end

  describe "GET #hide_comment" do
    let!(:coupon1) { Fabricate(:coupon, code: 'BUYNOW', description: 'good car', end_date: Time.now + 3.hour ) }

    before do
      xhr :get, :hide_comment, id: coupon1.id, format: 'js'
    end

    it "returns http success" do   
      expect(response).to have_http_status(:success)
    end

    it "has @coupon" do
      expect(assigns(:coupon)).to eq(coupon1)
    end
  end
end