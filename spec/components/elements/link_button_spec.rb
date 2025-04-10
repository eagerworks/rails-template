require 'rails_helper'

RSpec.describe Elements::LinkButton, type: :component do
  it 'renders a link with button styling' do
    render_inline(described_class.new(href: '/test').with_content('Click me'))

    expect(page).to have_link('Click me', href: '/test')
    expect(page).to have_css('a.text-center')
  end

  describe 'inheritance from Button' do
    it 'includes base button classes' do
      render_inline(described_class.new(href: '/test'))

      expect(page).to have_css('a.font-semibold')
      expect(page).to have_css('a.shadow-sm')
      expect(page).to have_css('a.inline-block')
    end

    it 'includes primary variant styles' do
      render_inline(described_class.new(href: '/test'))

      expect(page).to have_css('a.text-white')
      expect(page).to have_css('a.bg-indigo-600')
      expect(page).to have_css('a.hover\\:bg-indigo-500')
    end

    it 'supports secondary variant' do
      render_inline(described_class.new(href: '/test', variant: :secondary))

      expect(page).to have_css('a.bg-white')
      expect(page).to have_css('a.text-gray-900')
      expect(page).to have_css('a.ring-1')
      expect(page).to have_css('a.ring-inset')
      expect(page).to have_css('a.ring-gray-300')
      expect(page).to have_css('a.hover\\:bg-gray-50')
    end

    it 'supports soft variant' do
      render_inline(described_class.new(href: '/test', variant: :soft))

      expect(page).to have_css('a.bg-indigo-50')
      expect(page).to have_css('a.text-indigo-600')
      expect(page).to have_css('a.hover\\:bg-indigo-100')
    end

    it 'supports different sizes' do
      render_inline(described_class.new(href: '/test', size: :lg))

      expect(page).to have_css('a.py-2')
      expect(page).to have_css('a.px-3')
      expect(page).to have_css('a.text-sm')
      expect(page).to have_css('a.rounded-md')
    end

    it 'supports rounded style' do
      render_inline(described_class.new(href: '/test', rounded: true))

      expect(page).to have_css('a.rounded-full')
      expect(page).to have_css('a.px-3')
    end

    it 'supports different colors' do
      render_inline(described_class.new(href: '/test', color: :red))

      expect(page).to have_css('a.bg-red-600')
      expect(page).to have_css('a.hover\\:bg-red-500')
      expect(page).to have_css('a.focus-visible\\:outline-red-600')
    end

    it 'supports dark mode' do
      render_inline(described_class.new(href: '/test', dark: true))

      expect(page).to have_css('a.bg-indigo-500')
      expect(page).to have_css('a.hover\\:bg-indigo-400')
      expect(page).to have_css('a.focus-visible\\:outline-indigo-500')
    end

    it 'supports full width' do
      render_inline(described_class.new(href: '/test', width: :full))

      expect(page).to have_css('a.w-full')
      expect(page).to have_css('a.text-center')
    end
  end

  describe 'HTML attributes' do
    it 'passes through HTML attributes' do
      render_inline(
        described_class.new(
          href: '/test',
          id: 'my-link',
          data: { controller: 'link' },
          aria: { label: 'Click me' }
        )
      )

      expect(page).to have_css('a#my-link')
      expect(page).to have_css('a[data-controller="link"]')
      expect(page).to have_css('a[aria-label="Click me"]')
    end
  end

  describe 'focus styles' do
    it 'includes focus classes' do
      render_inline(described_class.new(href: '/test'))

      expect(page).to have_css('a.focus-visible\\:outline')
      expect(page).to have_css('a.focus-visible\\:outline-2')
      expect(page).to have_css('a.focus-visible\\:outline-offset-2')
      expect(page).to have_css('a.focus-visible\\:outline-indigo-600')
    end
  end
end
