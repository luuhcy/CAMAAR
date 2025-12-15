class Formulario < ApplicationRecord
  belongs_to :turma
  belongs_to :template

  has_many :respostas,
           class_name: 'Respostum',
           foreign_key: 'formulario_id',
           dependent: :destroy
end
