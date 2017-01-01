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
  
  let(:coupon1) { Fabricate(:coupon, end_date: Time.now + 3.hour, start_date: Time.now - 12.hour) }

  before do
    helper.extend Haml
    helper.extend Haml::Helpers 
    helper.send :init_haml_helpers
  end

  describe "#button_link" do
    
    it "displays coupon link button" do
      expect(helper.button_link(coupon1)).to eq("<a class=\"btn btn-primary link_button\" rel=\"nofollow\" target=\"_blank\" href=\"#{coupon1.link}\">Shop Now\n<span class='glyphicon glyphicon-chevron-right'></span>\n</a>")
    end
  end

  describe "#time_left_display" do
    it "displays correct time left" do
      expect(helper.time_left_display(coupon1)).to eq("<span class='label label-danger'>\n  <span class='glyphicon glyphicon-time'></span>\n  Expires in about 3 hours\n</span>\n")
    end
  end

  describe "#product_image" do
  end

  describe "#not_released" do
  end

  describe "#category_links" do
  end

end
