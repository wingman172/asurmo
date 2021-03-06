class Admin::UsersController < Admin::BaseController
  before_action :authenticate_admin
  before_action :set_user, :only => [:destroy, :update, :edit, :about, :block, :unblock]

  def index
     @users = User.all.where.not(:id => current_user.id).where.not(:id => 2)
  end

  def show
    @users = User.all.where.not(:id => current_user.id)
  end

  def about
  end

  def destroy
    authorize @user
    @user.destroy
    redirect_to users_path, :notice => "User deleted"
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to edit_admin_user_path(@user), :notice => "User updated successfully"
    else
      redirect_to edit_admin_user_path(@user), :alert => "Unable to update user"
    end
  end

  def update_avatar
    if current_user.update_attributes(user_avatar)
      redirect_to user_path(current_user), :success => "Avatar is updated"
    else
      redirect_to user_path(current_user), :alert => "Unable to update avatar"
    end
  end

  def block
    @user.blocked = true
    @user.save
    redirect_to :back
  end

  def unblock
    @user.blocked = false
    @user.save
    redirect_to :back
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :gender, :mobile_phone, :street, :zip_code, :dob, :employee_status, :activity_status, :qualification, :interest_ids => [])
    end

    def user_avatar
      params.require(:user).permit(:avatar)
    end

    def set_user
      if params[:id]
        @user = User.friendly.find(params[:id])
      else
        @user = User.friendly.find(params[:user_id])
      end
    end
end
