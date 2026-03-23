class CreateDailySongs < ActiveRecord::Migration[8.1]
  def change
    create_table :daily_songs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :song, null: false, foreign_key: true
      t.date :date, null: false

      t.timestamps
    end

    add_index :daily_songs, %i[user_id date], unique: true
  end
end
