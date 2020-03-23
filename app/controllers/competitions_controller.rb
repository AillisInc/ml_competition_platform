# frozen_string_literal: true

class CompetitionsController < ApplicationController
  before_action :only_admin!, except: [:index]

  def index
    @display_archive = params[:display_archive]
    if @display_archive
      @competitions = Competition.all.order(created_at: :desc)
    else
      @competitions = Competition.active.order(created_at: :desc)
    end
  end

  def show
    @competition = Competition.find(params[:id])
  end

  def new; end

  def create
    competition = Competition.new(competitions_params)
    competition.save!

    redirect_to root_url, notice: 'Successfully competition created'
  rescue ActiveRecord::RecordInvalid => e
    logger.error(e)
    @error_messages = ['Failed. ' + e.message]
    render :new
  end

  def edit
    @competition = Competition.find(params[:id])
  end

  def update
    @competition = Competition.find(params[:id])
    if @competition.update(competitions_params)
      redirect_to root_url, notice: 'Successfully competition updated'
    else
      @error_messages = @competition.errors.full_messages
      render :edit
    end
  end

  def destroy
    competition = Competition.find(params[:id])
    competition.destroy!
    redirect_to root_url, notice: 'Successfully competition deleted'
  end

  private

  def competitions_params
    params.require(:competition).permit(
      :title,
      :metrics_type,
      :note,
      :archived,
      :remark
    )
  end
end
