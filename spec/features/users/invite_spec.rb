

feature 'invite', :devise do
  describe "valid credentials" do
    let(:user) { Fabricate(:user) }

    scenario 'user invites valid email' do
      signin(user.email, user.password)
      find(:xpath, '//html/body/div/header/nav/div[2]/ul[2]/li/ul/li[1]/a').click
      fill_in 'Email', with: 'invided@invite.com'
      click_button 'Send an invitation'
      #require 'pry'; binding.pry
      expect(ActionMailer::Base.deliveries.count).to eq(1)
      expect(ActionMailer::Base.deliveries.first.to).to eq(['invided@invite.com'])
    end
  end

  describe "not valid credentials" do
    scenario 'user invites valid email' do
      visit  new_user_invitation_path
      #find(:xpath, '//html/body/div/header/nav/div[2]/ul[2]/li/ul/li[1]/a').click
      #fill_in 'Email', with: 'invided@invite.com'
      #click_button 'Send an invitation'
      expect(page).to have_text "You need to sign in or sign up before continuing."
    end
  end
end