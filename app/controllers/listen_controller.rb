class ListenController < ApplicationController
  def index
    @song = song_of_the_day
    @song&.increment!(:plays_count)
  end

  private
    def song_of_the_day
      scope = Song
        .with_attached_artwork
        .with_attached_audio_file
        .includes(:user)
        .order(:id)

      count = scope.count
      return nil if count.zero?

      day_index = (Time.now.utc.to_i / 86_400) % count
      scope.offset(day_index).first
    end
end
