require "rails_helper"

feature 'reveal code' do
  
  describe 'any user' do
    let!(:coupon1) { Fabricate(:coupon, code: 'BUYNOW', description: 'good car', end_date: Time.now + 3.hour ) }
    scenario 'click reveal code', js: true do
      visit root_path
      click_link 'Reveal Code'
      expect(page).to have_text "#{coupon1.code}"
    end
  end
end