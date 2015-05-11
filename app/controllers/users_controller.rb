class UsersController < ApplicationController
  def show
    @user = RubyStackoverflow.users_by_ids([params[:id]]).data.first
    render file: '/public/404', status: :not_found unless @user
  end
end
