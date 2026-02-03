class Weight < ApplicationRecord
  belongs_to :user
  validates :date, presence: true, uniqueness: { scope: :user_id }
  validates :value, presence: true, numericality: { greater_than: 0, less_than: 500 }
end
