class Post < ApplicationRecord

    has_one_attached :image
    belongs_to :user
    has_many :comments, dependent: :destroy
    has_many :favorites, dependent: :destroy

    validates :location, presence: true, length: { maximum: 15 }
    validates :text, presence: true, length: { maximum: 195 }

    # kind が DB にない環境でも enum が動くように明示的に型を宣言
    attribute :kind, :integer, default: 0

    enum status: { published: 0, draft: 1 }
    enum kind: { diary: 0, board: 1 }

    def favorited_by?(user)
      favorites.where(user_id: user.id).exists?
    end
end
