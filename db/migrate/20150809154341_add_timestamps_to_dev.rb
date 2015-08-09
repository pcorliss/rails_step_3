class AddTimestampsToDev < ActiveRecord::Migration
  def change
    add_column(:devs, :created_at, :datetime)
    add_column(:devs, :updated_at, :datetime)
  end
end
