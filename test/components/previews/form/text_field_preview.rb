# frozen_string_literal: true

module Form
  # @display component_path form/text_field
  class TextFieldPreview < ViewComponent::Preview
    # @param label
    # @param type select [text, email, password]
    # @param placeholder
    # @param size select [md, lg]
    def default(label: 'Email', type: :email, placeholder: 'you@example.com', size: 'md')
      render(Form::TextField.new(
               name: :email, type: type, placeholder: placeholder, label: label, size: size
             ))
    end

    # @param type select [text, email, password]
    # @param placeholder
    # @param show_label toggle
    def no_label(show_label: false, type: :email, placeholder: 'you@example.com')
      render(Form::TextField.new(
               name: :email, type: type, placeholder: placeholder, show_label: show_label
             ))
    end

    # @param label
    # @param type select [text, email, password]
    # @param placeholder
    # @param description
    def with_description(
      label: 'Email', type: :email, placeholder: 'you@example.com',
      description: 'We will never share your email with anyone else.'
    )
      render(Form::TextField.new(
        name: :email, type: type, placeholder: placeholder, label: label
      ).with_description_content(description))
    end

    # @param label
    # @param type select [text, email, password]
    # @param placeholder
    def with_error(label: 'Email', type: :email, placeholder: 'you@example.com')
      user = User.new
      user.email = 'invalid@email.com'
      user.errors.add(:email, :invalid, message: 'is invalid')

      render_with_template(
        locals: { label: label, type: type, placeholder: placeholder, user: user }
      )
    end

    # @param label
    # @param type select [text, email, password]
    # @param placeholder
    # @param disabled toggle
    def disabled(label: 'Email', type: :email, placeholder: 'you@example.com', disabled: true)
      render(
        Form::TextField.new(
          name: :email, type: type, placeholder: placeholder, label: label, disabled: disabled
        )
      )
    end

    # @param label
    # @param type select [text, email, password]
    # @param placeholder
    # @param size select [md, lg]
    def with_left_icon(label: 'Email', type: :email, placeholder: 'you@example.com', size: 'md')
      render_with_template(
        locals: { type: type, placeholder: placeholder, label: label, size: size }
      )
    end

    # @param label
    # @param type select [text, email, password]
    # @param placeholder
    # @param size select [md, lg]
    def with_right_icon(label: 'Email', type: :email, placeholder: 'you@example.com', size: 'md')
      render_with_template(
        locals: { type: type, placeholder: placeholder, label: label, size: size }
      )
    end

    # @param label
    # @param type select [text, email, password]
    # @param placeholder
    # @param size select [md, lg]
    def slot_label(label: 'Email', type: :email, placeholder: 'you@example.com', size: 'md')
      render(Form::TextField.new(
               name: :email, type: type, placeholder: placeholder, size: size
             )) do |component|
        component.with_label_content(label)
      end
    end
  end
end
