class SettingsController < ApplicationController
  before_action :require_login
  skip_before_action :redirect_first_login

  def show
  end
end
