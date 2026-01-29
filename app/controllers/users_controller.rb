class UsersController < ApplicationController
  include Pagy::Backend

  def show
    @user = User.friendly.find(params[:username])
    @created_events = @user.events.includes(:location, :category, location: :city).recent
    @attended_events = @user.attended_events.includes(:location, :category, location: :city).upcoming
  end
end
