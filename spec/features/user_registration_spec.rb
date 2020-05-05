require 'rails_helper'

RSpec.feature 'User registration', type: :feature do
  describe 'sign up' do
    before(:each) do
      visit new_user_registration_path
    end

    describe 'with valid credentials' do
      it 'registers user and redirects to home page' do
        fill_in 'user_email', with: 'user@spec.com'
        fill_in 'user_password', with: 'specspec'
        fill_in 'user_password_confirmation', with: 'specspec'
        click_button 'Sign up'

        expect(page).to have_current_path(root_path)
        expect(page).to have_content('You have signed up successfully')
      end
    end

    describe 'with invalid credentials' do
      it 'shows registration errors' do
        fill_in 'user_email', with: ''
        fill_in 'user_password', with: 'specspec'
        fill_in 'user_password_confirmation', with: 'specspec'
        click_button 'Sign up'

        expect(page).to have_current_path(user_registration_path)
        expect(page).to have_content('can\'t be blank')
      end
    end
  end
end
