class SongsController < ApplicationController
  before_action :authenticate_user!

  def index
    @songs = current_user.songs
      .with_attached_artwork
      .includes(:ratings)
      .order(created_at: :desc)
  end

  def new
    @song = current_user.songs.new
  end

  def create
    @song = current_user.songs.new(song_params)

    if @song.save
      redirect_to songs_path, notice: "Song uploaded."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def song_params
      params.require(:song).permit(:title, :audio_file, :artwork)
    end
end
