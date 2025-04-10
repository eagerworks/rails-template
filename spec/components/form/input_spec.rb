require 'rails_helper'

RSpec.describe Form::Input, type: :component do
  # Create a concrete test class since Input is abstract
  let(:test_class) do
    Class.new(described_class) do
      use_helpers :text_field
      # Empty render method since we're testing the abstract functionality
      def call; end
    end
  end

  let(:name) { :email }
  let(:form) { ActionView::Helpers::FormBuilder.new(:user, User.new, ActionView::Base.empty, {}) }

  describe 'initialization' do
    it 'accepts required and optional attributes' do
      input = test_class.new(
        name: name,
        form: form,
        label: 'Email',
        show_label: true,
        margin: true,
        custom_colors: { primary: 'indigo' },
        class: 'custom-class'
      )

      expect(input.name).to eq(name)
      expect(input.form).to eq(form)
      expect(input.show_label).to be true
      expect(input.margin).to be true
      expect(input.custom_color).to eq('indigo')
      expect(input.attributes[:class]).to eq('custom-class')
    end

    it 'sets default values when optional attributes are not provided' do
      input = test_class.new(name: name)

      expect(input.form).to be_nil
      expect(input.show_label).to be true
      expect(input.margin).to be true
      expect(input.custom_color).to be_nil
    end
  end

  describe '#description' do
    it 'allows setting description content' do
      input = test_class.new(name: name)
      expect(input.description?).to be false

      input.with_description { 'Help text' }
      expect(input.description?).to be true
    end
  end

  describe '#field_id' do
    context 'with form' do
      it 'returns form-based field id' do
        input = test_class.new(name: name, form: form)
        expect(input.field_id).to eq('user_email')
      end
    end

    context 'without form' do
      it 'returns name as field id' do
        input = test_class.new(name: name)
        expect(input.field_id).to eq(name)
      end
    end
  end

  describe '#field_name' do
    context 'with form' do
      it 'returns form-based field name' do
        input = test_class.new(name: name, form: form)
        expect(input.field_name).to eq('user[email]')
      end
    end

    context 'without form' do
      it 'returns name as field name' do
        input = test_class.new(name: name)
        expect(input.field_name).to eq(name)
      end
    end
  end

  describe '#object' do
    it 'returns form object when form is present' do
      user = User.new
      form = ActionView::Helpers::FormBuilder.new(:user, user, ActionView::Base.empty, {})
      input = test_class.new(name: name, form: form)
      expect(input.object).to eq(user)
    end

    it 'returns nil when form is not present' do
      input = test_class.new(name: name)
      expect(input.object).to be_nil
    end
  end

  describe '#object_name' do
    it 'returns form object name when form is present' do
      input = test_class.new(name: name, form: form)
      expect(input.object_name).to eq(:user)
    end

    it 'returns nil when form is not present' do
      input = test_class.new(name: name)
      expect(input.object_name).to be_nil
    end
  end

  describe '#value' do
    it 'returns attribute value from form object' do
      user = User.new
      allow(user).to receive(:try).with(:email).and_return('test@example.com')
      form = ActionView::Helpers::FormBuilder.new(:user, user, ActionView::Base.empty, {})

      input = test_class.new(name: name, form: form)
      expect(input.value).to eq('test@example.com')
    end

    it 'returns nil when form object is not present' do
      input = test_class.new(name: name)
      expect(input.value).to be_nil
    end
  end

  describe 'error handling' do
    let(:errors) { double('errors') }
    let(:user) { double('user', errors: errors) }
    let(:form) { ActionView::Helpers::FormBuilder.new(:user, user, ActionView::Base.empty, {}) }

    describe '#error?' do
      it 'returns true when field has errors' do
        allow(errors).to receive(:include?).with(name).and_return(true)
        input = test_class.new(name: name, form: form)
        expect(input.error?).to be true
      end

      it 'returns false when field has no errors' do
        allow(errors).to receive(:include?).with(name).and_return(false)
        input = test_class.new(name: name, form: form)
        expect(input.error?).to be false
      end

      it 'returns false when form object is not present' do
        input = test_class.new(name: name)
        expect(input.error?).to be false
      end
    end

    describe '#error' do
      it 'returns first error message when present' do
        allow(errors).to receive(:full_messages_for).with(name).and_return(['is invalid'])
        input = test_class.new(name: name, form: form)
        expect(input.error).to eq('is invalid')
      end

      it 'returns nil when no errors present' do
        allow(errors).to receive(:full_messages_for).with(name).and_return([])
        input = test_class.new(name: name, form: form)
        expect(input.error).to be_nil
      end

      it 'returns nil when form object is not present' do
        input = test_class.new(name: name)
        expect(input.error).to be_nil
      end
    end
  end
end
