class Respostum < ApplicationRecord
  belongs_to :user
  belongs_to :formulario

  serialize :data_resposta, coder: JSON
end
