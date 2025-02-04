class ApplicationService
  Response = Struct.new(:success?, :payload, :error) do
    def failure?
      !success?
    end
  end

  def initialize(propagate: true)
    @propagate = propagate
  end

  def self.call(...)
    service = new(propagate: false)
    service.call(...)
  rescue StandardError => e
    service.failure(e)
  end

  def self.call!(...)
    new(propagate: true).call(...)
  end

  def success(payload = nil)
    Response.new(true, payload)
  end

  def failure(exception, _options = {})
    raise exception if @propagate

    Response.new(false, nil, exception)
  end
end
