require 'rails_helper'

RSpec.describe Form::RadioButtons, type: :component do
  let(:name) { :interval }
  let(:form) { ActionView::Helpers::FormBuilder.new(:plan, Plan.new, ActionView::Base.empty, {}) }

  it 'renders a radio button group with basic structure' do
    render_inline(described_class.new(name: name, form: form))

    expect(page).to have_css('fieldset.mt-2')
    expect(page).to have_css('legend.text-sm\\/6')
    expect(page).to have_css('legend.font-semibold')
    expect(page).to have_css('legend.text-gray-900')
    expect(page).to have_css('div.mt-2')
    expect(page).to have_css('div.space-y-1')
  end

  describe 'legend' do
    it 'uses provided label' do
      render_inline(described_class.new(name: name, label: 'Choose an Interval'))
      expect(page).to have_css('legend', text: 'Choose an Interval')
    end

    it 'falls back to titleized name' do
      render_inline(described_class.new(name: :select_interval))
      expect(page).to have_css('legend', text: 'Select Interval')
    end
  end

  describe 'options' do
    it 'renders radio buttons with labels' do
      render_inline(described_class.new(name: name, form: form)) do |c|
        c.with_option(value: 'monthly', label: 'Monthly')
        c.with_option(value: 'yearly', label: 'Yearly')
      end

      expect(page).to have_field('Monthly', type: 'radio', with: 'monthly')
      expect(page).to have_field('Yearly', type: 'radio', with: 'yearly')
    end

    it 'titleizes value as label when label not provided' do
      render_inline(described_class.new(name: name, form: form)) do |c|
        c.with_option(value: 'monthly')
      end

      expect(page).to have_field('Monthly', type: 'radio', with: 'monthly')
    end

    it 'applies base styles to each option' do
      render_inline(described_class.new(name: name, form: form)) do |c|
        c.with_option(value: 'monthly')
      end

      expect(page).to have_css('div.flex.items-center')
      expect(page).to have_css('input.size-4')
      expect(page).to have_css('input.appearance-none')
      expect(page).to have_css('input.rounded-full')
      expect(page).to have_css('input.border')
      expect(page).to have_css('input.border-gray-300')
      expect(page).to have_css('input.bg-white')
    end

    it 'applies proper spacing between radio and label' do
      render_inline(described_class.new(name: name, form: form)) do |c|
        c.with_option(value: 'red', label: 'Red')
      end

      expect(page).to have_css('div.ml-3')
    end
  end

  describe 'checked state' do
    let(:object) { double('object') }
    let(:form) { ActionView::Helpers::FormBuilder.new(:object, object, ActionView::Base.empty, {}) }

    it 'marks option as checked when it matches object value' do
      allow(object).to receive(:send).with(name).and_return('blue')

      render_inline(described_class.new(name: name, form: form)) do |c|
        c.with_option(value: 'red')
        c.with_option(value: 'blue')
      end

      expect(page).to have_field(type: 'radio', with: 'blue', checked: true)
      expect(page).to have_field(type: 'radio', with: 'red', checked: false)
    end

    it 'applies checked styles' do
      allow(object).to receive(:send).with(name).and_return('red')

      render_inline(described_class.new(name: name, form: form)) do |c|
        c.with_option(value: 'red')
      end

      expect(page).to have_css('input.checked\\:border-indigo-600')
      expect(page).to have_css('input.checked\\:bg-indigo-600')
    end
  end

  describe 'disabled state' do
    it 'disables all options when group is disabled' do
      render_inline(described_class.new(name: name, disabled: true, form: form)) do |c|
        c.with_option(value: 'monthly')
        c.with_option(value: 'yearly')
      end

      expect(page).to have_field(type: 'radio', with: 'monthly', disabled: true)
      expect(page).to have_field(type: 'radio', with: 'yearly', disabled: true)
    end

    it 'applies disabled styles' do
      render_inline(described_class.new(name: name, disabled: true, form: form)) do |c|
        c.with_option(value: 'monthly')
      end

      expect(page).to have_css('input.disabled\\:border-gray-300')
      expect(page).to have_css('input.disabled\\:bg-gray-100')
      expect(page).to have_css('input.disabled\\:before\\:bg-gray-400')
    end
  end

  describe 'focus styles' do
    it 'applies focus styles' do
      render_inline(described_class.new(name: name, form: form)) do |c|
        c.with_option(value: 'monthly')
      end

      expect(page).to have_css('input.focus-visible\\:outline')
      expect(page).to have_css('input.focus-visible\\:outline-2')
      expect(page).to have_css('input.focus-visible\\:outline-offset-2')
      expect(page).to have_css('input.focus-visible\\:outline-indigo-600')
    end
  end

  describe 'form integration' do
    let(:form) { ActionView::Helpers::FormBuilder.new(:plan, Plan.new, ActionView::Base.empty, {}) }

    it 'uses form builder radio_button method' do
      allow(form).to receive(:radio_button).and_return('<input type="radio" />')

      render_inline(described_class.new(name: name, form: form)) do |c|
        c.with_option(value: 'monthly')
      end

      expect(form).to have_received(:radio_button).with(name, 'monthly', any_args)
    end
  end
end
