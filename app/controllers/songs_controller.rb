class SongsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: :play
  before_action :set_upload_state, only: %i[new create]

  def index
    base = current_user.songs
      .with_attached_artwork
      .with_attached_audio_file
      .includes(:ratings)

    @songs = case params[:sort]
    when "plays"
               base.order(plays_count: :desc)
    when "rating"
               base.left_joins(:ratings)
                   .group(:id)
                   .order(Arel.sql("AVG(ratings.stars) DESC NULLS LAST"))
    else
               base.order(created_at: :desc)
    end
  end

  def new
    @song = current_user.songs.new
  end

  def create
    @song = current_user.songs.new(song_params)

    if @upload_locked
      @song.errors.add(:base, "You can upload one song per day.")
      render :new, status: :unprocessable_entity
      return
    end

    if @song.save
      redirect_to songs_path, notice: "Song uploaded."
    else
      @upload_locked = upload_limit_reached?
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    song = current_user.songs.find(params[:id])
    song.destroy
    redirect_to songs_path, notice: "Song deleted."
  end

  def play
    song = Song.find(params[:id])
    song.increment!(:plays_count)
    head :ok
  end

  private
    def song_params
      params.require(:song).permit(:title, :audio_file, :artwork)
    end

    def set_upload_state
      @upload_locked = upload_limit_reached?
      @next_upload_at = Time.zone.tomorrow.beginning_of_day
    end

    def upload_limit_reached?
      current_user.songs.where(created_at: Time.zone.today.all_day).exists?
    end
end
