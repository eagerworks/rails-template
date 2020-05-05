require 'rails_helper'

RSpec.feature 'User authentication', type: :feature do
  let(:user) { create(:user) }

  describe 'sign in' do
    before(:each) do
      visit new_user_session_path
    end

    describe 'with valid credentials' do
      it 'authenticates user and redirects to home page' do
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: user.password
        click_button 'Log in'

        expect(page).to have_current_path(root_path)
        expect(page).to have_content('Signed in successfully')
      end
    end

    describe 'with invalid credentials' do
      it 'shows authentication errors' do
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: 'wrong password'
        click_button 'Log in'

        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_content('Invalid Email or password')
      end
    end
  end

  describe 'sign out' do
    it 'signs out user and redirects to sign in page' do
      sign_in(user)
      click_link 'Logout'

      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_content('Signed out successfully')
    end
  end
end
