class CreateStudents < ActiveRecord::Migration[8.0]
  def change
    create_table :students do |t|
      t.string :name
      t.string :matricula
      t.string :email
      t.references :turma, null: false, foreign_key: true

      t.timestamps
    end
    add_index :students, :matricula, unique: true
  end
end
