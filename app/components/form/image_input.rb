# frozen_string_literal: true

module Form
  class ImageInput < Input
    use_helpers :heroicon

    def attached?
      object.send(name).attached?
    end

    def image_url
      unless attached?
        return ''
      end

      object.send(name)
    end
  end
end
