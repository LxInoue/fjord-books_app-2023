# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[show edit update destroy]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)

    if @report.save
      update_mentions(@report)
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @report.update(report_params)
      update_mentions(@report)
      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy

    update_mentions(@report)
    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = Report.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end

  def update_mentions(report)
    report.report_mentions_as_mentioning.destroy_all

    mentioned_report_ids = report.content.scan(%r{http://localhost:3000/reports/(\d+)}).flatten.map(&:to_i)
    mentioned_reports = Report.where(id: mentioned_report_ids)

    mentioned_reports.each do |mentioned_report|
      ReportMention.create!(mentioning_report: report, mentioned_report: mentioned_report)
    end
  end
end
