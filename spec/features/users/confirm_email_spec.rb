#feature: confirm
# as a user
# visit confirm address with key

feature 'confirm email', :devise do

  describe 'valid confirmation token' do
    let(:user) { Fabricate(:user, confirmed_at: nil ) }

    scenario 'user validates email' do
      visit  user_confirmation_path(confirmation_token: user.confirmation_token)
      expect(page).to have_text "Your email address has been successfully confirmed."
    end
  end

  describe 'not valid confirmation token' do
    let(:user) { Fabricate(:user, confirmed_at: nil ) }

    scenario 'user email not validated' do
      visit  user_confirmation_path(confirmation_token: 'badtoken')
      expect(page).to have_text "Resend confirmation instructions 1 error prohibited this user from being saved: Confirmation token is invalid"
    end
  end
end