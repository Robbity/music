class DashboardController < ApplicationController
  before_action :require_authentication

  def show
    @user = Current.session.user
  end
end
