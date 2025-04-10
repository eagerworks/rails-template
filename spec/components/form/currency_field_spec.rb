require 'rails_helper'

RSpec.describe Form::CurrencyField, type: :component do
  let(:name) { :amount }
  let(:plan) { build(:plan) }
  let(:form) { ActionView::Helpers::FormBuilder.new(:plan, plan, ActionView::Base.empty, {}) }

  it 'renders a text field with basic attributes' do
    render_inline(described_class.new(name: name, form: form))

    expect(page).to have_css('input[type="text"]')
    expect(page).to have_css('input.block')
    expect(page).to have_css('input.w-full')
    expect(page).to have_css('input.rounded-md')
    expect(page).to have_css('input.bg-white')
  end

  describe 'sizing' do
    it 'applies default (md) size styles' do
      render_inline(described_class.new(name: name, form: form))

      expect(page).to have_css('input.px-3')
      expect(page).to have_css('input.py-1\\.5')
      expect(page).to have_css('input.text-base')
      expect(page).to have_css('input.sm\\:text-sm\\/6')
    end

    it 'adjusts styles for large size' do
      render_inline(described_class.new(name: name, size: 'lg', form: form))

      expect(page).to have_css('input.text-base')
      expect(page).to have_css('input.sm\\:text-sm\\/6')
    end
  end

  describe 'error states' do
    before do
      plan.errors.add(:amount, 'is invalid')
    end

    it 'applies error styles' do
      render_inline(described_class.new(name: name, form: form))

      expect(page).to have_css('input.text-red-900')
      expect(page).to have_css('input.ring-red-300')
      expect(page).to have_css('input.focus\\:ring-red-600')
      expect(page).to have_css('input.placeholder\\:text-red-300')
    end

    it 'displays error message' do
      render_inline(described_class.new(name: name, form: form))

      expect(page).to have_css('p.text-red-600', text: 'is invalid')
    end
  end

  describe 'disabled state' do
    it 'applies disabled styles' do
      render_inline(described_class.new(name: name, disabled: true, form: form))

      expect(page).to have_css('input.disabled\\:cursor-not-allowed')
      expect(page).to have_css('input.disabled\\:bg-gray-50')
      expect(page).to have_css('input.disabled\\:text-gray-500')
      expect(page).to have_css('input.disabled\\:ring-gray-200')
    end
  end

  describe 'focus styles' do
    it 'applies default focus styles' do
      render_inline(described_class.new(name: name, form: form))

      expect(page).to have_css('input.focus\\:ring-2')
      expect(page).to have_css('input.focus\\:ring-indigo-600')
    end

    it 'applies error focus styles when in error state' do
      component = described_class.new(name: name, form: form)
      allow(component).to receive(:error?).and_return(true)

      render_inline(component)
      expect(page).to have_css('input.focus\\:ring-red-600')
    end
  end
end
