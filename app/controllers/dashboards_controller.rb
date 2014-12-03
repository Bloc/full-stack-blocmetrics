class DashboardsController < ApplicationController

  before_filter :authenticate_user!

  def show
    @domains = current_user.domains
  end
end
