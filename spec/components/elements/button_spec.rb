require 'rails_helper'

RSpec.describe Elements::Button, type: :component do
  it 'renders a button with content' do
    render_inline(described_class.new.with_content('Click me'))
    expect(page).to have_button('Click me')
  end

  describe 'base styles' do
    it 'includes default classes' do
      render_inline(described_class.new)
      expect(page).to have_css('button.font-semibold')
      expect(page).to have_css('button.shadow-sm')
      expect(page).to have_css('button.inline-block')
    end
  end

  describe 'variants' do
    context 'primary variant (default)' do
      it 'renders with primary styles' do
        render_inline(described_class.new)
        expect(page).to have_css('button.text-white')
        expect(page).to have_css('button.bg-indigo-600')
        expect(page).to have_css('button.hover\\:bg-indigo-500')
      end

      it 'renders with dark mode styles' do
        render_inline(described_class.new(dark: true))
        expect(page).to have_css('button.text-white')
        expect(page).to have_css('button.bg-indigo-500')
        expect(page).to have_css('button.hover\\:bg-indigo-400')
      end
    end

    context 'secondary variant' do
      it 'renders with secondary styles' do
        render_inline(described_class.new(variant: :secondary))
        expect(page).to have_css('button.bg-white')
        expect(page).to have_css('button.text-gray-900')
        expect(page).to have_css('button.ring-1')
        expect(page).to have_css('button.ring-inset')
        expect(page).to have_css('button.ring-gray-300')
        expect(page).to have_css('button.hover\\:bg-gray-50')
      end

      it 'renders with dark mode styles' do
        render_inline(described_class.new(variant: :secondary, dark: true))
        expect(page).to have_css('button.bg-white\\/10')
        expect(page).to have_css('button.text-white')
        expect(page).to have_css('button.hover\\:bg-white\\/20')
      end
    end

    context 'soft variant' do
      it 'renders with soft styles for indigo' do
        render_inline(described_class.new(variant: :soft))
        expect(page).to have_css('button.bg-indigo-50')
        expect(page).to have_css('button.text-indigo-600')
        expect(page).to have_css('button.hover\\:bg-indigo-100')
      end

      it 'renders with soft styles for red' do
        render_inline(described_class.new(variant: :soft, color: :red))
        expect(page).to have_css('button.bg-red-50')
        expect(page).to have_css('button.text-red-600')
        expect(page).to have_css('button.hover\\:bg-red-100')
      end
    end
  end

  describe 'sizes' do
    context 'with default rounding' do
      it 'renders xs size' do
        render_inline(described_class.new(size: :xs))
        expect(page).to have_css('button.py-1')
        expect(page).to have_css('button.px-2')
        expect(page).to have_css('button.text-xs')
        expect(page).to have_css('button.rounded')
      end

      it 'renders sm size' do
        render_inline(described_class.new(size: :sm))
        expect(page).to have_css('button.py-1')
        expect(page).to have_css('button.px-2')
        expect(page).to have_css('button.text-sm')
        expect(page).to have_css('button.rounded')
      end

      it 'renders md size (default)' do
        render_inline(described_class.new)
        expect(page).to have_css('button.py-1\\.5')
        expect(page).to have_css('button.px-2\\.5')
        expect(page).to have_css('button.text-sm')
        expect(page).to have_css('button.rounded-md')
      end

      it 'renders lg size' do
        render_inline(described_class.new(size: :lg))
        expect(page).to have_css('button.py-2')
        expect(page).to have_css('button.px-3')
        expect(page).to have_css('button.text-sm')
        expect(page).to have_css('button.rounded-md')
      end

      it 'renders xl size' do
        render_inline(described_class.new(size: :xl))
        expect(page).to have_css('button.py-2\\.5')
        expect(page).to have_css('button.px-3\\.5')
        expect(page).to have_css('button.text-sm')
        expect(page).to have_css('button.rounded-md')
      end
    end

    context 'with rounded: true' do
      it 'adjusts padding for rounded buttons' do
        render_inline(described_class.new(rounded: true))
        expect(page).to have_css('button.rounded-full')
        expect(page).to have_css('button.px-3')
      end

      sizes = {
        xs: ['py-1', 'px-2\\.5'],
        sm: ['py-1', 'px-2\\.5'],
        md: ['py-1\\.5', 'px-3'],
        lg: ['py-2', 'px-3\\.5'],
        xl: ['py-2\\.5', 'px-4']
      }

      sizes.each do |size, (py_class, _px_class)|
        it "adjusts padding for #{size} rounded button" do
          render_inline(described_class.new(size: size, rounded: true))
          expect(page).to have_css("button.#{py_class}")
        end
      end
    end
  end

  describe 'colors' do
    context 'indigo (default)' do
      it 'renders with indigo focus styles' do
        render_inline(described_class.new)
        expect(page).to have_css('button.focus-visible\\:outline-indigo-600')
      end

      it 'renders with dark mode indigo focus styles' do
        render_inline(described_class.new(dark: true))
        expect(page).to have_css('button.focus-visible\\:outline-indigo-500')
      end
    end

    context 'red' do
      it 'renders with red focus styles' do
        render_inline(described_class.new(color: :red))
        expect(page).to have_css('button.focus-visible\\:outline-red-600')
      end

      it 'renders with dark mode red focus styles' do
        render_inline(described_class.new(color: :red, dark: true))
        expect(page).to have_css('button.focus-visible\\:outline-red-500')
      end
    end
  end

  describe 'width' do
    it 'renders with content width by default' do
      render_inline(described_class.new)
      expect(page).not_to have_css('button.w-full')
      expect(page).not_to have_css('button.text-center')
    end

    it 'renders with full width' do
      render_inline(described_class.new(width: :full))
      expect(page).to have_css('button.w-full')
      expect(page).to have_css('button.text-center')
    end
  end

  describe 'focus styles' do
    it 'includes base focus styles' do
      render_inline(described_class.new)
      expect(page).to have_css('button.focus-visible\\:outline')
      expect(page).to have_css('button.focus-visible\\:outline-2')
      expect(page).to have_css('button.focus-visible\\:outline-offset-2')
    end
  end

  describe 'HTML attributes' do
    it 'passes through HTML attributes' do
      render_inline(
        described_class.new(
          id: 'my-button',
          data: { controller: 'button' },
          aria: { label: 'Click me' }
        )
      )

      expect(page).to have_css('button#my-button')
      expect(page).to have_css('button[data-controller="button"]')
      expect(page).to have_css('button[aria-label="Click me"]')
    end
  end
end
