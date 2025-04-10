require 'rails_helper'

RSpec.describe Form::FieldError, type: :component do
  describe 'rendering' do
    it 'renders error message with proper styling' do
      render_inline(described_class.new(error: 'is invalid'))

      expect(page).to have_css('p.text-red-600')
      expect(page).to have_css('p.text-sm')
      expect(page).to have_css('p.mt-2')
      expect(page).to have_text('is invalid')
    end

    it 'does not render when error is nil' do
      render_inline(described_class.new(error: nil))
      expect(page).to have_no_css('div')
    end

    it 'does not render when error is empty string' do
      render_inline(described_class.new(error: ''))
      expect(page).to have_no_css('div')
    end

    it 'renders error message with HTML content' do
      render_inline(described_class.new(error: '<strong>Required</strong> field'.html_safe))

      expect(page).to have_css('p.text-red-600')
      expect(page).to have_css('strong', text: 'Required')
      expect(page).to have_text('Required field')
    end

    it 'escapes HTML content by default' do
      render_inline(described_class.new(error: '<strong>Required</strong> field'))

      expect(page).to have_no_css('strong')
      expect(page).to have_text('<strong>Required</strong> field')
    end
  end

  describe 'initialization' do
    it 'accepts error message' do
      error = described_class.new(error: 'is invalid')
      expect(error.instance_variable_get(:@error)).to eq('is invalid')
    end
  end

  describe '#render?' do
    it 'returns true when error is present' do
      error = described_class.new(error: 'is invalid')
      expect(error.render?).to be true
    end

    it 'returns false when error is nil' do
      error = described_class.new(error: nil)
      expect(error.render?).to be false
    end

    it 'returns false when error is empty string' do
      error = described_class.new(error: '')
      expect(error.render?).to be false
    end

    it 'returns true when error is zero' do
      error = described_class.new(error: 0)
      expect(error.render?).to be true
    end

    it 'returns false when error is false' do
      error = described_class.new(error: false)
      expect(error.render?).to be false
    end
  end

  describe 'integration with form components' do
    let(:name) { :email }
    let(:errors) { double('errors') }
    let(:object) { double('object', errors: errors) }
    let(:form) { ActionView::Helpers::FormBuilder.new(:user, object, ActionView::Base.empty, {}) }

    it 'renders error from form object' do
      allow(errors).to receive(:include?).with(name).and_return(true)
      allow(errors).to receive(:full_messages_for).with(name).and_return(['Email is invalid'])

      render_inline(Form::TextField.new(name: name, form: form))

      within('div.text-red-500') do
        expect(page).to have_text('Email is invalid')
      end
    end

    it 'handles multiple error messages' do
      allow(errors).to receive(:include?).with(name).and_return(true)
      allow(errors).to receive(:full_messages_for).with(name).and_return(['is invalid',
                                                                          'is required'])

      render_inline(Form::TextField.new(name: name, form: form))

      # By default, only the first error message is shown
      within('div.text-red-500') do
        expect(page).to have_text('is invalid')
        expect(page).not_to have_text('is required')
      end
    end
  end
end
