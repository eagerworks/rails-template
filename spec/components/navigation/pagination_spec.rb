# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Navigation::Pagination, type: :component do
  let(:pagy) { Pagy.new(count: 500, page: 2, limit: 10) }
  let(:pages) { pagy.pages }

  it 'lists the current page and the total' do
    render_inline(described_class.new(pagy: pagy))

    expect(page).to have_text('Showing 11 to 20 of 500 results', normalize_ws: true)
  end

  it 'has a link to the previous page' do
    render_inline(described_class.new(pagy: pagy))

    expect(page).to have_link('<', href: '/?page=1')
  end

  it 'has a link to the next page' do
    render_inline(described_class.new(pagy: pagy))

    expect(page).to have_link('>', href: '/?page=3')
  end

  it 'has a link to the first 5 pages' do
    render_inline(described_class.new(pagy: pagy))

    (1..5).each do |number|
      if number == 2
        expect(page).to have_selector('a.current', text: number.to_s)
      else
        expect(page).to have_link(number.to_s, href: "/?page=#{number}")
      end
    end
  end

  it 'has a link to the last page' do
    render_inline(described_class.new(pagy: pagy))

    pages = pagy.pages

    expect(page).to have_link(pages.to_s, href: "/?page=#{pages}")
  end
end
