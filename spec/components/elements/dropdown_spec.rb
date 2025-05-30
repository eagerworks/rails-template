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
