class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def show
    @user = User.friendly.find(params[:id])
  end

  def destroy
    user = User.friendly.find(params[:id])
    authorize user
    user.destroy
    redirect_to users_path, :notice => "User deleted"
  end

  def update
    @user = User.friendly.find(params[:id])
    authorize @user

    if @user.update_attributes(user_params)
      redirect_to users_path, :success => "User updated"
    else
      redirect_to users_path, :alert => "Unable to update user"
    end
  end

  def update_avatar
    if current_user.update_attributes(user_avatar)
      redirect_to user_path(current_user), :success => "Avatar is updated"
    else
      redirect_to user_path(current_user), :alert => "Unable to update avatar"
    end
  end

  private
    def user_params
      params.require(:user).permit(:role)
    end

    def user_avatar
      params.require(:user).permit(:avatar)
    end
end
