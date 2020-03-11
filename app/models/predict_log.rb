# frozen_string_literal: true

# == Schema Information
#
# Table name: predict_logs
#
#  id               :bigint           not null, primary key
#  commit_hash      :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
#  note             :text(65535)
#  data             :text(4294967295)
#  metrics_data     :string(255)
#  repository_name  :string(255)
#  competition_version_id :bigint
#

class PredictLog < ApplicationRecord
  belongs_to :user
  belongs_to :competition_version

  attr_accessor :valid_json, :need_slack_notification

  validates :data, presence: true
  validates :commit_hash, presence: true
  validates :repository_name, presence: true
  validate :validate_json_format
  validate :validate_key_match, if: :json_format_valid?

  before_save :check_and_notify_sota

  class << self
    def sort(predict_logs, sort_key)
      predict_logs if sort_key.blank?
      predict_logs.sort do |pred1, pred2|
        metrics1 = pred1.metrics
        metrics2 = pred2.metrics
        metrics2[sort_key] <=> metrics1[sort_key]
      end
    end

    def format_metrics(metrics)
      if metrics.is_a?(Numeric)
        metrics.round(5)
      elsif metrics.nil?
        ""
      else
        metrics
      end
    end

  end

  def prediction_probability
    predictions.map { |pred| pred['probability'] }
  end

  def metrics
    JSON.parse(metrics_data)
  rescue StandardError
    {}
  end

  private

  def check_and_notify_sota
    return if metrics_data.blank? || !need_slack_notification

    service = MetricServiceFactory.get_service(competition_version.competition.metrics_type)
    key_metric = service.metric_for_sota
    this_metrics = JSON.parse(metrics_data)[key_metric]

    existing_metrics_list = competition_version.predict_logs.where.not(id: id).map do |p|
      return nil if p.metrics_data.nil?
      JSON.parse(p.metrics_data)[key_metric]
    end

    existing_metrics_list = existing_metrics_list.compact
    existing_max_metrics = existing_metrics_list.max

    notification_message = nil

    competition_title = competition_version.competition.title
    version = competition_version.version

    if existing_max_metrics.nil?
      notification_message = "First result at *#{competition_title}(#{version})* has been submitted!\n"
      notification_message += common_slack_message(key_metric, this_metrics)
    elsif this_metrics > existing_max_metrics
      notification_message = "The latest SOTA at *#{competition_title}(#{version})* result has been submitted!\n"
      notification_message += common_slack_message(key_metric, this_metrics)
    end

    SlackNotifierService.notify(notification_message, ":tada:") unless notification_message.nil?

  end

  def common_slack_message(key_metric, key_metric_value)
    message = "*#{key_metric}: #{PredictLog.format_metrics(key_metric_value)}*\n"

    other_metrics = ""
    competition_version.competition.metrics_keys.each do |metric_key|
      next if metric_key == key_metric
      other_metrics_value = metrics[metric_key]
      other_metrics_value = PredictLog.format_metrics(other_metrics_value)
      other_metrics += "#{metric_key}: #{other_metrics_value}\n"
    end
    message += other_metrics

    message += "User: #{user.name}\n"
    message += "Repository: #{repository_name}\n"
    message += "Commit hash: #{commit_hash}\n"
    message += "Note: #{note}\n"
    return message
  end

  def validate_key_match
    service = MetricServiceFactory.get_service(competition_version.competition.metrics_type)
    errors.add(:data, "Key: #{service.unique_key} between predictions and answers does not match.") unless match_answer_key?(service.unique_key)
  end

  def validate_json_format
    json = JSON.parse(data)
    schema = MetricServiceFactory.get_service(competition_version.competition.metrics_type).prediction_json_schema
    JSON::Validator.validate!(schema, json)
    @valid_json = true
  rescue JSON::ParserError, JSON::Schema::ValidationError
    errors.add(:data, "Json format is invalid.")
    @valid_json = false
  ensure
    @valid_json
  end

  def json_format_valid?
    @valid_json
  end

  def match_answer_key?(key)
    prediction_patients = JSON.parse(data).map { |i| i[key] }
    answer_patients = JSON.parse(competition_version.answer_data).map { |i| i[key] }
    prediction_patients = Set.new(prediction_patients)
    answer_patients = Set.new(answer_patients)
    answer_patients == prediction_patients
  end

end
