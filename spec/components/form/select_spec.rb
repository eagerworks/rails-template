require 'rails_helper'

RSpec.describe Form::Select, type: :component do
  let(:name) { :interval }
  let(:form) { ActionView::Helpers::FormBuilder.new(:plan, Plan.new, ActionView::Base.empty, {}) }

  it 'renders a select field with basic attributes' do
    render_inline(described_class.new(name: name))

    expect(page).to have_css('select')
    expect(page).to have_css('select.block')
    expect(page).to have_css('select.w-full')
    expect(page).to have_css('select.rounded-md')
    expect(page).to have_css('select.border-0')
  end

  describe 'styling' do
    it 'applies base styles' do
      render_inline(described_class.new(name: name))

      expect(page).to have_css('select.py-1\\.5')
      expect(page).to have_css('select.pl-3')
      expect(page).to have_css('select.pr-10')
      expect(page).to have_css('select.ring-1')
      expect(page).to have_css('select.ring-inset')
      expect(page).to have_css('select.text-gray-900')
      expect(page).to have_css('select.ring-gray-300')
      expect(page).to have_css('select.focus\\:ring-indigo-600')
      expect(page).to have_css('select.focus\\:ring-2')
      expect(page).to have_css('select.sm\\:text-sm\\/6')
      expect(page).to have_css('select.sm\\:leading-6')
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

  describe 'options' do
    it 'renders options from array' do
      options = [['Option 1', 1], ['Option 2', 2]]
      render_inline(described_class.new(name: name, options: options))

      expect(page).to have_css('option[value="1"]', text: 'Option 1')
      expect(page).to have_css('option[value="2"]', text: 'Option 2')
    end

    it 'renders options from collection' do
      item1 = double('item1', id: 1, name: 'Item 1')
      item2 = double('item2', id: 2, name: 'Item 2')
      collection = [item1, item2]

      render_inline(described_class.new(
                      name: name,
                      collection: collection,
                      value_method: :id,
                      label_method: :name
                    ))

      expect(page).to have_css('option[value="1"]', text: 'Item 1')
      expect(page).to have_css('option[value="2"]', text: 'Item 2')
    end

    it 'renders options with custom methods' do
      item1 = double('item1', code: 'A1', title: 'First Item')
      item2 = double('item2', code: 'A2', title: 'Second Item')
      collection = [item1, item2]

      render_inline(described_class.new(
                      name: name,
                      collection: collection,
                      value_method: :code,
                      label_method: :title
                    ))

      expect(page).to have_css('option[value="A1"]', text: 'First Item')
      expect(page).to have_css('option[value="A2"]', text: 'Second Item')
    end

    it 'marks selected option' do
      options = [['Option 1', 1], ['Option 2', 2]]
      render_inline(described_class.new(name: name, options: options, selected: 2))

      expect(page).to have_css('option[value="2"][selected]')
    end
  end

  describe 'block options' do
    it 'renders options provided in block' do
      render_inline(described_class.new(name: name)) do |c|
        c.with_option(value: 1, label: 'First')
        c.with_option(value: 2, label: 'Second')
      end

      expect(page).to have_css('option[value="1"]', text: 'First')
      expect(page).to have_css('option[value="2"]', text: 'Second')
    end

    it 'renders selected block options' do
      render_inline(described_class.new(name: name)) do |c|
        c.with_option(value: 1, label: 'First', selected: true)
        c.with_option(value: 2, label: 'Second')
      end

      expect(page).to have_css('option[value="1"][selected]', text: 'First')
      expect(page).to have_css('option[value="2"]:not([selected])', text: 'Second')
    end
  end

  describe 'label' do
    it 'renders label when provided' do
      render_inline(described_class.new(name: name, label: 'Select Interval'))
      expect(page).to have_css('label', text: 'Select Interval')
    end

    it 'renders label with block content' do
      render_inline(described_class.new(name: name)) do |c|
        c.with_label { 'Choose Interval' }
      end
      expect(page).to have_css('label', text: 'Choose Interval')
    end

    it 'adds margin below label' do
      render_inline(described_class.new(name: name, label: 'Select Interval'))
      expect(page).to have_css('div.mb-2')
    end
  end

  describe 'form integration' do
    let(:form) { ActionView::Helpers::FormBuilder.new(:plan, Plan.new, ActionView::Base.empty, {}) }

    it 'uses form field name' do
      render_inline(described_class.new(name: name, form: form))
      expect(page).to have_css('select[name="plan[interval]"]')
    end
  end
end
