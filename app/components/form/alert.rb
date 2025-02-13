# frozen_string_literal: true

module Form
  class Alert < BaseComponent
    renders_one :title
    use_helpers :heroicon

    attr_reader :type, :show_icon

    def initialize(type: :alert, show_icon: true)
      super

      @show_icon = show_icon
      @type = type.to_sym
    end

    def bg_color
      colors = {
        notice: 'bg-green-50',
        error: 'bg-red-50',
        alert: 'bg-yellow-50',
        info: 'bg-blue-50'
      }

      colors[type]
    end

    def icon_color
      colors = {
        notice: 'text-green-400',
        error: 'text-red-400',
        alert: 'text-yellow-400',
        info: 'text-blue-400'
      }

      colors[type]
    end

    def title_color
      colors = {
        notice: 'text-green-800',
        error: 'text-red-800',
        alert: 'text-yellow-800',
        info: 'text-blue-800'
      }

      colors[type]
    end

    def content_color
      colors = {
        notice: 'text-green-700',
        error: 'text-red-700',
        alert: 'text-yellow-700',
        info: 'text-blue-700'
      }

      colors[type]
    end

    def icon
      icons = {
        notice: 'check-circle',
        error: 'exclamation-circle',
        alert: 'exclamation-triangle',
        info: 'information-circle'
      }

      icons[type]
    end
  end
end
