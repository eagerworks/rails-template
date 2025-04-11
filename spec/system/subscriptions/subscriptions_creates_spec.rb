require 'rails_helper'

RSpec.describe 'Subscriptions::Creates', type: :system do
  let!(:plan) { create(:plan, :published) }
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it 'creates a subscription' do
    visit plans_path

    click_on 'Buy plan'
    expect(page).to have_current_path(new_plan_subscription_path(plan))

    within_frame('embedded-checkout') do
      fill_in 'email', with: user.email, wait: 10
      find('button[aria-label="Pay with card"]', visible: false).click(x: 5, y: 5)
      fill_in 'cardNumber', with: '4242424242424242'
      fill_in 'cardExpiry', with: (Date.today + 1.month).strftime('%m/%y')
      fill_in 'cardCvc', with: '123'
      fill_in 'billingName', with: user.full_name
      select 'United States', from: 'billingCountry'
      fill_in 'billingPostalCode', with: '94103'
      click_on 'Subscribe'
    end

    expect(page).to have_current_path('/', wait: 10)
    expect(page).to have_text('Your subscription was successful!')
  end
end
