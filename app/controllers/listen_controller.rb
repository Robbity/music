class ListenController < ApplicationController
  before_action :authenticate_user!

  def index
    @song = next_song_for(current_user)
    @song&.increment!(:plays_count)
  end

  private
    def next_song_for(user)
      Song
        .where.not(user_id: user.id)
        .where.not(id: Rating.where(user_id: user.id).select(:song_id))
        .with_attached_artwork
        .with_attached_audio_file
        .includes(:user)
        .order(Arel.sql("RANDOM()"))
        .first
    end
end
