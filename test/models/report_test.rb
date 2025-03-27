# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @report = reports(:alice_report)
    @mentioned_report = reports(:bob_report)
    @alice = users(:alice)
    @bob = users(:bob)
  end

  test 'editable? returns true when user matches' do
    assert @report.editable?(@alice)
  end

  test 'editable? returns false when user does not match' do
    assert_not @report.editable?(@bob)
  end

  test 'created_on returns the date part of created_at' do
    assert_equal @report.created_at.to_date, @report.created_on
  end

  test 'saves links to existing report IDs' do
    @report.content = "http://localhost:3000/reports/#{@mentioned_report.id}"
    @report.save

    assert_includes @report.mentioning_reports, @mentioned_report
  end

  test 'does not save links to non-existent report IDs' do
    @report.content = 'http://localhost:3000/reports/99999'
    @report.save

    assert_empty @report.mentioning_reports
  end
end
