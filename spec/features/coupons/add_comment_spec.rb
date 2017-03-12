require "rails_helper"

feature 'add comment' do
  
  describe 'any user' do
    let!(:coupon1) { Fabricate(:coupon, code: 'BUYNOW', description: 'good car', end_date: Time.now + 3.hour ) }
    scenario 'add comment', js: true do
      visit root_path
      click_link "Comments"
      fill_in 'Comment', with: 'here is a comment'
      click_button 'Add Comment'
      expect(coupon1.comments.count).to eq(1)
    end
  end
end