class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to problems_path
    else
      render :new
    end
  end

  def index
  end

  def show
  end

  def edit
  end

  private

  def user_params
    # binding.pry
    params.require(:user).permit(:name, :email, :password)
  end
end
