class Song < ApplicationRecord
  belongs_to :user

  has_one_attached :audio_file
  has_one_attached :artwork

  validates :title, presence: true
  validates :audio_file, presence: true
end
