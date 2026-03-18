class AdjustUsersForDeviseEmail < ActiveRecord::Migration[8.1]
  def up
    add_column :users, :email, :string, null: false, default: ""

    execute <<~SQL
      UPDATE users
      SET email = email_address
      WHERE email = '' OR email IS NULL
    SQL

    add_index :users, :email, unique: true

    remove_index :users, :email_address
    remove_column :users, :email_address
    remove_column :users, :password_digest
  end

  def down
    add_column :users, :email_address, :string, null: false, default: ""
    add_column :users, :password_digest, :string, null: false, default: ""
    add_index :users, :email_address, unique: true

    execute <<~SQL
      UPDATE users
      SET email_address = email
      WHERE email_address = '' OR email_address IS NULL
    SQL

    remove_index :users, :email
    remove_column :users, :email
  end
end
