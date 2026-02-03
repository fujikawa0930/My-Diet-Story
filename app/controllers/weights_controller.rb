class WeightsController < ApplicationController
  before_action :set_user
  before_action :ensure_own_page

  def create
    @weight = @user.weights.build(weight_params)
    if @weight.save
      redirect_to user_path(@user), notice: "体重を記録しました。"
    else
      redirect_to user_path(@user), alert: @weight.errors.full_messages.join("、")
    end
  end

  def destroy
    @weight = @user.weights.find(params[:id])
    @weight.destroy
    redirect_to user_path(@user), notice: "体重記録を削除しました。"
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def ensure_own_page
    redirect_to root_path unless @user == current_user
  end

  def weight_params
    params.require(:weight).permit(:date, :value)
  end
end
