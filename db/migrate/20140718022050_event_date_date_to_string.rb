class EventDateDateToString < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.change :event_date, :string
    end
  end
end
