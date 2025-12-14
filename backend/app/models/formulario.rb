class Formulario < ApplicationRecord
  belongs_to :turma

  has_many :respostas,
           class_name: 'Respostum',
           foreign_key: 'formulario_id',
           dependent: :destroy
end
