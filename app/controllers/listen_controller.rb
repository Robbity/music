class ListenController < ApplicationController
  def index
    @song = user_signed_in? ? random_song_for_user : song_of_the_day
    if user_signed_in? && @song.present?
      @user_rating = current_user.ratings.find_by(song: @song)
      current_user.listens.find_or_create_by(song: @song)
    end
    if user_signed_in? && params[:prompt_rating_id].present?
      @prompt_rating = current_user.ratings.find_by(id: params[:prompt_rating_id])
    end
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

    def random_song_for_user
      base = Song
        .with_attached_artwork
        .with_attached_audio_file
        .includes(:user)
        .where.not(user_id: current_user.id)

      listened_ids = current_user.listens.select(:song_id)
      rated_ids = current_user.ratings.select(:song_id)

      base
        .where.not(id: listened_ids)
        .where.not(id: rated_ids)
        .order(Arel.sql("RANDOM()"))
        .first
    end
end
