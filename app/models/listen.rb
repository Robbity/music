class Listen < ApplicationRecord
  belongs_to :user
  belongs_to :song

  validates :song_id, uniqueness: { scope: :user_id }
end
