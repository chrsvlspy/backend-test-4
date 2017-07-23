class AddColumnsToCall < ActiveRecord::Migration[5.1]
  def change
    add_column :calls, :sid, :string
    add_index :calls, :sid, unique: true

    add_column :calls, :status, :integer, default: 0
    add_column :calls, :direction, :integer, default: 0
    add_column :calls, :from, :string
    add_column :calls, :to, :string
    add_column :calls, :from_country, :string
    add_column :calls, :to_country, :string
    add_column :calls, :duration, :integer, default: 0
    add_column :calls, :voicemail_file_url, :string
    add_column :calls, :voicemail_duration, :integer, default: 0
  end
end
