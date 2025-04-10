# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Form::DatePicker, type: :component do
  let(:subscription) { build(:subscription, ends_at: Time.now + 3.days) }
  let(:form) do
    ActionView::Helpers::FormBuilder.new(:subscription, subscription, ActionView::Base.empty, {})
  end

  it 'renders a date picker' do
    render_inline(described_class.new(form: form, name: 'ends_at'))

    expect(page).to have_selector("input[type='text']")
  end

  it 'has the right name' do
    render_inline(described_class.new(form: form, name: 'ends_at'))

    expect(page).to have_selector("input[name='subscription[ends_at]']")
  end

  it 'has the right id' do
    render_inline(described_class.new(form: form, name: 'ends_at'))

    expect(page).to have_selector("input[id='subscription_ends_at']")
  end

  it 'has the right value' do
    render_inline(described_class.new(form: form, name: 'ends_at'))

    expect(page.first('input')['value']).to eq(subscription.ends_at.strftime('%Y-%m-%d'))
  end

  it 'uses %Y-%m-%d as the default format' do
    render_inline(described_class.new(form: form, name: 'ends_at'))

    expect(page.first('input')['x-data']).to eq("datePicker('Y-m-d')")
    expect(page.first('input')['value']).to eq(subscription.ends_at.strftime('%Y-%m-%d'))
  end

  it 'uses the provided format' do
    render_inline(described_class.new(form: form, name: 'ends_at', format: '%d/%m/%Y'))

    expect(page.first('input')['x-data']).to eq("datePicker('d/m/Y')")
    expect(page.first('input')['value']).to eq(subscription.ends_at.strftime('%d/%m/%Y'))
  end

  it 'renders a label' do
    render_inline(described_class.new(form: form, name: 'ends_at'))

    expect(page).to have_selector("label[for='subscription_ends_at']", text: 'Ends At')
  end

  it 'renders a custom label' do
    render_inline(described_class.new(form: form, name: 'ends_at', label: 'Custom Label'))

    expect(page).to have_selector("label[for='subscription_ends_at']", text: 'Custom Label')
  end

  context 'with error' do
    before do
      form.object.errors.add(:ends_at, "can't be blank")
    end

    it 'renders an error message' do
      render_inline(described_class.new(form: form, name: 'ends_at'))

      expect(page).to have_selector('p.text-red-600', text: "Ends at can't be blank")
    end

    it 'applies error styles' do
      render_inline(described_class.new(form: form, name: 'ends_at'))
      expect(page).to have_selector('input.text-red-900')
      expect(page).to have_selector('input.ring-red-300')
      expect(page).to have_selector('input.focus\\:ring-red-600')
      expect(page).to have_selector('input.placeholder\\:text-red-300')
    end
  end
end
