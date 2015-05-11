class UsersController < ApplicationController
  def show
    @user = RubyStackoverflow.users_with_answers([params[:id]]).data.first
    render file: '/public/404', status: :not_found unless @user
  end
end
