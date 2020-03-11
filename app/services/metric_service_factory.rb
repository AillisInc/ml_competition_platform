class MetricServiceFactory

  class << self
    def get_service(service_type)
      sevice_class_name = "#{service_type.capitalize}Service"
      Object.const_get(sevice_class_name).new
    end
  end

end