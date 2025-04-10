# frozen_string_literal: true

module Form
  class ImageInput < Input
    use_helpers :heroicon

    def attached?
      object.send(name).attached?
    end

    def image_url
      return '' unless attached?

      object.send(name)&.url
    end
  end
end
