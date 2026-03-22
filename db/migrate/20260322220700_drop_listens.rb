class DropListens < ActiveRecord::Migration[8.1]
  def change
    drop_table :listens do |t|
      t.references :user, null: false, foreign_key: true
      t.references :song, null: false, foreign_key: true

      t.timestamps
    end
  end
end
