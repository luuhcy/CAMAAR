class AddUniquenessConstraintToTurmas < ActiveRecord::Migration[8.0]
  def change
    # Remover índice anterior se existir
    remove_index :turmas, :codigo_sigaa, if_exists: true
    
    # Adicionar índice único composto por codigo_sigaa + semestre
    add_index :turmas, [:codigo_sigaa, :semestre], unique: true
  end
end
