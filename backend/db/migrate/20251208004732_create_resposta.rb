class CreateResposta < ActiveRecord::Migration[8.0]
  def change
    create_table :resposta do |t|
      t.datetime :data_resposta
      t.string :status
      t.references :user, null: false, foreign_key: true
      t.references :formulario, null: false, foreign_key: true

      t.timestamps
    end
  end
end
