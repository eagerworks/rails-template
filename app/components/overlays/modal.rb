module Overlays
  class Modal < BaseComponent
    use_helpers :turbo_frame_tag
    renders_one :panel
    attr_reader :turbo_frame

    def initialize(turbo_frame: nil)
      super()

      @turbo_frame = turbo_frame
    end

    private

    def turbo?
      turbo_frame.present?
    end
  end
end
