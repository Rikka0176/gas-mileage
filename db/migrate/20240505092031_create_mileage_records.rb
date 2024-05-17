class CreateMileageRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :mileage_records do |t|
      t.float :distance
      t.float :fuel_amount
      t.references :car, null: false, foreign_key: true

      t.timestamps
    end
  end
end
