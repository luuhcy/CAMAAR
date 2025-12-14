class ChangeDataRespostaTypeToText < ActiveRecord::Migration[8.0]
  def change
    change_column :resposta, :data_resposta, :text
  end
end
