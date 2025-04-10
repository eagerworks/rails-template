require 'rails_helper'

RSpec.describe Elements::Dropdown, type: :component do
  it 'renders a dropdown with default button' do
    render_inline(described_class.new.with_content('Options'))

    expect(page).to have_css('div.relative.inline-block.text-left')
    expect(page).to have_button('Options')
    expect(page).to have_css('button.inline-flex')
    expect(page).to have_css('button.justify-center')
    expect(page).to have_css('button.rounded-md')
    expect(page).to have_css('svg[data-slot="icon"]')
  end

  describe 'alignment' do
    it 'defaults to left alignment' do
      render_inline(described_class.new)
      expect(page).to have_css('div.origin-top-left')
      expect(page).to have_css('div.left-0')
    end

    it 'supports right alignment' do
      render_inline(described_class.new(align: :right))
      expect(page).to have_css('div.origin-top-right')
      expect(page).to have_css('div.right-0')
    end
  end

  describe 'custom button' do
    it 'renders with custom button content' do
      render_inline(described_class.new) do |c|
        c.with_button do
          '<button class="custom-btn">Custom Button</button>'.html_safe
        end
      end

      expect(page).to have_css('button.custom-btn')
      expect(page).to have_button('Custom Button')
    end
  end

  describe 'items' do
    it 'renders dropdown items' do
      render_inline(described_class.new) do |c|
        c.with_item(href: '/profile') { 'Profile' }
        c.with_item(href: '/settings') { 'Settings' }
      end

      expect(page).to have_link('Profile', href: '/profile')
      expect(page).to have_link('Settings', href: '/settings')
      expect(page).to have_css('a.block')
      expect(page).to have_css('a.px-4')
      expect(page).to have_css('a.py-2')
      expect(page).to have_css('a.text-sm')
      expect(page).to have_css('a.text-gray-700')
      expect(page).to have_css('a.hover\\:bg-gray-100')
      expect(page).to have_css('a.hover\\:text-gray-900')
    end

    it 'renders items with custom attributes' do
      render_inline(described_class.new) do |c|
        c.with_item(href: '/profile', class: 'custom-item', data: { test: 'value' }) { 'Profile' }
      end

      expect(page).to have_css('a.custom-item')
      expect(page).to have_css('a[data-test="value"]')
    end
  end

  describe 'sections' do
    it 'renders multiple sections with items' do
      render_inline(described_class.new) do |c|
        c.with_section do |s|
          s.with_item(href: '/profile') { 'Profile' }
          s.with_item(href: '/settings') { 'Settings' }
        end
        c.with_section do |s|
          s.with_item(href: '/logout') { 'Logout' }
        end
      end

      expect(page).to have_css('div.divide-y')
      expect(page).to have_css('div.divide-gray-100')
      expect(page).to have_css('div.py-1[role="none"]', count: 2)
      expect(page).to have_link('Profile', href: '/profile')
      expect(page).to have_link('Settings', href: '/settings')
      expect(page).to have_link('Logout', href: '/logout')
    end
  end

  describe 'focus styles' do
    it 'includes focus classes' do
      render_inline(described_class.new)
      expect(page).to have_css('button.focus\\:ring-2')
      expect(page).to have_css('button.focus-visible\\:outline')
      expect(page).to have_css('button.focus-visible\\:outline-2')
      expect(page).to have_css('button.focus-visible\\:outline-offset-2')
      expect(page).to have_css('button.focus-visible\\:outline-indigo-600')
    end
  end
end
