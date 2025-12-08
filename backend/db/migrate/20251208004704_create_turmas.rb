class CreateTurmas < ActiveRecord::Migration[8.0]
  def change
    create_table :turmas do |t|
      t.string :codigo_sigaa
      t.string :nome
      t.string :disciplina
      t.string :semestre
      t.integer :ano

      t.timestamps
    end
  end
end
