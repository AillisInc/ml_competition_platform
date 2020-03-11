# frozen_string_literal: true

class PredictLogsController < ApplicationController
  def index
    @competition_version = CompetitionVersion.find(params[:competition_version_id])
    @predict_logs = @competition_version.predict_logs.includes(:user).order(created_at: :desc)
    if params[:sort]
      @predict_logs = @predict_logs.sort { |a, b| b.metrics[params[:sort]] <=> a.metrics[params[:sort]] }
    end
  end

  def show
    @predict_log = PredictLog.find(params[:id])
  end

  def sort
    @sort_key = params[:sort_key]
    index
    @predict_logs = PredictLog.sort(@predict_logs, @sort_key)
    render :index
  end

  def new
    @competition_version = CompetitionVersion.find(params[:competition_version_id])
  end

  def create
    @competition_version = CompetitionVersion.find(params[:competition_version_id])
    json = params[:file]&.read

    predict_log = @competition_version.predict_logs.build(predict_logs_params)
    predict_log.user = current_user
    predict_log.data = json
    predict_log.save!

    metrics = metrics_service.metrics(
      @competition_version.competition.metrics_type,
      @competition_version.answer_data,
      predict_log.data
    )

    predict_log.metrics_data = metrics.to_json
    predict_log.need_slack_notification = true
    predict_log.save!

    redirect_to competition_version_predict_logs_path(@competition_version), notice: 'Successfully uploaded prediction'
  rescue ActiveRecord::RecordInvalid, MetricsService::ApiError => e
    logger.error(e.message)
    @error_messages = ['Failed. ' + e.message]
    render :new
  end

  def edit
    @predict_log = PredictLog.find(params[:id])
  end

  def update
    @predict_log = PredictLog.find(params[:id])
    if @predict_log.update(predict_logs_params)
      redirect_to competition_version_predict_logs_path(@predict_log.competition_version), notice: 'Successfully updated prediction'
    else
      @error_messages = @predict_log.errors.full_messages
      render :edit
    end
  end

  def destroy
    predict_log = PredictLog.find(params[:id])
    predict_log.destroy!
    redirect_to competition_version_predict_logs_path(predict_log.competition_version), notice: 'Successfully deleted prediction'
  end

  private

  def predict_logs_params
    params.require(:predict_log).permit(
      :file,
      :commit_hash,
      :repository_name,
      :note
    )
  end

  def metrics_service
    MetricsService.new
  end
end
