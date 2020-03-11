# frozen_string_literal: true

class MetricsService
  class ApiError < StandardError; end

  def initialize
    @metrics_api = Faraday.new(
      url: ENV['METRICS_API_ENDPOINT'],
      headers: { 'Content-Type' => 'application/json',
                 'X-Authorization-Key' => ENV['METRICS_API_AUTH_KEY'] }
    )
  end

  def metrics(type, answer_json, prediction_json)
    y_true, y_pred = request_data(type, answer_json, prediction_json)

    res = @metrics_api.post("/metrics/#{type}", {y_true: y_true, y_pred: y_pred}.to_json)
    data = JSON.parse(res.body)
    raise ApiError, data['message'] unless res.status == 200

    data['metrics']
  end

  private

  def request_data(type, answer_json, prediction_json)
    service = MetricServiceFactory.get_service(type)
    service.request_data(answer_json, prediction_json)
  end

end
