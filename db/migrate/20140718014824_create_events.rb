class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.date :event_date
      t.integer :year
      t.string :event_type
      t.string :actor1
      t.string :actor2
      t.integer :interaction
      t.string :country
      t.string :source
      t.text :notes
      t.integer :total_fatalities
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end
  end
end
