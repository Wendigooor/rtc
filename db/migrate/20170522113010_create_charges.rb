class CreateCharges < ActiveRecord::Migration[5.0]
  def change
    create_table :charges do |t|
      t.references :user, foreign_key: true
      t.references :product, foreign_key: true
      t.text :response

      t.timestamps
    end
  end
end
