class AddArtworkColorToSongs < ActiveRecord::Migration[8.1]
  def change
    add_column :songs, :artwork_color, :string

    reversible do |dir|
      dir.up do
        palette = [
          "#efe6df",
          "#f0e8d7",
          "#e6ece8",
          "#e5e1f0",
          "#f0e5ea",
          "#e6edf2",
          "#efe9d8"
        ]

        Song.reset_column_information
        Song.find_each do |song|
          next if song.artwork_color.present?

          song.update_columns(artwork_color: palette.sample)
        end
      end
    end
  end
end
