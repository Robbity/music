class CreateSongs < ActiveRecord::Migration[8.1]
  def change
    create_table :songs do |t|
      t.string :title
      t.references :user, null: false, foreign_key: true
      t.integer :plays_count

      t.timestamps
    end
  end
end
