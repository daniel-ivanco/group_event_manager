class CreateGroupEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :group_events do |t|
      t.date :start_date
      t.date :end_date
      t.integer :duration
      t.string :name
      t.text :description
      t.boolean :published, default: false
      t.boolean :enabled, default: true
      t.float :latitude
      t.float :longitude
      t.integer :user_id

      t.timestamps
    end
  end
end
