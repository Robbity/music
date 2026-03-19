class ListenController < ApplicationController
  def index
    @song = next_song_for(user_signed_in? ? current_user : nil)
    @song&.increment!(:plays_count)
  end

  private
    def next_song_for(user)
      scope = Song
        .with_attached_artwork
        .with_attached_audio_file
        .includes(:user)

      if user
        scope = scope
          .where.not(user_id: user.id)
          .where.not(id: Rating.where(user_id: user.id).select(:song_id))
      end

      scope.order(Arel.sql("RANDOM()"))
        .first
    end
end
