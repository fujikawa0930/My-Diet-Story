class StoriesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    # ストーリー一覧（解放済みのストーリーへのリンクを並べる）
  end

  def show
    @slug = params[:slug]
    # プロローグなど、slug に応じたコンテンツを表示
  end
end
