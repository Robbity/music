class ListenController < ApplicationController
  def index
    @song = user_signed_in? ? daily_song_for_user : guest_song_for_today
    if user_signed_in? && @song.present?
      @user_rating = current_user.ratings.find_by(song: @song)
    end
    if user_signed_in? && params[:prompt_rating_id].present?
      @prompt_rating = current_user.ratings.find_by(id: params[:prompt_rating_id])
    end
    @next_update_at = Time.zone.tomorrow.beginning_of_day
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

    def guest_song_for_today
      top = top_rated_song_today
      return top if top.present?

      song_of_the_day
    end

    def top_rated_song_today
      start_time = Time.zone.today.beginning_of_day
      end_time = Time.zone.today.end_of_day

      Song
        .with_attached_artwork
        .with_attached_audio_file
        .includes(:user)
        .joins(:ratings)
        .where(ratings: { created_at: start_time..end_time })
        .group(:id)
        .order(Arel.sql("AVG(ratings.stars) DESC, COUNT(ratings.id) DESC"))
        .first
    end

    def daily_song_for_user
      daily = current_user.daily_songs.find_by(date: Date.current)
      return daily.song if daily&.song

      song = random_song_for_user
      return nil unless song

      current_user.daily_songs.create!(song: song, date: Date.current)
      song
    end

    def random_song_for_user
      base = Song
        .with_attached_artwork
        .with_attached_audio_file
        .includes(:user)
        .where.not(user_id: current_user.id)

      rated_ids = current_user.ratings.select(:song_id)
      seen_ids = current_user.daily_songs.select(:song_id)

      base
        .where.not(id: rated_ids)
        .where.not(id: seen_ids)
        .order(Arel.sql("RANDOM()"))
        .first
    end
end
