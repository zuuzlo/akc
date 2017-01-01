# Feature: Sign out
#   As a user
#   I want to sign out
#   So I can protect my account from unauthorized access
feature 'Sign out', :devise do

  # Scenario: User signs out successfully
  #   Given I am signed in
  #   When I sign out
  #   Then I see a signed out message
  describe "sign out successfully" do
    let(:user) { Fabricate(:user) }

    scenario 'user signs out successfully' do
      signin(user.email, user.password)
      expect(page).to have_text "Signed in successfully."
      #/html/body/div/header/nav/div[2]/ul[2]/li/ul/li[2]/a
      find(:xpath, '//html/body/div/header/nav/div[2]/ul[2]/li/ul/li[2]/a').click
      #click_link 'Sign out'
      expect(page).to have_text 'Signed out successfully.'
    end
  end
end


