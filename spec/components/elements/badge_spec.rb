require 'rails_helper'

RSpec.describe Elements::Badge, type: :component do
  it 'renders a badge with content' do
    render_inline(described_class.new.with_content('New'))
    expect(page).to have_text('New')
  end

  describe 'base styles' do
    it 'includes default classes' do
      render_inline(described_class.new)
      expect(page).to have_css('span.inline-flex')
      expect(page).to have_css('span.items-center')
      expect(page).to have_css('span.rounded-md')
      expect(page).to have_css('span.px-2')
      expect(page).to have_css('span.py-1')
      expect(page).to have_css('span.text-xs')
      expect(page).to have_css('span.font-medium')
      expect(page).to have_css('span.ring-1')
      expect(page).to have_css('span.ring-inset')
    end
  end

  describe 'colors' do
    {
      gray: ['bg-gray-50', 'text-gray-600', 'ring-gray-500\\/10'],
      red: ['bg-red-50', 'text-red-700', 'ring-red-600\\/10'],
      yellow: ['bg-yellow-50', 'text-yellow-800', 'ring-yellow-600\\/10'],
      green: ['bg-green-50', 'text-green-700', 'ring-green-600\\/10'],
      blue: ['bg-blue-50', 'text-blue-700', 'ring-blue-700\\/10'],
      indigo: ['bg-indigo-50', 'text-indigo-700', 'ring-indigo-700\\/10'],
      purple: ['bg-purple-50', 'text-purple-700', 'ring-purple-700\\/10'],
      pink: ['bg-pink-50', 'text-pink-700', 'ring-pink-700\\/10']
    }.each do |color, classes|
      context "when color is #{color}" do
        it "renders with #{color} styles" do
          render_inline(described_class.new(color: color))
          classes.each do |css_class|
            expect(page).to have_css("span.#{css_class}")
          end
        end
      end
    end

    it 'defaults to indigo color' do
      render_inline(described_class.new)
      expect(page).to have_css('span.bg-indigo-50')
      expect(page).to have_css('span.text-indigo-700')
      expect(page).to have_css('span.ring-indigo-700\\/10')
    end
  end
end
