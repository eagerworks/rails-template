require 'rails_helper'

RSpec.describe Elements::Link, type: :component do
  it 'renders a link with content' do
    render_inline(described_class.new(href: '/test').with_content('Click me'))

    expect(page).to have_link('Click me', href: '/test')
  end

  describe 'styles' do
    it 'includes default classes' do
      render_inline(described_class.new(href: '/test'))

      expect(page).to have_css('a.font-semibold')
      expect(page).to have_css('a.text-indigo-600')
      expect(page).to have_css('a.hover\\:text-indigo-500')
    end
  end

  describe 'Turbo attributes' do
    it 'enables Turbo by default' do
      render_inline(described_class.new(href: '/test'))

      expect(page).to have_css('a[data-turbo="true"]')
    end

    it 'allows disabling Turbo' do
      render_inline(described_class.new(href: '/test', turbo: false))

      expect(page).not_to have_css('a[data-turbo]')
    end

    it 'supports Turbo frame targeting' do
      render_inline(described_class.new(href: '/test', turbo_frame: 'my_frame'))

      expect(page).to have_css('a[data-turbo="true"]')
      expect(page).to have_css('a[data-turbo-frame="my_frame"]')
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

    it 'merges data attributes with Turbo attributes' do
      render_inline(
        described_class.new(
          href: '/test',
          data: { test: 'value' }
        )
      )

      expect(page).to have_css('a[data-turbo="true"]')
      expect(page).to have_css('a[data-test="value"]')
    end
  end
end
