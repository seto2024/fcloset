class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:terms, :privacy]
  skip_before_action :redirect_first_login, only: [:terms, :privacy]

  def terms; end
  def privacy; end
end
