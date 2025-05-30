require 'rails_helper'

RSpec.describe Elements::List, type: :component do
  it 'renders a list within a card' do
    render_inline(described_class.new)

    expect(page).to have_css('div.overflow-hidden') # Card class
  end

  describe 'items' do
    it 'renders list items with proper styling' do
      render_inline(described_class.new) do |c|
        c.with_item(href: '#') { 'Item 1' }
        c.with_item(href: '#') { 'Item 2' }
        c.with_item(href: '#') { 'Item 3' }
      end

      expect(page).to have_css('li', count: 3)

      expect(page).to have_text('Item 1')
      expect(page).to have_text('Item 2')
      expect(page).to have_text('Item 3')
    end

    it 'renders items with HTML content' do
      render_inline(described_class.new) do |c|
        c.with_item(href: '#') do
          '<span class="font-bold">Bold Item</span>'.html_safe
        end
      end

      expect(page).to have_css('li span.font-bold')
      expect(page).to have_text('Bold Item')
    end

    it 'renders no items when none provided' do
      render_inline(described_class.new)

      expect(page).not_to have_css('ul')
      expect(page).not_to have_css('li')
    end
  end

  describe 'integration with Card component' do
    it 'renders within a card with no padding' do
      render_inline(described_class.new)

      # Card component classes
      expect(page).to have_css('div.overflow-hidden')
      expect(page).to have_css('div.divide-y')
      expect(page).to have_css('div.divide-gray-200')
      expect(page).to have_css('div.sm\\:rounded-lg')
      expect(page).to have_css('div.shadow')
      expect(page).to have_css('div.border')
      expect(page).to have_css('div.bg-white')
      expect(page).to have_css('div.border-black')
      expect(page).to have_css('div.border-opacity-5')
    end

    it 'does not have padding in the card' do
      render_inline(described_class.new)

      expect(page).not_to have_css('div.p-4')
      expect(page).not_to have_css('div.sm\\:p-6')
      expect(page).not_to have_css('div.lg\\:p-8')
    end
  end

  describe 'complex content' do
    it 'renders items with mixed content' do
      render_inline(described_class.new) do |c|
        c.with_item(href: '#') do
          <<-HTML.html_safe
            <div class="flex justify-between">
              <span class="font-bold">Title</span>
              <span class="text-gray-500">Details</span>
            </div>
          HTML
        end
      end

      expect(page).to have_css('li div.flex')
      expect(page).to have_css('li div.justify-between')
      expect(page).to have_css('li span.font-bold')
      expect(page).to have_css('li span.text-gray-500')
      expect(page).to have_text('Title')
      expect(page).to have_text('Details')
    end
  end
end
