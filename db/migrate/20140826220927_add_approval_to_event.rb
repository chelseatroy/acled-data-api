class AddApprovalToEvent < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.boolean  :approved, default: false
    end
  end
end
