require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the CouponsHelper. For example:
#
# describe CouponsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe CouponsHelper, type: :helper do
  #include CarrierWave::Test::Matchers
  before do
    #CouponImageUploader.enable_processing = true
    helper.extend Haml
    helper.extend Haml::Helpers 
    helper.send :init_haml_helpers
  end
=begin
  after do
    CouponImageUploader.enable_processing = false
    uploader.remove!
  end
=end

  let(:coupon1) { Fabricate(:coupon, end_date: Time.now + 3.hour, start_date: Time.now - 12.hour, code: "CARS") }
  let(:coupon2) { Fabricate(:coupon, end_date: Time.now + 3.hour, start_date: Time.now - 12.hour, image: nil) }


  describe "#button_link" do
    
    it "displays coupon link button" do
      expect(helper.button_link(coupon1)).to eq("<a class=\"btn btn-primary link_button\" rel=\"nofollow\" target=\"_blank\" href=\"http://test.host/coupons/#{coupon1.slug}/coupon_link\">Shop Now\n<span class='glyphicon glyphicon-chevron-right'></span>\n</a>")
    end
  end

  describe "#time_left_display" do
    it "displays correct time left" do
      expect(helper.time_left_display(coupon1)).to eq("<span class='label label-danger'>\n  <span class='glyphicon glyphicon-time'></span>\n  Expires in about 3 hours\n</span>\n")
    end
  end

  describe "#product_image" do
    it "displays correct image w/ image" do
      expect(helper.product_image(coupon1)).to eq("<img class=\"img-circle\" alt=\"#{coupon1.title}\" src=\"\" width=\"125\" height=\"125\" />")
    end

    it "displays correct image w/o image" do
      expect(helper.product_image(coupon2)).to eq("<img class=\"img-circle\" alt=\"#{coupon2.title}\" src=\"\" width=\"125\" height=\"125\" />")
    end
  end

  describe "#not_released" do
    it "returns not released box" do
      expect(helper.not_released(coupon2)).to eq("<span class='label label-info'>\n  <span class='glyphicon glyphicon-time'></span>\n  Valid in about 12 hours\n</span>\n")
    end
  end
  let(:cat) { Fabricate(:kohls_category) }
  describe "#category_links" do
    let(:cat) { Fabricate(:kohls_category) }
    before { coupon1.kohls_categories << cat }
    it "returns link to categories" do
      expect(helper.category_links(coupon1)).to eq("<a href=\"http://test.host/kohls_categories/#{cat.name}\">#{cat.name}</a>\n")
    end
  end

  describe "#reveal_code_button" do
    it "returns Reveal Code button" do
      expect(helper.reveal_code_button(coupon1)).to eq("<a class=\"btn btn-default btn-xs\" id=\"coupon_reveal_button_#{coupon1.id}\" rel=\"nofollow\" data-remote=\"true\" data-method=\"get\" href=\"http://test.host/coupons/#{coupon1.slug}/reveal_code_link\">Reveal Code\n</a>")
    end
  end

end
