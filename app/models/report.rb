# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :report_mentions_as_source,
           class_name: 'ReportMention',
           foreign_key: 'mentioning_report_id',
           dependent: :destroy,
           inverse_of: :mentioning_report

  has_many :mentioning_reports,
           through: :report_mentions_as_source,
           source: :mentioned_report

  has_many :report_mentions_as_target,
           class_name: 'ReportMention',
           foreign_key: 'mentioned_report_id',
           dependent: :destroy,
           inverse_of: :mentioned_report

  has_many :mentioned_reports,
           through: :report_mentions_as_target,
           source: :mentioning_report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def update_mentions
    transaction do
      report_mentions_as_source.destroy_all

      mentioned_report_ids = content.scan(%r{http://localhost:3000/reports/(\d+)}).flatten.map(&:to_i)
      mentioned_reports = Report.where(id: mentioned_report_ids)

      mentioned_reports.each do |mentioned_report|
        ReportMention.create!(mentioning_report: self, mentioned_report: mentioned_report)
      end
    end
  end
end
