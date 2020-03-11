class CompetitionVersionsController < ApplicationController

  def index
    @competition = Competition.find(params[:competition_id])
    @display_archive = params[:display_archive]
    if @display_archive
      @competition_versions = @competition.competition_versions.order(created_at: :desc)
    else
      @competition_versions = @competition.competition_versions.active.order(created_at: :desc)
    end
  end

  def new
    @competition = Competition.find(params[:competition_id])
  end

  def create
    @competition = Competition.find(params[:competition_id])
    competition_version = @competition.competition_versions.build(competition_version_params)
    json = params[:file]&.read
    competition_version.answer_data = json
    competition_version.save!
    redirect_to competition_competition_versions_path(@competition), notice: 'Successfully competition version created'
  rescue ActiveRecord::RecordInvalid => e
    logger.error(e.message)
    @error_messages = ['Failed. ' + e.message]
    render :new
  end

  def edit
    @competition_version = CompetitionVersion.find(params[:id])
  end

  def update
    @competition_version = CompetitionVersion.find(params[:id])
    if @competition_version.update(competition_version_params)
      redirect_to competition_competition_versions_path(@competition_version.competition), notice: 'Successfully competition version updated'
    else
      @error_messages = @competition_version.errors.full_messages
      render :edit
    end
  end

  def destroy
    cv = CompetitionVersion.find(params[:id])
    competition = cv.competition
    cv.destroy!
    redirect_to competition_competition_versions_path(competition), notice: 'Successfully competition version deleted'
  end

  private

  def competition_version_params
    params.require(:competition_version).permit(
        :version,
        :dataset_location,
        :note,
        :archived,
        :remark
    )
  end
end
