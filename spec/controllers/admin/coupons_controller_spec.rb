require 'rails_helper'

RSpec.describe Admin::CouponsController, type: :controller do
  
  describe "GET new" do
    before { set_admin_user }
    it "sets @coupon to coupon new" do
      get :new
      expect(assigns(:coupon)).to be_instance_of(Coupon)
    end
  end

  describe "POST create" do
    context "for admin user" do
      before { set_admin_user }

      context "with valid input" do
        let(:coupon) { Fabricate.attributes_for(:coupon) }
        before { post :create, coupon: coupon }
        
        it "redirects to add coupon page" do
          expect(response).to redirect_to new_admin_coupon_path
        end

        it "creates a coupon" do
          expect(Coupon.count).to eq(1)
        end

        it "displays a success message that a new coupon was created" do
          expect(flash[:success]).to be_present
        end
      end

      context "with invalid input" do
        let(:coupon) { Fabricate.attributes_for(:coupon, title: '') }
        before { post :create, coupon: coupon }

        it "redirects to add coupon page" do
          expect(response).to render_template 'new'
        end

        it "doesn't create a coupon" do
          expect(Coupon.count).to eq(0)
        end

        it "sets the flash danger" do
          expect(flash[:danger]).to be_present
        end
      end
    end

    context "for non admin user" do

      let(:coupon) { Fabricate.attributes_for(:coupon) }
      before do
        set_current_user
        post :create, coupon: coupon
      end

      it "does not create a coupon" do
        expect(Coupon.count).to eq(0)
      end
      it "redirects to user home page" do
        expect(response).to redirect_to root_path#user_path(current_user)
      end
      it "sets the flash danger" do
        expect(flash[:danger]).to be_present
      end
    end

    context "for non signed in user" do
      let(:coupon) { Fabricate.attributes_for(:coupon) }
      before do
        post :create, coupon: coupon
      end

      it "does not create a coupon" do
        expect(Coupon.count).to eq(0)
      end
      it "redirects to user root path" do
        expect(response).to redirect_to root_path
      end
      it "sets the flash danger" do
        expect(flash[:danger]).to be_present
      end
    end
  end
  
  describe "GET edit" do
    let(:coupon1) { Fabricate(:coupon) }
    
    before do 
      set_admin_user
      get :edit, id: coupon1.id
    end
    
    it "sets @coupon to coupon to be edited" do
      expect(assigns(:coupon)).to eq(coupon1)
    end

    it "renders new" do
      expect(response).to render_template :new
    end
  end

  describe "PATCH update" do
    context "term blank updated coupon" do
      let(:coupon1) { Fabricate(:coupon) }
      
      before do 
        set_admin_user
        patch :update, coupon: {id_of_coupon: coupon1.id_of_coupon, title: "Graphic Tees Select Styles", description: "Summer Essentials Sale 2 for $20 or $11.99 - $12.99 each Graphic tees. Select styles. orig. $20 each. 6/20-6/24.", code: "", restriction: "", link: coupon1.link, impression_pixel: coupon1.impression_pixel, image: coupon1.impression_pixel, start_date: "2014-06-20", end_date: "2014-06-25" }, id: coupon1.id, term: "" 
      end
      
      it "sets @coupon to coupon to be patched" do
        expect(assigns(:coupon)).to eq(coupon1)
      end

      it "renders new" do
        expect(response).to redirect_to admin_coupons_path
      end

      it "sets the flash success" do
        expect(flash[:success]).to be_present
      end
    end

    context "term not blank" do
      let(:coupon1) { Fabricate(:coupon) }
      
      before do 
        set_admin_user
        image_url = double("http://image.com")
        allow(KohlsTransactions).to receive(:find_product_image).and_return(image_url)
        #KohlsTransactions.stub(:find_product_image).and_return(image_url)
        patch :update, coupon: {id_of_coupon: coupon1.id_of_coupon, title: coupon1.title, description: coupon1.description, code: coupon1.code, restriction: coupon1.restriction, link: coupon1.link, impression_pixel: coupon1.impression_pixel, image: coupon1.image, start_date: coupon1.start_date, end_date: coupon1.end_date }, id: coupon1.id, term:"hat"
      end

      it "renders new" do
        expect(response).to render_template :new
      end

      it "sets the flash success" do
        expect(flash[:success]).to be_present
      end
    end
  end

  describe "DELETE destroy" do
    context "coupon is removed" do
      let(:coupon1) { Fabricate(:coupon) }
      
      before do 
        set_admin_user
        get :destroy, id: coupon1.id
      end
      
      it "destroys coupon" do
        expect(Coupon.count).to eq(0)
      end

      it "redirects to index" do
        expect(response).to redirect_to admin_coupons_path
      end

      it "sets the flash success" do
        expect(flash[:success]).to be_present
      end

      it "creates new removed coupon" do
        expect(RemovedCoupon.count).to eq(1)
      end
    end
    context "removed coupon is not saved" do
      let(:coupon1) { Fabricate(:coupon) }
      
      before do 
        set_admin_user
        coupon1.update_columns(id_of_coupon: nil)
        get :destroy, id: coupon1.id
      end

      it "does not destroys coupon" do
        expect(Coupon.count).to eq(1)
      end

      it "renders index" do
        expect(response).to render_template :index
      end

      it "sets the flash danger" do
        expect(flash[:danger]).to be_present
      end

      it "does not creates new removed coupon" do
        expect(RemovedCoupon.count).to eq(0)
      end

    end 
  end

  describe "GET index" do
    let!(:coupon1) { coupon1 = Fabricate(:coupon, code: 'BUYNOW', description: 'good car', end_date: Time.now + 2.hour ) }
    let!(:coupon2) { coupon2 = Fabricate(:coupon, code: nil, description: 'fast car', end_date: Time.now + 3.hour ) }
    let!(:coupon3) { coupon3 = Fabricate(:coupon, code: nil, description: 'fast dog', end_date: Time.now + 1.hour ) }
    before do 
      set_admin_user
      get :index
    end

    it "@coupon has 3 coupons" do    
      expect(assigns(:coupons).count).to eq(3)   
    end

    it "@coupon_count = 3" do
      expect(assigns(:coupon_count)).to eq(3)
    end

    it "puts in right order" do
      expect(assigns(:coupons)).to eq([coupon3, coupon1, coupon2])
    end
  end

  describe "GET get_kohls_coupons" do
    context "it does not get any new coupons" do
      before do
        set_admin_user
        allow(KohlsTransactions).to receive(:kohls_update_coupons).and_return(:null)
        #KohlsTransactions.stub(:kohls_update_coupons).and_return()
        get :get_kohls_coupons
      end

      it "sets flash to danger" do
        expect(flash[:danger]).to be_present
      end

      it "redirect to admin page" do
        expect(response).to redirect_to admin_coupons_path
      end
    end

    context "it gets new coupons" do
