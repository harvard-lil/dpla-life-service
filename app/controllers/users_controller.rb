class UsersController < ApplicationController
  before_filter :auth_and_get_user, only: [:destroy]

  def create
    @user = User.create! params[:user]
    render :session, status: 201
  end

  def destroy
    @user.destroy
    head 204
  end
end