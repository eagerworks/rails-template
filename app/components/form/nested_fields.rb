module Form
  class NestedFields < Base
    attr_reader :form

    def initialize(form:)
      super()

      @form = form
    end

    def object_name
      form.object_name
    end

    def persisted?
      form.object.persisted?
    end

    def destroyed?
      form.object.marked_for_destruction?
    end
  end
end
