require 'rails_helper'

RSpec.describe Form::NumberField, type: :component do
  let(:name) { :amount }
  let(:plan) { build(:plan) }
  let(:form) { ActionView::Helpers::FormBuilder.new(:plan, plan, ActionView::Base.empty, {}) }

  it 'renders a text field with basic attributes' do
    render_inline(described_class.new(form: form, name: name))

    expect(page).to have_css('input[type="number"]')
    expect(page).to have_css('input.block')
    expect(page).to have_css('input.w-full')
    expect(page).to have_css('input.rounded-md')
    expect(page).to have_css('input.bg-white')
  end

  describe 'sizing' do
    it 'applies default (md) size styles' do
      render_inline(described_class.new(form: form, name: name))

      expect(page).to have_css('input.px-3')
      expect(page).to have_css('input.py-1\\.5')
      expect(page).to have_css('input.text-base')
      expect(page).to have_css('input.sm\\:text-sm\\/6')
    end

    it 'adjusts styles for large size' do
      render_inline(described_class.new(form: form, name: name, size: 'lg'))

      expect(page).to have_css('input.text-base')
      expect(page).to have_css('input.sm\\:text-sm\\/6')
    end
  end

  describe 'error states' do
    before do
      plan.errors.add(:amount, 'is invalid')
    end

    it 'applies error styles' do
      render_inline(described_class.new(form: form, name: name))

      expect(page).to have_css('input.text-red-900')
      expect(page).to have_css('input.ring-red-300')
      expect(page).to have_css('input.focus\\:ring-red-600')
      expect(page).to have_css('input.placeholder\\:text-red-300')
    end

    it 'displays error icon' do
      render_inline(described_class.new(form: form, name: name))

      expect(page).to have_css('svg.text-red-500')
    end

    it 'displays error message' do
      render_inline(described_class.new(form: form, name: name))

      expect(page).to have_css('p.text-red-600', text: 'is invalid')
    end
  end

  describe 'description' do
    it 'displays description text when provided' do
      render_inline(described_class.new(form: form, name: name)) do |c|
        c.with_description { 'Enter your email address' }
      end

      expect(page).to have_css('p.text-gray-500', text: 'Enter your email address')
    end

    it 'prioritizes error message over description' do
      component = described_class.new(form: form, name: name)
      allow(component).to receive(:error?).and_return(true)
      allow(component).to receive(:error).and_return('is invalid')

      render_inline(component) do |c|
        c.with_description { 'Enter your email address' }
      end

      expect(page).to have_css('p.text-red-600', text: 'is invalid')
      expect(page).not_to have_text('Enter your email address')
    end
  end

  describe 'disabled state' do
    it 'applies disabled styles' do
      render_inline(described_class.new(form: form, name: name, disabled: true))

      expect(page).to have_css('input.disabled\\:cursor-not-allowed')
      expect(page).to have_css('input.disabled\\:bg-gray-50')
      expect(page).to have_css('input.disabled\\:text-gray-500')
      expect(page).to have_css('input.disabled\\:ring-gray-200')
    end
  end

  describe 'focus styles' do
    it 'applies default focus styles' do
      render_inline(described_class.new(form: form, name: name))

      expect(page).to have_css('input.focus\\:ring-2')
      expect(page).to have_css('input.focus\\:ring-indigo-600')
    end

    it 'applies error focus styles when in error state' do
      component = described_class.new(form: form, name: name)
      allow(component).to receive(:error?).and_return(true)

      render_inline(component)
      expect(page).to have_css('input.focus\\:ring-red-600')
    end
  end
end
