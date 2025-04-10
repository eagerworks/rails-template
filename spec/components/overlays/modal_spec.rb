# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Overlays::Modal, type: :component do
  context 'with turbo frame' do
    it 'renders a modal with a turbo frame' do
      render_inline(described_class.new(turbo_frame: :modal))

      expect(page).to have_selector('turbo-frame#modal')
    end
  end

  it 'renders the content outside the turbo frame' do
    render_inline(described_class.new(turbo_frame: :modal)) do
      'Modal Content'
    end

    expect(page).to have_text('Modal Content')
  end

  context 'without turbo frame' do
    it 'renders the panel slot' do
      render_inline(described_class.new) do |c|
        c.with_panel { 'Panel Content' }
      end

      expect(page).to have_text('Panel Content')
    end
  end
end
