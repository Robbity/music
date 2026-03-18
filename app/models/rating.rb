class Rating < ApplicationRecord
  belongs_to :song
  belongs_to :user

  validates :stars, presence: true, inclusion: { in: 1..5 }
  validates :user_id, uniqueness: { scope: :song_id }
end
