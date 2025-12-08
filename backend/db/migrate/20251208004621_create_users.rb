class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :matricula
      t.string :nome
      t.string :password_digest
      t.string :tipo

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :matricula, unique: true
  end
end
