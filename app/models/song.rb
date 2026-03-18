class Song < ApplicationRecord
  belongs_to :user
  has_many :ratings, dependent: :destroy

  has_one_attached :audio_file
  has_one_attached :artwork

  validates :title, presence: true
  validates :audio_file, presence: true

  validate :audio_file_type_and_size
  validate :artwork_type_and_size

  MAX_AUDIO_SIZE = 20.megabytes
  MAX_ARTWORK_SIZE = 5.megabytes
  AUDIO_CONTENT_TYPES = [
    "audio/mpeg",
    "audio/mp3",
    "audio/wav",
    "audio/x-wav",
    "audio/wave",
    "audio/vnd.wave"
  ].freeze
  ARTWORK_CONTENT_TYPES = [ "image/jpeg", "image/png" ].freeze

  private
    def audio_file_type_and_size
      return unless audio_file.attached?

      if audio_file.blob.byte_size > MAX_AUDIO_SIZE
        errors.add(:audio_file, "must be smaller than #{MAX_AUDIO_SIZE / 1.megabyte}MB")
      end

      unless AUDIO_CONTENT_TYPES.include?(audio_file.blob.content_type)
        errors.add(:audio_file, "must be a MP3 or WAV")
      end
    end

    def artwork_type_and_size
      return unless artwork.attached?

      if artwork.blob.byte_size > MAX_ARTWORK_SIZE
        errors.add(:artwork, "must be smaller than #{MAX_ARTWORK_SIZE / 1.megabyte}MB")
      end

      unless ARTWORK_CONTENT_TYPES.include?(artwork.blob.content_type)
        errors.add(:artwork, "must be a JPEG or PNG")
      end
    end
end
