class UsersController < ApplicationController
  include WorldMembersHelper
  before_action :authenticate_user!
  before_action :set_user, :only => [:show, :destroy, :update, :edit, :about, :friends]
  before_action :set_status, :only => [:show]
  before_action :set_album, :only => [:show]

  def index
  	respond_to do |format|
      format.html { @users = User.all }
      if params[:term]
        format.json { @users = User.search(params[:term]) }
      else
        format.json { @users = User.all }
      end
    end
  end

  def show
    @activities = Activity.where("user_id = ? OR to_id = ?", @user.id, @user.id).order(:created_at => :desc).page(params[:page]).per(2)
    @notifications = Notification.where(:recipient => current_user).limit(8)
  end

  def about
  end

  def friends
  end

  def edit
    authorize @user
    @countries = Country.all
  end

  def update
    authorize @user

    if @user.update_attributes(user_params)
      update_world_member(user_params, @user)
      redirect_to edit_user_path(@user), :success => "User updated"
    else
      redirect_to edit_user_path(@user), :alert => "Unable to update user"
    end
  end

  def update_avatar
    if current_user.update_attributes(user_avatar)
      create_profile_album
      add_avatar_to_profile_album
      redirect_to user_path(current_user), :success => "Avatar is updated"
    else
      redirect_to user_path(current_user), :alert => "Unable to update avatar"
    end
  end

  def upload_cover
    if current_user.update_attributes(user_cover)
      redirect_to user_path(current_user), :success => "Cover is updated"
    else
      redirect_to user_path(current_user), :alert => "Unable to update cover"
    end
  end

  def destroy
    authorize @user
    @user.destroy
    redirect_to users_path, :notice => "User deleted"
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :gender, :avatar, :cover_image, :mobile_phone, :street, :zip_code, :dob, :employee_status, :activity_status, :qualification, :interest_list, :country_code, :city_id)
  end

  def user_avatar
    params.require(:user).permit(:avatar)
  end

  def user_cover
    params.require(:user).permit(:cover_image)
  end

  def set_user
    if params[:id]
      @user = User.friendly.find(params[:id])
    else
      @user = User.friendly.find(params[:user_id])
    end
  end

  def set_status
    @status = current_user.statuses.new
  end

  def create_profile_album
    if current_user.albums.where(:title => "Profile pictures").empty?
      album = current_user.albums.create(:title => "Profile pictures")
      album.save!
    end
  end

  def add_avatar_to_profile_album
    album = current_user.albums.where(:title => "Profile pictures").first
    picture = album.pictures.create(:user => current_user, :caption => "Profile picture", :picture => user_avatar[:avatar])
    picture.save!
  end

  def set_album
    @album = @user.albums.find_or_create_by(title: "Uncategorized")
    @picture = @album.pictures.new
  end
end
