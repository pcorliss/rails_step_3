class CreateDev < ActiveRecord::Migration
  def change
    create_table :devs do |t|
      t.string :name
      t.string :description
      t.string :url
    end
  end
end
