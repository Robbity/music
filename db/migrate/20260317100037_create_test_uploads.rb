class CreateTestUploads < ActiveRecord::Migration[8.1]
  def change
    create_table :test_uploads do |t|
      t.string :name

      t.timestamps
    end
  end
end
