class CreateDispatches < ActiveRecord::Migration[6.0]
  def change
    create_table :dispatches do |t|
      t.string :address
      t.integer :passenger_id
      t.integer :driver_id
      t.datetime :requested_at
      t.datetime :accepted_at

      t.timestamps
    end
  end
end
