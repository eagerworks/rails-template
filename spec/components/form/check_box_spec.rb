require 'rails_helper'

RSpec.describe Form::CheckBox, type: :component do
  let(:name) { :admin }
  let(:form) { ActionView::Helpers::FormBuilder.new(:user, User.new, ActionView::Base.empty, {}) }

  it 'renders a checkbox with basic attributes' do
    render_inline(described_class.new(name: name))

    expect(page).to have_css('input[type="checkbox"]')
    expect(page).to have_css('input.h-4')
    expect(page).to have_css('input.w-4')
    expect(page).to have_css('input.rounded')
    expect(page).to have_css('input.border-gray-300')
    expect(page).to have_css('input.text-indigo-600')
    expect(page).to have_css('input.focus\\:ring-indigo-600')
  end

  describe 'container styling' do
    it 'applies base container styles' do
      render_inline(described_class.new(name: name))

      expect(page).to have_css('div.relative')
      expect(page).to have_css('div.flex')
      expect(page).to have_css('div.items-start')
    end

    it 'applies margin when specified' do
      render_inline(described_class.new(name: name, margin: true))
      expect(page).to have_css('div.mt-2')
    end

    it 'skips margin when disabled' do
      render_inline(described_class.new(name: name, margin: false))
      expect(page).not_to have_css('div.mt-2')
    end
  end

  describe 'label' do
    it 'renders label when provided' do
      render_inline(described_class.new(name: name, label: 'Admin'))

      expect(page).to have_css('div.ml-3')
      expect(page).to have_css('div.text-sm\\/6')
      expect(page).to have_css('div.leading-6')
      expect(page).to have_css('label', text: 'Admin')
    end

    it 'renders label with block content' do
      render_inline(described_class.new(name: name)) do |c|
        c.with_label { 'Is the user an admin?' }
      end
      expect(page).to have_css('label', text: 'Is the user an admin?')
    end

    it 'skips label when show_label is false' do
      render_inline(described_class.new(name: name, label: 'Is the user an admin?',
                                        show_label: false))
      expect(page).not_to have_css('label')
    end
  end

  describe 'description' do
    it 'renders description when provided' do
      render_inline(described_class.new(name: name)) do |c|
        c.with_description { 'Is the user an admin?' }
      end

      expect(page).to have_css('p.text-gray-500', text: 'Is the user an admin?')
    end

    it 'only shows description when label is shown' do
      render_inline(described_class.new(name: name, show_label: false)) do |c|
        c.with_description { 'Is the user an admin?' }
      end

      expect(page).not_to have_css('p.text-gray-500')
    end
  end

  describe 'checked state' do
    it 'sets default checked and unchecked values' do
      checkbox = described_class.new(name: name)
      expect(checkbox.checked_value).to eq('1')
      expect(checkbox.unchecked_value).to eq('0')
    end

    it 'accepts custom checked and unchecked values' do
      checkbox = described_class.new(
        name: name,
        checked_value: 'yes',
        unchecked_value: 'no'
      )
      expect(checkbox.checked_value).to eq('yes')
      expect(checkbox.unchecked_value).to eq('no')
    end

    it 'reflects checked state from form object' do
      object = double('object')
      form = ActionView::Helpers::FormBuilder.new(:object, object, ActionView::Base.empty, {})
      allow(object).to receive(:try).with(name).and_return(true)

      render_inline(described_class.new(name: name, form: form))
      expect(page).to have_css('input[type="checkbox"][checked]')
    end
  end

  describe 'form integration' do
    let(:form) do
      ActionView::Helpers::FormBuilder.new(:user, User.new, ActionView::Base.empty, {})
    end

    it 'uses form field name' do
      render_inline(described_class.new(name: name, form: form))
      expect(page).to have_css('input[name="user[admin]"]')
    end
  end
end
