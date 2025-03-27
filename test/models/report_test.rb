# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test "titleとcontentがあるときは有効になる" do
    report = reports(:alice_report)
    assert report.valid?
  end

  test "titleがないときは無効になる" do
    report = reports(:alice_report)
    report.title = nil
    assert_not report.valid?
  end

  test "contentがないときは無効になる" do
    report = reports(:alice_report)
    report.content = nil
    assert_not report.valid?
  end

  test "editable?はユーザーが一致する場合にtrueを返す" do
    report = reports(:alice_report)
    user = users(:alice)
    assert report.editable?(user)
  end

  test "editable?はユーザーが一致しない場合にfalseを返す" do
    report = reports(:alice_report)
    user = users(:bob)
    assert_not report.editable?(user)
  end

  test "created_onはcreated_atの日付部分を返す" do
    report = reports(:alice_report)
    assert_equal report.created_at.to_date, report.created_on
  end

  test "存在するIDのリンクを保存する" do
    report = reports(:alice_report)
    mentioned_report = reports(:bob_report)
    report.content = "http://localhost:3000/reports/#{mentioned_report.id}"
    report.save

    assert_includes report.mentioning_reports, mentioned_report
  end

  test "存在しないIDのリンクは保存されない" do
    report = reports(:alice_report)
    report.content = "http://localhost:3000/reports/99999"
    report.save

    assert_empty report.mentioning_reports
  end
end
