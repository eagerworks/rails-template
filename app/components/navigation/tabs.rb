# frozen_string_literal: true

module Navigation
  class Tabs < BaseComponent
    renders_many :tabs, lambda { |url:, label:|
      Tab.new(url: url, turbo_frame: @turbo_frame).with_content(label)
    }

    def initialize(turbo_frame:)
      super

      @turbo_frame = turbo_frame
    end

    def selected_classes
      case primary_color
      when 'indigo'
        'border-indigo-500 text-indigo-600'
      when 'aqua'
        'border-aqua-500 text-aqua-600'
      end
    end

    class Tab < BaseComponent
      attr_reader :turbo_frame, :url

      def initialize(url:, turbo_frame:)
        super

        @turbo_frame = turbo_frame
        @url = url
      end

      erb_template <<~ERB
        <a
          href="<%= url %>"
          data-turbo-frame="<%= turbo_frame %>"
          data-action="tabs#selectTab"
          data-tabs-target="tab"
          class="whitespace-nowrap border-b-2 px-1 py-4 text-sm font-medium"
          role="tab"
        >
          <%= content %>
        </a>
      ERB
    end
  end
end
