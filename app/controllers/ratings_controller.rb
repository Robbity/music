class RatingsController < ApplicationController
  before_action :authenticate_user!

  def create
    song = Song.find(params[:rating][:song_id])

    if song.user_id == current_user.id
      redirect_to listen_index_path, alert: "You cannot rate your own song."
      return
    end

    if current_user.ratings.exists?(song_id: song.id)
      redirect_to listen_index_path, alert: "You already rated that song."
      return
    end

    rating = current_user.ratings.new(song: song, stars: params[:rating][:stars], saved_to_library: false)

    respond_to do |format|
      if rating.save
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "listen-actions",
            partial: "listen/library_prompt",
            locals: { rating: rating }
          )
        end
        format.html { redirect_to listen_index_path }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "listen-actions",
            partial: "listen/rating_form",
            locals: { song: song, errors: rating.errors }
          )
        end
        format.html { redirect_to listen_index_path }
      end
    end
  end

  def update
    rating = current_user.ratings.find(params[:id])
    rating.update!(saved_to_library: true)
    redirect_to listen_index_path
  end

  def destroy
    rating = current_user.ratings.find(params[:id])
    rating.destroy
    redirect_to library_index_path, notice: "Removed from your library."
  end
end
