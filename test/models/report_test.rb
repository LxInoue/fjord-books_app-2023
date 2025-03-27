# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @report = reports(:alice_report)
    @mentioned_report = reports(:bob_report)
    @alice = users(:alice)
    @bob = users(:bob)
  end

  test "titleとcontentがあるときは有効になる" do
    assert @report.valid?
  end

  test "titleがないときは無効になる" do
    @report.title = nil
    assert_not @report.valid?
  end

  test "contentがないときは無効になる" do
    @report.content = nil
    assert_not @report.valid?
  end

  test "editable?はユーザーが一致する場合にtrueを返す" do
    assert @report.editable?(@alice)
  end

  test "editable?はユーザーが一致しない場合にfalseを返す" do
    assert_not @report.editable?(@bob)
  end

  test "created_onはcreated_atの日付部分を返す" do
    assert_equal @report.created_at.to_date, @report.created_on
  end

  test "存在するIDのリンクを保存する" do
    @report.content = "http://localhost:3000/reports/#{@mentioned_report.id}"
    @report.save

    assert_includes @report.mentioning_reports, @mentioned_report
  end

  test "存在しないIDのリンクは保存されない" do
    @report.content = "http://localhost:3000/reports/99999"
    @report.save

    assert_empty @report.mentioning_reports
  end
end
