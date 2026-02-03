class UsersController < ApplicationController
  def index
    @users = User.page(params[:page]).per(5).reverse_order
  end
  
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(8).reverse_order
    @following_users = @user.following_user
    @follower_users = @user.follower_user
    return unless @user == current_user

    @weight_record = @user.weights.build
    year = params[:weight_year].to_i
    month = params[:weight_month].to_i
    @calendar_date = (year.positive? && month.positive?) ? Date.new(year, month, 1) : Date.current.beginning_of_month
    @weights_by_date = @user.weights.where(date: @calendar_date.beginning_of_month..@calendar_date.end_of_month).index_by(&:date)
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(@user.id)
  end

  def follows
    @user = User.find(params[:id])
    @users = @user.following_user.page(params[:page]).per(3).reverse_order
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.follower_user.page(params[:page]).per(3).reverse_order
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :profile, :profile_image)
  end
end
