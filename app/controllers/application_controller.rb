class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:index, :show]
  skip_before_action :verify_authenticity_token, only: [:remove_white_bg]

  def after_sign_in_path_for(resource)
    if resource.first_login?
      resource.update(first_login: false)
      welcome_path
    else
      items_path
    end
  end

  private

  def redirect_first_login
    return unless user_signed_in?
    return unless request.get?
    return if request.path.in?([
      how_to_path,
      new_item_path,
      destroy_user_session_path,
      root_path,
      new_user_registration_path,
      user_registration_path
    ])
    return if current_user&.first_login == false 

    redirect_to how_to_path
  end
end
