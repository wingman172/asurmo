class UserPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  def index?
  end

  def show?
    @current_user.admin? || @current_user == @user
  end

  def edit?
    @current_user == @user || @current_user.admin
  end

  def update?
    @current_user == @user
  end

  def destroy?
    return false if @current_user == @user
    @current_user.admin?
  end
end
