class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.integer :user_id, index: { unique: true }, foreign_key: true
      t.integer :visibility, default: 0
      t.integer :photo_tagging, default: 0

      t.timestamps
    end
  end
end
