class AddSavedToLibraryToRatings < ActiveRecord::Migration[8.1]
  def change
    add_column :ratings, :saved_to_library, :boolean, default: false, null: false
  end
end
