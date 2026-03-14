class ApplicationController < ActionController::Base
  before_action :redirect_first_login
  skip_before_action :verify_authenticity_token, only: [:update, :remove_white_bg]

  private

  def redirect_first_login
    return unless user_signed_in?
    return unless request.get?
    return if request.path.in?([
      how_to_path,
      welcome_path,
      new_item_path,
      destroy_user_session_path,
      root_path,
      new_user_registration_path,
      user_registration_path,
      new_user_session_path,
      new_user_password_path
    ])
    return if current_user&.first_login == false

    redirect_to how_to_path
  end
end
