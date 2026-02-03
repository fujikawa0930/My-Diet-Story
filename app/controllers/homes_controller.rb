class HomesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:top, :contact, :contact_submit]

  def top
  end

  def contact
  end

  def contact_submit
    redirect_to root_path, notice: "お問い合わせを受け付けました。"
  end
end
  