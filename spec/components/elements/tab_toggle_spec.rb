require 'rails_helper'

RSpec.describe Elements::TabToggle, type: :component do
  it 'renders a tab toggle container' do
    render_inline(described_class.new)

    expect(page).to have_css('fieldset')
    expect(page).to have_css('div.grid')
    expect(page).to have_css('div.grid-cols-2')
    expect(page).to have_css('div.gap-x-1')
    expect(page).to have_css('div.rounded-full')
    expect(page).to have_css('div.p-1')
    expect(page).to have_css('div.text-center')
    expect(page).to have_css('div.text-xs\\/5')
    expect(page).to have_css('div.font-semibold')
    expect(page).to have_css('div.ring-1')
    expect(page).to have_css('div.ring-inset')
    expect(page).to have_css('div.ring-gray-200')
  end

  describe 'tabs' do
    it 'renders multiple tabs' do
      render_inline(described_class.new) do |c|
        c.with_tab(href: '/tab1') { 'Tab 1' }
        c.with_tab(href: '/tab2') { 'Tab 2' }
      end

      expect(page).to have_link('Tab 1', href: '/tab1')
      expect(page).to have_link('Tab 2', href: '/tab2')
    end

    it 'renders tabs with proper base styling' do
      render_inline(described_class.new) do |c|
        c.with_tab(href: '/tab1') { 'Tab 1' }
      end

      expect(page).to have_css('a.cursor-pointer')
      expect(page).to have_css('a.rounded-full')
      expect(page).to have_css('a.px-2\\.5')
      expect(page).to have_css('a.py-1')
    end

    describe 'active state' do
      it 'renders active tab with active styles' do
        render_inline(described_class.new) do |c|
          c.with_tab(href: '/tab1', active: true) { 'Active Tab' }
        end

        expect(page).to have_css('a.bg-indigo-600')
        expect(page).to have_css('a.text-white')
        expect(page).not_to have_css('a.text-gray-500')
      end

      it 'renders inactive tab with inactive styles' do
        render_inline(described_class.new) do |c|
          c.with_tab(href: '/tab1', active: false) { 'Inactive Tab' }
        end

        expect(page).not_to have_css('a.bg-indigo-600')
        expect(page).not_to have_css('a.text-white')
        expect(page).to have_css('a.text-gray-500')
      end

      it 'handles multiple tabs with different states' do
        render_inline(described_class.new) do |c|
          c.with_tab(href: '/tab1', active: true) { 'Active Tab' }
          c.with_tab(href: '/tab2', active: false) { 'Inactive Tab' }
        end

        within('a:contains("Active Tab")') do
          expect(page).to have_css('.bg-indigo-600')
          expect(page).to have_css('.text-white')
        end

        within('a:contains("Inactive Tab")') do
          expect(page).to have_css('.text-gray-500')
        end
      end
    end
  end

  describe 'complex scenarios' do
    it 'renders tabs with HTML content' do
      render_inline(described_class.new) do |c|
        c.with_tab(href: '/tab1') do
          '<span class="font-bold">Tab</span><span class="ml-1">1</span>'.html_safe
        end
      end

      expect(page).to have_css('a span.font-bold', text: 'Tab')
      expect(page).to have_css('a span.ml-1', text: '1')
    end

    it 'handles no tabs gracefully' do
      render_inline(described_class.new)

      expect(page).to have_css('fieldset')
      expect(page).to have_css('div.grid')
      expect(page).not_to have_css('a')
    end

    it 'maintains grid layout with odd number of tabs' do
      render_inline(described_class.new) do |c|
        c.with_tab(href: '/tab1') { 'Tab 1' }
        c.with_tab(href: '/tab2') { 'Tab 2' }
        c.with_tab(href: '/tab3') { 'Tab 3' }
      end

      expect(page).to have_css('div.grid')
      expect(page).to have_css('div.grid-cols-2')
      expect(page).to have_link(count: 3)
    end
  end
end
