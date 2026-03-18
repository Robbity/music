class RatingsController < ApplicationController
  before_action :authenticate_user!

  def create
    song = Song.find(params[:rating][:song_id])

    if song.user_id == current_user.id
      redirect_to listen_path, alert: "You cannot rate your own song."
      return
    end

    if current_user.ratings.exists?(song_id: song.id)
      redirect_to listen_path, alert: "You already rated that song."
      return
    end

    rating = current_user.ratings.new(song: song, stars: params[:rating][:stars])

    if rating.save
      redirect_to listen_path, notice: "Thanks for rating."
    else
      redirect_to listen_path, alert: rating.errors.full_messages.to_sentence
    end
  end
end
