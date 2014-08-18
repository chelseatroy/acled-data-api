class SwitchBait < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.remove :event_date
      t.rename :date, :event_date
    end
  end
end
