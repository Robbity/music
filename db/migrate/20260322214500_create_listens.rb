class CreateListens < ActiveRecord::Migration[8.1]
  def change
    create_table :listens do |t|
      t.references :user, null: false, foreign_key: true
      t.references :song, null: false, foreign_key: true

      t.timestamps
    end

    add_index :listens, %i[user_id song_id], unique: true
  end
end