=begin
      let!(:cat1) { Fabricate(:category, ls_id: 1 ) }
      let!(:cat2) { Fabricate(:category, ls_id: 5 ) }
      let!(:cat3) { Fabricate(:category, ls_id: 20 ) }
      let!(:ctype1) { Fabricate(:ctype, ls_id: 1) }
      let!(:ctype2) { Fabricate(:ctype, ls_id: 2) }
      let!(:ctype3) { Fabricate(:ctype, ls_id: 11) }
=end
      let!(:ktype1) { Fabricate(:kohls_type, kc_id: 5) }
      let!(:ktype2) { Fabricate(:kohls_type, kc_id: 20) }
      let!(:ktype3) { Fabricate(:kohls_type, kc_id: 6) }
      #let!(:konly1) { Fabricate(:kohls_only, kc_id: 1) }
      #let!(:konly2) { Fabricate(:kohls_only, kc_id: 2) }
      let!(:kcat1) { Fabricate(:kohls_category, kc_id: 1) }
      let!(:kcat2) { Fabricate(:kohls_category, kc_id: 2) }
      let!(:kcat3) { Fabricate(:kohls_category, kc_id: 6) }

      #let!(:store1) { Fabricate(:store, id_of_store: 38605) }
      
      before do
        set_admin_user
        xml_response = <<-XML
        <ns1:getTextLinksResponse xmlns:ns1="http://endpoint.linkservice.linkshare.com/"><ns1:return><ns1:campaignID>0</ns1:campaignID><ns1:categoryID>200334758</ns1:categoryID><ns1:categoryName>Homepage</ns1:categoryName><ns1:linkID>4134</ns1:linkID><ns1:linkName>Apparel buy one get one</ns1:linkName><ns1:mid>38605</ns1:mid><ns1:nid>1</ns1:nid><ns1:clickURL>http://click.linksynergy.com/fs-bin/click?id=V8uMkWlCTes&amp;offerid=328293.4134&amp;type=3</ns1:clickURL><ns1:endDate> </ns1:endDate><ns1:landURL>http://www.kohls.com/catalog.jsp?N=3000061747</ns1:landURL><ns1:showURL>http://ad.linksynergy.com/fs-bin/show?id=V8uMkWlCTes&amp;bids=328293.4134&amp;type=3</ns1:showURL><ns1:startDate>Jun 02, 2014</ns1:startDate><ns1:textDisplay>Apparel</ns1:textDisplay></ns1:return></ns1:getTextLinksResponse>
        XML
        stub_request(
          :get,
          "http://lld2.linksynergy.com/services/restLinks/getTextLinks/e1b43458f742b15f89715dd8824a1c6ce3bb328f12624c34f3c08eb2de4ad007/38605/-1//#{Time.now.strftime("%m%d%Y")}/-1/1"         
        ).
        to_return(
          status: 200,
          body: xml_response,
          headers: { "Content-type" => "text/xml; charset=UTF-8" }
        )

        xml_response0 = <<-XML
          <?xml version="1.0" encoding="UTF-8"?><result><TotalMatches>3192</TotalMatches><TotalPages>3192</TotalPages><PageNumber>1</PageNumber><item><mid>38605</mid><merchantname>Kohls</merchantname><linkid>90057354</linkid><createdon>2014-05-04/22:28:14</createdon><sku>90057354</sku><productname> Pyrex Smart Essentials 6-pc. Mixing Bowl Set </productname><category><primary> Home &amp; Garden </primary><secondary>  Kitchen~~Mixing Bowls </secondary></category><price currency="USD">28.99</price><upccode>071160035140</upccode><description><short>Pyrex at Kohl's - Shop our selection of food prep and food storage products, including this Pyrex Smart Essentials 6-pc. Mixing Bowl Set, at Kohls.com.</short><long>Pyrex at Kohl's - Shop our selection of food prep and food storage products, including this Pyrex Smart Essentials 6-pc. Mixing Bowl Set, at Kohls.com.</long></description><saleprice currency="USD">28.99</saleprice><keywords>Pyrex Smart Essentials 6-pc. Mixing Bowl Set~~ food storage~~ food prep~~ pyrex~~ glass~~ bakeware~~ kohls</keywords><linkurl>http://click.linksynergy.com/link?id=V8uMkWlCTes&amp;offerid=328293.90057354&amp;type=15&amp;murl=http%3A%2F%2Fwww.kohls.com%2Fproduct%2Fprd-451332%2FPyrex-Smart-Essentials-6-pc-Mixing-Bowl-Set.jsp</linkurl><imageurl>http://media.kohls.com.edgesuite.net/is/image/kohls/451332?wid=800&amp;hei=800&amp;op_sharpen=1</imageurl></item></result>
          XML
          stub_request(
            :get,
            "http://productsearch.linksynergy.com/productsearch?max=1&mid=38605&one=apparel%20homepage&token=e1b43458f742b15f89715dd8824a1c6ce3bb328f12624c34f3c08eb2de4ad007"

          ).
          to_return(
            status: 200,
            body: xml_response0,
            headers: { "Content-type" => "text/xml; charset=UTF-8" }
          )
        
        get :get_kohls_coupons
      end

      it "sets flash to success" do
        expect(flash[:success]).to be_present
      end

      it "set flash message" do
        expect(flash[:success]).to eq("Kohls Coupons are updated, you imported 1 coupons.")
      end

      it "redirect to admin page" do
        expect(response).to redirect_to admin_coupons_path
      end 
    end
  end

  describe "GET delete_kohls_coupons" do
    context "coupons to delete" do
      let!(:coupon1) { coupon1 = Fabricate(:coupon, code: 'BUYNOW', description: 'good car', end_date: Time.now - 2.day ) }
      let!(:coupon2) { coupon2 = Fabricate(:coupon, code: nil, description: 'fast car', end_date: Time.now - 3.day ) }
      let!(:coupon3) { coupon3 = Fabricate(:coupon, code: nil, description: 'fast dog', end_date: Time.now + 1.hour ) }
      
      before do
        set_admin_user
        get :delete_kohls_coupons
      end

      it "have 1 coupon of the 3 left" do
        expect(Coupon.count).to eq(1)
      end

      it "sets flash to success" do
        expect(flash[:success]).to be_present
      end

      it "set flash message" do
        expect(flash[:success]).to eq("Deleted 2 coupons.")
      end

      it "redirect to admin page" do
        expect(response).to redirect_to admin_coupons_path
      end 
    end
    context "no coupons to delete" do
      let!(:coupon1) { coupon1 = Fabricate(:coupon, code: 'BUYNOW', description: 'good car', end_date: Time.now + 2.day ) }
      let!(:coupon2) { coupon2 = Fabricate(:coupon, code: nil, description: 'fast car', end_date: Time.now + 3.day ) }
      let!(:coupon3) { coupon3 = Fabricate(:coupon, code: nil, description: 'fast dog', end_date: Time.now + 1.hour ) }
      
      before do
        set_admin_user
        get :delete_kohls_coupons
      end
      it "have 3 coupon of the 3 left" do
        expect(Coupon.count).to eq(3)
      end

      it "sets flash to success" do
        expect(flash[:success]).to be_present
      end

      it "set flash message" do
        expect(flash[:success]).to eq("Deleted 0 coupons.")
      end

      it "redirect to admin page" do
        expect(response).to redirect_to admin_coupons_path
      end 
    end
  end

  describe "GET get_mailer_kohls_coupons" do
    (1..7).each do |i|
      let!("coupon#{i}".to_sym) { Fabricate(:coupon, title: "coupon#{i}", code: "COUP#{i}", end_date: Time.now + i.day ) }
    end

    (8..9).each do |i|
      let!("coupon#{i}".to_sym) { Fabricate(:coupon, title: "coupon#{i}", code: "COUP#{i}", end_date: Time.now - i.day ) }
    end

    (10..16).each do |i|
      let!("coupon#{i}".to_sym) { Fabricate(:coupon, title: "coupon#{i}",code: nil, end_date: Time.now + i.day ) }
    end

    (17..19).each do |i|
      let!("coupon#{i}".to_sym) { Fabricate(:coupon, title: "coupon#{i}",code: nil, end_date: Time.now - i.day ) }
    end

    before do
      set_admin_user
      get :get_mailer_kohls_coupons
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "sets @codes_coupons" do
      expect(assigns(:codes_coupons).count).to eq(5)
    end

    it "newest @codes_coupons" do
      expect(assigns(:codes_coupons)).to eq([ coupon1, coupon2, coupon3, coupon4, coupon5 ])
    end

    it "sets @offers_coupons" do
      expect(assigns(:offers_coupons).count).to eq(5)
    end

    it "newest @offers_coupons" do
      expect(assigns(:offers_coupons)).to eq([ coupon10, coupon11, coupon12, coupon13, coupon14 ])
    end
  end

  describe "POST get_keywords" do
    
    it "sets what kohls area type cat | type | only" do
      
    end
  end
end