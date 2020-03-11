# frozen_string_literal: true

# == Schema Information
#
# Table name: competitions
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  title        :string(255)      default("")
#  note         :text(65535)
#  metrics_type :integer
#  archived     :boolean          default(FALSE)
#  remark       :boolean          default(FALSE)
#

class Competition < ApplicationRecord
  has_many :competition_versions, dependent: :destroy

  validates :title, :metrics_type, presence: true

  scope :active, -> { where(archived: false) }

  enum metrics_type: %i[AUC mAP]

  def metrics_keys
    service = MetricServiceFactory.get_service(metrics_type)
    service.metric_keys
  end
end
