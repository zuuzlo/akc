require "rails_helper"

feature 'hide comments' do
  
  describe 'any user' do
    let!(:coupon1) { Fabricate(:coupon, code: 'BUYNOW', description: 'good car', end_date: Time.now + 3.hour ) }
    scenario 'hide comment', js: true do
      visit root_path
      click_link "Comments"
      expect(page).to have_text 'Comment Email Website'
      click_link "Hide Comments"
      expect(page).to have_text 'Comments'
    end
  end
end