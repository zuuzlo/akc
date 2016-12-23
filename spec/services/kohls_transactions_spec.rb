require 'spec_helper'
require "recursive_open_struct"

describe KohlsTransactions do
  describe "kohls_update_coupons" do
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
    let!(:ktype4) { Fabricate(:kohls_type, kc_id: 4) }
    let!(:ktype5) { Fabricate(:kohls_type, kc_id: 2) }
    let!(:konly1) { Fabricate(:kohls_only, kc_id: 1) }
    let!(:konly2) { Fabricate(:kohls_only, kc_id: 2) }
    let!(:kcat1) { Fabricate(:kohls_category, kc_id: 1) }
    let!(:kcat2) { Fabricate(:kohls_category, kc_id: 2) }
    let!(:kcat3) { Fabricate(:kohls_category, kc_id: 6) }

    #let!(:store1) { Fabricate(:store, id_of_store: 38605) }

    before do
      xml_response = <<-XML
        <ns1:getTextLinksResponse xmlns:ns1="http://endpoint.linkservice.linkshare.com/"><ns1:return><ns1:campaignID>0</ns1:campaignID><ns1:categoryID>200334758</ns1:categoryID><ns1:categoryName>Homepage</ns1:categoryName><ns1:linkID>4134</ns1:linkID><ns1:linkName>Apparel buy one get one</ns1:linkName><ns1:mid>38605</ns1:mid><ns1:nid>1</ns1:nid><ns1:clickURL>http://click.linksynergy.com/fs-bin/click?id=V8uMkWlCTes&amp;offerid=328293.4134&amp;type=3</ns1:clickURL><ns1:endDate> </ns1:endDate><ns1:landURL>http://www.kohls.com/catalog.jsp?N=3000061747</ns1:landURL><ns1:showURL>http://ad.linksynergy.com/fs-bin/show?id=V8uMkWlCTes&amp;bids=328293.4134&amp;type=3</ns1:showURL><ns1:startDate>Jun 02, 2014</ns1:startDate><ns1:textDisplay>Apparel</ns1:textDisplay></ns1:return><ns1:return><ns1:campaignID>0</ns1:campaignID><ns1:categoryID>200334760</ns1:categoryID><ns1:categoryName>Men</ns1:categoryName><ns1:linkID>4135</ns1:linkID><ns1:linkName>car</ns1:linkName><ns1:mid>38605</ns1:mid><ns1:nid>1</ns1:nid><ns1:clickURL>http://click.linksynergy.com/fs-bin/click?id=V8uMkWlCTes&amp;offerid=328293.4135&amp;type=3</ns1:clickURL><ns1:endDate>Jun 04, 2014</ns1:endDate><ns1:landURL>http://www.kohls.com/catalog/mens.jsp?CN=4294723349&amp;N=4294723349+3000061849</ns1:landURL><ns1:showURL>http://ad.linksynergy.com/fs-bin/show?id=V8uMkWlCTes&amp;bids=328293.4135&amp;type=3</ns1:showURL><ns1:startDate>Jun 02, 2014</ns1:startDate><ns1:textDisplay>car buy one get one</ns1:textDisplay></ns1:return><ns1:return><ns1:campaignID>0</ns1:campaignID><ns1:categoryID>0</ns1:categoryID><ns1:categoryName>Default</ns1:categoryName><ns1:linkID>4247</ns1:linkID><ns1:linkName>Dad's Day Sale</ns1:linkName><ns1:mid>38605</ns1:mid><ns1:nid>1</ns1:nid><ns1:clickURL>http://click.linksynergy.com/fs-bin/click?id=V8uMkWlCTes&amp;offerid=328293.4247&amp;type=3</ns1:clickURL><ns1:endDate>Jun 12, 2014</ns1:endDate><ns1:landURL>http://www.kohls.com/</ns1:landURL><ns1:showURL>http://ad.linksynergy.com/fs-bin/show?id=V8uMkWlCTes&amp;bids=328293.4247&amp;type=3</ns1:showURL><ns1:startDate>Jun 04, 2014</ns1:startDate><ns1:textDisplay>15% off Everything with Code SUNNY15. Grills conrad 6/4-6/11</ns1:textDisplay></ns1:return></ns1:getTextLinksResponse>
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
        <ns1:getTextLinksResponse xmlns:ns1="http://endpoint.linkservice.linkshare.com/"><ns1:return><ns1:campaignID>0</ns1:campaignID><ns1:categoryID>200334758</ns1:categoryID><ns1:categoryName>Homepage</ns1:categoryName><ns1:linkID>4134</ns1:linkID><ns1:linkName>Apparel buy one get one</ns1:linkName><ns1:mid>38605</ns1:mid><ns1:nid>1</ns1:nid><ns1:clickURL>http://click.linksynergy.com/fs-bin/click?id=V8uMkWlCTes&amp;offerid=328293.4134&amp;type=3</ns1:clickURL><ns1:endDate> </ns1:endDate><ns1:landURL>http://www.kohls.com/catalog.jsp?N=3000061747</ns1:landURL><ns1:showURL>http://ad.linksynergy.com/fs-bin/show?id=V8uMkWlCTes&amp;bids=328293.4134&amp;type=3</ns1:showURL><ns1:startDate>Jun 02, 2014</ns1:startDate><ns1:textDisplay>Apparel</ns1:textDisplay></ns1:return><ns1:return><ns1:campaignID>0</ns1:campaignID><ns1:categoryID>200334760</ns1:categoryID><ns1:categoryName>Men</ns1:categoryName><ns1:linkID>4135</ns1:linkID><ns1:linkName>car</ns1:linkName><ns1:mid>38605</ns1:mid><ns1:nid>1</ns1:nid><ns1:clickURL>http://click.linksynergy.com/fs-bin/click?id=V8uMkWlCTes&amp;offerid=328293.4135&amp;type=3</ns1:clickURL><ns1:endDate>Jun 04, 2014</ns1:endDate><ns1:landURL>http://www.kohls.com/catalog/mens.jsp?CN=4294723349&amp;N=4294723349+3000061849</ns1:landURL><ns1:showURL>http://ad.linksynergy.com/fs-bin/show?id=V8uMkWlCTes&amp;bids=328293.4135&amp;type=3</ns1:showURL><ns1:startDate>Jun 02, 2014</ns1:startDate><ns1:textDisplay>car buy one get one</ns1:textDisplay></ns1:return><ns1:return><ns1:campaignID>0</ns1:campaignID><ns1:categoryID>0</ns1:categoryID><ns1:categoryName>Default</ns1:categoryName><ns1:linkID>4247</ns1:linkID><ns1:linkName>Dad's Day Sale</ns1:linkName><ns1:mid>38605</ns1:mid><ns1:nid>1</ns1:nid><ns1:clickURL>http://click.linksynergy.com/fs-bin/click?id=V8uMkWlCTes&amp;offerid=328293.4247&amp;type=3</ns1:clickURL><ns1:endDate>Jun 12, 2014</ns1:endDate><ns1:landURL>http://www.kohls.com/</ns1:landURL><ns1:showURL>http://ad.linksynergy.com/fs-bin/show?id=V8uMkWlCTes&amp;bids=328293.4247&amp;type=3</ns1:showURL><ns1:startDate>Jun 04, 2014</ns1:startDate><ns1:textDisplay>15% off Everything with Code SUNNY15. Grills conrad 6/4-6/11</ns1:textDisplay></ns1:return></ns1:getTextLinksResponse>
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

      xml_response1 = <<-XML
        <?xml version="1.0" encoding="UTF-8"?><result><TotalMatches>-1</TotalMatches><TotalPages>4000</TotalPages><PageNumber>1</PageNumber><item><mid>38605</mid><merchantname>Kohls</merchantname><linkid>93603004</linkid><createdon>2014-04-04/23:03:42</createdon><sku>93603004</sku><productname> Game Time Beast Series Carolina Panthers Stainless Steel Watch - NFL-BEA-CAR - Men </productname><category><primary> Jewelry </primary><secondary>  Watches~~Watches </secondary></category><price currency="USD">60</price><upccode>846043077988</upccode><description><short>Game Time watches at Kohl's - This men's stainless steel watch features a Carolina Panthers logo and an adjustable black band. Model no. NFL-BEA-CAR. Shop our full line of watches at Kohls.com.</short><long>Game Time watches at Kohl's - This men's stainless steel watch features a Carolina Panthers logo and an adjustable black band. Model no. NFL-BEA-CAR. Shop our full line of watches at Kohls.com.</long></description><saleprice currency="USD">48</saleprice><keywords>Game Time Beast Series Carolina Panthers Stainless Steel Watch~~ NFL-BEA-CAR~~ NFL~~ football~~ sports~~ watches~~ timepiece~~ clocks~~ luxury watch~~ chronograph~~ stopwatch~~ automatic watch~~ fashion watch~~ jewelry watch~~ kohls</keywords><linkurl>http://click.linksynergy.com/link?id=V8uMkWlCTes&amp;offerid=328293.93603004&amp;type=15&amp;murl=http%3A%2F%2Fwww.kohls.com%2Fproduct%2Fprd-1275841%2FGame-Time-Beast-Series-Carolina-Panthers-Stainless-Steel-Watch-NFL-BEA-CAR-Men.jsp</linkurl><imageurl>http://media.kohls.com.edgesuite.net/is/image/kohls/1275841?wid=800&amp;hei=800&amp;op_sharpen=1</imageurl></item></result>
      XML

      stub_request(
        :get,
        "http://productsearch.linksynergy.com/productsearch?max=1&mid=38605&one=car%20men&token=e1b43458f742b15f89715dd8824a1c6ce3bb328f12624c34f3c08eb2de4ad007"
      ).
      to_return(
        status: 200,
        body: xml_response1,
        headers: { "Content-type" => "text/xml; charset=UTF-8" }
      )

      xml_response2 = <<-XML
        <?xml version="1.0" encoding="UTF-8"?><result><TotalMatches>-1</TotalMatches><TotalPages>4000</TotalPages><PageNumber>1</PageNumber><item><mid>38605</mid><merchantname>Kohls</merchantname><linkid>95174404</linkid><createdon>2014-05-02/22:40:39</createdon><sku>95174404</sku><productname> New View ''Best Dads'' Wall Plaque </productname><category><primary> Home &amp; Garden </primary><secondary>  Home Furnishings~~Wall Decor </secondary></category><price currency="USD">9.99</price><upccode>606683754324</upccode><description><short>Wall Art at Kohl's - Shop our full selection of wall art, including this, New View ''Best Dads'' Wall Plaque, at Kohl's.</short><long>Wall Art at Kohl's - Shop our full selection of wall art, including this, New View ''Best Dads'' Wall Plaque, at Kohl's.</long></description><saleprice currency="USD">5.99</saleprice><keywords>kohls</keywords><linkurl>http://click.linksynergy.com/link?id=V8uMkWlCTes&amp;offerid=328293.95174404&amp;type=15&amp;murl=http%3A%2F%2Fwww.kohls.com%2Fproduct%2Fprd-1719226%2FNew-View-Best-Dads-Wall-Plaque.jsp</linkurl><imageurl>http://media.kohls.com.edgesuite.net/is/image/kohls/1719226?wid=800&amp;hei=800&amp;op_sharpen=1</imageurl></item></result>
      XML

      stub_request(
        :get,
        "http://productsearch.linksynergy.com/productsearch?max=1&mid=38605&one=dads%20day%20sale%20sunny%20grills%20conrad%20default&token=e1b43458f742b15f89715dd8824a1c6ce3bb328f12624c34f3c08eb2de4ad007"
      ).
      to_return(
        status: 200,
        body: xml_response2,
        headers: { "Content-type" => "text/xml; charset=UTF-8" }
      )
    end

    context "id is not existing coupon" do
      before do
        LsLinkdirectAPI.token = ENV["LINKSHARE_TOKEN"]
        allow(KohlsTransactions).to receive(:find_product_image).and_return( "http://image_url.com" )
        #KohlsTransactions.stub(:find_product_image) { "http://image_url.com" }
        KohlsTransactions.kohls_update_coupons
      end

      it "creates new coupon" do      
        expect(Coupon.count).to eq(3)
      end

      it "adds endDate if it does not exist" do
        expect(Coupon.first.end_date.strftime("%m%d%Y")).to eq((DateTime.now + 5.years).strftime("%m%d%Y"))
      end

      it "adds coupon to kohls_category" do
        expect(Coupon.last.kohls_categories).to eq([kcat1])
      end

      it "adds coupon to kohls_types" do
        expect(Coupon.last.kohls_types).to eq([ktype3, ktype4, ktype5])
      end

      it "adds coupon to kohls_only" do
        expect(Coupon.last.kohls_onlies).to eq([konly1])
      end
      
      it "has coupon code" do
        expect(Coupon.last.code).to eq("SUNNY15")
      end

      it "does not have coupon code" do
        expect(Coupon.first.code).to be_nil
      end
    end
    context "is an existing coupon" do
      let!(:coupon1) { Fabricate(:coupon, title:"new coat", id_of_coupon: 4134) }

      before do
        LsLinkdirectAPI.token = ENV["LINKSHARE_TOKEN"]
        KohlsTransactions.kohls_update_coupons
      end

      it "does not create new coupon" do
        expect(Coupon.count).to eq(3)
      end

      it "first coupon title is 'new coat'" do
        expect(Coupon.first.title).to eq("new coat")
      end
    end

    context "coupon has been removed" do
      let!(:removed_coupon1) { Fabricate(:removed_coupon, id_of_coupon: 4134) }

      it "should not create new coupon" do
        LsLinkdirectAPI.token = ENV["LINKSHARE_TOKEN"]
        allow(KohlsTransactions).to receive(:find_product_image).and_return( "http://image_url.com" )
        #KohlsTransactions.stub(:find_product_image) { "http://image_url.com" }
        KohlsTransactions.kohls_update_coupons    
        expect(Coupon.count).to eq(2)
      end
    end
  end

  describe "find_kohls_cat" do

    it "returns category 1 for term patio" do
      expect(KohlsTransactions.find_kohls_cat('patio')).to eq([1])
    end

    it "returns category 12 for term ncaa" do
      expect(KohlsTransactions.find_kohls_cat('NCAA')).to eq([12])
    end

    it "returns category 4 if no other category is found and it is clothes" do
      expect(KohlsTransactions.find_kohls_cat('coats')).to eq([4])
    end

    it "returns multiple categories for nfl women tees" do
      expect(KohlsTransactions.find_kohls_cat('nfl women tees')).to eq([4,12])
    end

    it "returns 6 for men" do
      expect(KohlsTransactions.find_kohls_cat('men tees')).to eq([6])
    end

    it "returns nothing for garbage i am a great thing" do
      expect(KohlsTransactions.find_kohls_cat('I am a great thing')).to eq([])
    end

    it "returns category num one time for nfl ncaa" do
      expect(KohlsTransactions.find_kohls_cat('big nfl ncaa i am a player')).to eq([12])
    end
  end

  describe "find_kohls_only" do
    it "returns 1 for lauren Conrad" do
      expect(KohlsTransactions.find_kohls_only('lauren Conrad')).to eq([1])
    end

    it "returns nothing for hello world" do
      expect(KohlsTransactions.find_kohls_only('hello world')).to eq([])
    end
  end

  describe "find_kohls_type" do
    it "returns 5 for nothing" do
      expect(KohlsTransactions.find_kohls_type('hello world')).to eq([5])
    end

    it "returns 1 for $" do
      expect(KohlsTransactions.find_kohls_type('save $50 on new cat')).to eq([1])
    end

    it "returns 2 for % off" do
      expect(KohlsTransactions.find_kohls_type('50% off today only')).to eq([2])
    end

    it "returns 3 for free shipping" do
      expect(KohlsTransactions.find_kohls_type('today only free shipping')).to eq([3])
    end

    it "returns 4 for Code" do
      expect(KohlsTransactions.find_kohls_type('Save with code SUNNY50')).to eq([4])
    end

    it "returns 6 for sitewide" do
      expect(KohlsTransactions.find_kohls_type('today only sitewide')).to eq([6])
    end
  end

  describe "find_coupon_code" do
    it "returns nil if no code found" do
      expect(KohlsTransactions.find_coupon_code('hello world')).to eq(nil)
    end

    it "returns coupon code if present" do
      expect(KohlsTransactions.find_coupon_code('Extra 15% off All Nunn Bush shoes and sandals. Promo code NUNNBUSH15. 6/9-6/23')).to eq('NUNNBUSH15')
    end
  end

  describe "find_product_image" do
    context "returns product" do
      before do
        xml_response = <<-XML
          <?xml version="1.0" encoding="UTF-8"?><result><TotalMatches>3192</TotalMatches><TotalPages>3192</TotalPages><PageNumber>1</PageNumber><item><mid>38605</mid><merchantname>Kohls</merchantname><linkid>90057354</linkid><createdon>2014-05-04/22:28:14</createdon><sku>90057354</sku><productname> Pyrex Smart Essentials 6-pc. Mixing Bowl Set </productname><category><primary> Home &amp; Garden </primary><secondary>  Kitchen~~Mixing Bowls </secondary></category><price currency="USD">28.99</price><upccode>071160035140</upccode><description><short>Pyrex at Kohl's - Shop our selection of food prep and food storage products, including this Pyrex Smart Essentials 6-pc. Mixing Bowl Set, at Kohls.com.</short><long>Pyrex at Kohl's - Shop our selection of food prep and food storage products, including this Pyrex Smart Essentials 6-pc. Mixing Bowl Set, at Kohls.com.</long></description><saleprice currency="USD">28.99</saleprice><keywords>Pyrex Smart Essentials 6-pc. Mixing Bowl Set~~ food storage~~ food prep~~ pyrex~~ glass~~ bakeware~~ kohls</keywords><linkurl>http://click.linksynergy.com/link?id=V8uMkWlCTes&amp;offerid=328293.90057354&amp;type=15&amp;murl=http%3A%2F%2Fwww.kohls.com%2Fproduct%2Fprd-451332%2FPyrex-Smart-Essentials-6-pc-Mixing-Bowl-Set.jsp</linkurl><imageurl>http://media.kohls.com.edgesuite.net/is/image/kohls/451332?wid=800&amp;hei=800&amp;op_sharpen=1</imageurl></item></result>
        XML
        stub_request(
          :get,
          "http://productsearch.linksynergy.com/productsearch?max=1&mid=38605&one=pyrex%20corningware%20food%20prep&token=e1b43458f742b15f89715dd8824a1c6ce3bb328f12624c34f3c08eb2de4ad007"
        ).
        to_return(
          status: 200,
          body: xml_response,
          headers: { "Content-type" => "text/xml; charset=UTF-8" }
        )

        xml_response0 = <<-XML
          <?xml version="1.0" encoding="UTF-8"?><result><TotalMatches>-1</TotalMatches><TotalPages>4000</TotalPages><PageNumber>1</PageNumber><item><mid>38605</mid><merchantname>Kohls</merchantname><linkid>93465027</linkid><createdon>2013-11-05/17:34:49</createdon><sku>93465027</sku><productname> Monarch TV Console </productname><category><primary> Home &amp; Garden </primary><secondary>  Furniture~~Entertainment Centers and Stands </secondary></category><price currency="USD">854.99</price><upccode>021032247713</upccode><description><short>Furniture at Kohls.com - Shop our full selection of furniture, including this Monarch TV Console, at Kohls.com. Model no. Furniture at Kohls.com - Shop our full selection of furniture, including this Monarch TV Console, at Kohls.com. Model no. I 3541..</short><long>Furniture at Kohls.com - Shop our full selection of furniture, including this Monarch TV Console, at Kohls.com. Model no. Furniture at Kohls.com - Shop our full selection of furniture, including this Monarch TV Console, at Kohls.com. Model no. I 3541..</long></description><saleprice currency="USD">854.99</saleprice><keywords>Monarch TV Console~~ I 3541~~ tv console~~ tv stand~~ television console~~ television stand~~ media stand~~ entertainment stand~~ Monarch~~ furniture~~ chairs~~ bedroom furniture~~ living room furniture~~ bench~~ outdoor furniture~~ patio furniture~~ furniture outdoor~~ dining furniture~~ kitchen furniture~~ kohls~~ kohls.com</keywords><linkurl>http://click.linksynergy.com/link?id=V8uMkWlCTes&amp;offerid=328293.93465027&amp;type=15&amp;murl=http%3A%2F%2Fwww.kohls.com%2Fproduct%2Fprd-1242523%2FMonarch-TV-Console.jsp</linkurl><imageurl>http://media.kohls.com.edgesuite.net/is/image/kohls/1242523?wid=800&amp;hei=800&amp;op_sharpen=1</imageurl></item></result>
        XML
        stub_request(
          :get,
          "http://productsearch.linksynergy.com/productsearch?max=1&mid=38605&one=kohls&token=e1b43458f742b15f89715dd8824a1c6ce3bb328f12624c34f3c08eb2de4ad007"
        ).
        to_return(
          status: 200,
          body: xml_response0,
          headers: { "Content-type" => "text/xml; charset=UTF-8" }
        )
      end

      it "returns product image" do 
        LinkshareAPI.token = ENV["LINKSHARE_TOKEN"]
        expect(KohlsTransactions.find_product_image("pyrex corningware food prep")).to eq("http://media.kohls.com.edgesuite.net/is/image/kohls/451332?wid=800&hei=800&op_sharpen=1")
      end

      it "returns something if no keywords" do
        LinkshareAPI.token = ENV["LINKSHARE_TOKEN"]
        expect(KohlsTransactions.find_product_image("")).to eq("http://media.kohls.com.edgesuite.net/is/image/kohls/1242523?wid=800&hei=800&op_sharpen=1")
      end
    end

    context "doesn't return products" do
      before do
        xml_response = <<-XML
          <?xml version="1.0" encoding="UTF-8"?><result><TotalMatches>0</TotalMatches><TotalPages>0</TotalPages><PageNumber>1</PageNumber></result>
        XML
        stub_request(
          :get,
          "http://productsearch.linksynergy.com/productsearch?max=1&mid=38605&one=sqw&token=e1b43458f742b15f89715dd8824a1c6ce3bb328f12624c34f3c08eb2de4ad007"
        ).
        to_return(
          status: 200,
          body: xml_response,
          headers: { "Content-type" => "text/xml; charset=UTF-8" }
        )
      end

      it "returns nil if no product is found" do
        LinkshareAPI.token = ENV["LINKSHARE_TOKEN"]
        expect(KohlsTransactions.find_product_image("sqw")).to be_nil
      end
    end
  end

  describe "make_title" do
    context "textName equals textDescription" do
      let(:name) { "$14.99 Sleep Sets for women, plus save 60% off Sleepwear for women. Select styles. 7/5-8/1." }
      let(:description) { "$14.99 Sleep Sets for women, plus save 60% off Sleepwear for women. Select styles. 7/5-8/1." }

      it "returns correct title" do
        expect(KohlsTransactions.make_title(name, description)).to eq("")
      end
    end

    context "textName doesn't equals textDescription" do
      context "textName over 50 chars" do
        let(:name) { "Sleep Sets for women" }
        let(:description) { "$14.99 Sleep Sets for women, plus save 60% off Sleepwear for women. Select styles. 7/5-8/1." }

        it "returns correct title" do
          expect(KohlsTransactions.make_title(name, description)).to eq("Sleep Sets For Women")
        end
      end

      context "textName under 50 chars" do
        let(:name) {}
        let(:description) {}

        it "returns correct title" do
          expect(KohlsTransactions.make_title(name, description)).to eq("")
        end
      end
    end
  end

  describe "title_short" do
    context "right split as expected" do
      let(:title) { "$359.99 Roomba 620 Robotic Vacuum. Reg $419.99. 8/24-9/5." }

      it "returns short title" do
        expect(KohlsTransactions.title_short(title)).to eq("$359.99 Roomba 620 Robotic Vacuum")
      end

      it "removes white spaces" do
        expect(KohlsTransactions.title_short(title)).to eq("$359.99 Roomba 620 Robotic Vacuum")
      end
    end

    context "right split at begining" do
      let(:title) { "Reg $359.99 Roomba 620 Robotic Vacuum $419.99. Valid 8/24-9/5." }

      it "returns short title" do
        expect(KohlsTransactions.title_short(title)).to eq("Reg $359.99 Roomba 620 Robotic Vacuum $419.99")
      end
    end

    context "no split word" do
      let(:title) { "Roomba 620 Robotic Vacuum $419.99. " }
      it "returns short title" do
        expect(KohlsTransactions.title_short(title)).to eq("Roomba 620 Robotic Vacuum $419.99")
      end
    end

    context "contains -" do
      let(:title) { "%10-30 off roomba 620 robotic vacuum $419.99. Valid 8/24-9/5." }

      it "returns short title" do
        expect(KohlsTransactions.title_short(title)).to eq("%10 to 30 Off Roomba 620 Robotic Vacuum $419.99")
      end
    end

    context "contains ()" do
      let(:title) { "$479.99 1/5-ct.T.W. Diamond Engagement Ring Set (reg $1199.99)" }

      it "returns title with no ()" do
        expect(KohlsTransactions.title_short(title)).to eq("$479.99 1/5 Ct.T.W. Diamond Engagement Ring Set")
      end
    end
  end
end