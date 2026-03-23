class DailySong < ApplicationRecord
  belongs_to :user
  belongs_to :song

  validates :date, presence: true
  validates :user_id, uniqueness: { scope: :date }
end
