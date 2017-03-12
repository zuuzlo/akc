require 'rails_helper'

RSpec.describe "coupons/index.html.haml", type: :view do
  (1..3).each do |i|
      let!("coupon#{i}".to_sym) { Fabricate(:coupon, title: "coupon#{i}", end_date: Time.now - i.hour, start_date: Time.now - 12.hour ) }
    end

  (4..5).each do |i|
    let!("coupon#{i}".to_sym) { Fabricate(:coupon, title: "coupon#{i}", end_date: Time.now + i.hour, start_date: Time.now - 12.hour ) }
  end
=begin
  before do
    allow(view).to receive(:display_ad?).and_return(false)
  end
=end
  it "displays 3 coupons" do
    
    @coupons = Coupon.all
    #allow(view).to receive(:display_ad?).and_return(false)
    render :template => "coupons/index.html.haml", :locals => { :meta_keywords => "hello", :meta_description => "hello" }

    expect(rendered).to match /coupon1/
    expect(rendered).to match /coupon2/
    expect(rendered).to match /coupon3/
  end
end
