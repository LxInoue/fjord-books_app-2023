# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
