class CreateQuestaos < ActiveRecord::Migration[8.0]
  def change
    create_table :questaos do |t|
      t.string :texto
      t.string :tipo
      t.boolean :obrigatoria
      t.integer :ordem
      t.text :opcoes
      t.references :template, null: false, foreign_key: true

      t.timestamps
    end
  end
end
