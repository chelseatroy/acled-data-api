class MakeLatLongPrecise < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.remove :latitude
      t.remove :longitude
      t.decimal  :latitude,         precision: 13, scale: 10
      t.decimal  :longitude,        precision: 13, scale: 10
    end
  end
end
