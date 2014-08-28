class AddIpToEvents < ActiveRecord::Migration
  def change
    add_column :events, :ip_address, :string
  end
end
