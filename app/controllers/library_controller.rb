class LibraryController < ApplicationController
  before_action :authenticate_user!

  def index
    @ratings = current_user.ratings
      .includes(song: [ :user, { artwork_attachment: :blob }, { audio_file_attachment: :blob } ])

    @ratings = case params[:sort]
    when "rating"
                 @ratings.order(stars: :desc, created_at: :desc)
    else
                 @ratings.order(created_at: :desc)
    end
  end
end
