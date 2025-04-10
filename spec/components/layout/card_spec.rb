require 'rails_helper'

RSpec.describe Layout::Card, type: :component do
  describe 'rendering' do
    it 'renders a basic card with content' do
      render_inline(described_class.new.with_content('Hello World'))

      expect(page).to have_text('Hello World')
      expect(page).to have_css('div.overflow-hidden.divide-y.divide-gray-200')
      expect(page).to have_css('div.sm\\:rounded-lg.shadow.border')
      expect(page).to have_css('div.bg-white.border-black.border-opacity-5')
    end

    it 'renders with medium padding by default' do
      render_inline(described_class.new.with_content('Content'))

      expect(page).to have_css('div.px-4.py-5')
      expect(page).to have_css('div.sm\\:p-6')
    end

    it 'renders with large padding' do
      render_inline(described_class.new(padding: :lg).with_content('Content'))

      expect(page).to have_css('div.px-6.py-12')
      expect(page).to have_css('div.sm\\:px-12')
    end

    it 'renders without padding' do
      render_inline(described_class.new(padding: nil).with_content('Content'))

      expect(page).not_to have_css('div.px-4')
      expect(page).not_to have_css('div.py-5')
      expect(page).not_to have_css('div.sm\\:p-6')
    end
  end

  describe 'header slot' do
    it 'renders with a header' do
      component = described_class.new.with_content('Main Content')
      component.with_header { 'Card Header' }

      render_inline(component)

      expect(page).to have_css('div.px-4.py-5.sm\\:px-6', text: 'Card Header')
      expect(page).to have_text('Main Content')
    end

    it 'does not render header section when no header is provided' do
      render_inline(described_class.new.with_content('Content'))

      expect(page).not_to have_css('div.px-4.py-5.sm\\:px-6')
    end
  end

  describe 'footer slot' do
    it 'renders with a footer' do
      component = described_class.new.with_content('Main Content')
      component.with_footer { 'Card Footer' }

      render_inline(component)

      within('div.bg-gray-50') do
        expect(page).to have_text('Card Footer')
        expect(page).to have_css('.flex.items-center.justify-end.gap-x-6')
        expect(page).to have_css('.border-t.border-gray-200')
        expect(page).to have_css('.px-4.py-4.sm\\:px-6')
      end
    end

    it 'does not render footer section when no footer is provided' do
      render_inline(described_class.new.with_content('Content'))

      expect(page).not_to have_css('div.bg-gray-50')
    end
  end

  describe 'full card with all slots' do
    it 'renders header, content, and footer in correct order' do
      component = described_class.new.with_content('Main Content')
      component.with_header { 'Card Header' }
      component.with_footer { 'Card Footer' }

      render_inline(component)

      html = page.native.inner_html

      # Verify order of elements
      header_position = html.index('Card Header')
      content_position = html.index('Main Content')
      footer_position = html.index('Card Footer')

      expect(header_position).to be < content_position
      expect(content_position).to be < footer_position

      # Verify structure and styling
      expect(page).to have_css('div.px-4.py-5.sm\\:px-6', text: 'Card Header')
      expect(page).to have_css("div[class*='px-4 py-5']", text: 'Main Content')
      expect(page).to have_css('div.bg-gray-50', text: 'Card Footer')
    end
  end

  describe 'styling' do
    it 'includes all base classes' do
      render_inline(described_class.new)

      # Card wrapper classes
      expect(page).to have_css('.overflow-hidden')
      expect(page).to have_css('.divide-y')
      expect(page).to have_css('.divide-gray-200')
      expect(page).to have_css('.sm\\:rounded-lg')
      expect(page).to have_css('.shadow')
      expect(page).to have_css('.border')

      # Background and border styles
      expect(page).to have_css('.bg-white')
      expect(page).to have_css('.border-black')
      expect(page).to have_css('.border-opacity-5')
    end

    it 'applies correct footer styles' do
      component = described_class.new
      component.with_footer { 'Footer' }

      render_inline(component)

      within('div:last-child') do
        expect(page).to have_css('.bg-gray-50')
        expect(page).to have_css('.flex')
        expect(page).to have_css('.items-center')
        expect(page).to have_css('.justify-end')
        expect(page).to have_css('.gap-x-6')
        expect(page).to have_css('.border-t')
        expect(page).to have_css('.border-gray-200')
        expect(page).to have_css('.px-4')
        expect(page).to have_css('.py-4')
        expect(page).to have_css('.sm\\:px-6')
      end
    end
  end
end
