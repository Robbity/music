class LibraryController < ApplicationController
  before_action :authenticate_user!

  def index
    @ratings = current_user.ratings
      .includes(song: [ :user, { artwork_attachment: :blob } ])
      .order(created_at: :desc)
  end
end
