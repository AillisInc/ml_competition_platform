# == Schema Information
#
# Table name: competition_versions
#
#  id               :bigint           not null, primary key
#  version          :string(255)
#  competition_id         :bigint
#  dataset_location :string(255)
#  note             :text(65535)
#  archived         :boolean          default(FALSE)
#  remark           :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  answer_data      :text(4294967295)
#  answer_data_size :integer          default(0)
#

class CompetitionVersion < ApplicationRecord
  belongs_to :competition
  has_many :predict_logs, dependent: :destroy

  validates :version, :dataset_location, :answer_data, presence: true
  validate :json_format_valid?, if: Proc.new { |p| p.answer_data.present? }


  scope :active, -> { where(archived: false) }

  before_save :calculate_answer_data_size

  private

  def calculate_answer_data_size()
    self.answer_data_size = JSON.parse(answer_data).size
  end

  def json_format_valid?
    json = JSON.parse(answer_data)
    schema = MetricServiceFactory.get_service(competition.metrics_type).answer_json_schema
    JSON::Validator.validate!(schema, json)
    true
  rescue JSON::ParserError, JSON::Schema::ValidationError
    errors.add(:data, "Json format is invalid.")
    false
  end

end
