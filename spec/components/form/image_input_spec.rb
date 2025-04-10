require 'rails_helper'

RSpec.describe Form::ImageInput, type: :component do
  let(:user) { build(:user) }
  let(:form) { ActionView::Helpers::FormBuilder.new(:user, user, ActionView::Base.empty, {}) }
  let(:name) { :avatar }

  it 'renders an input with type file' do
    render_inline(described_class.new(name: name, form: form))
    expect(page).to have_css("input[type='file'][name='user[#{name}]']")
  end

  it 'has a button with a label to the input' do
    render_inline(described_class.new(name: name, form: form))
    expect(page).to have_css('button')
    expect(page.first('button')).to have_css("label[for='user_avatar']")
    expect(page).to have_text('Change avatar')
  end

  context 'when no image is attached' do
    it 'shows a placeholder image' do
      render_inline(described_class.new(name: name, form: form))

      expect(page).to have_css('svg')
    end
  end

  context 'when an image is attached' do
    let(:user) { create(:user, :with_avatar) }

    it 'doesn\'t show a placeholder image' do
      render_inline(described_class.new(name: name, form: form))

      expect(page).not_to have_css('svg')
    end

    xit 'shows the uploaded image' do
      render_inline(described_class.new(name: name, form: form))

      expect(page).to have_css("div[x-data=\"imageInput('#{user.avatar.url}', true)\"]")
    end
  end
end
