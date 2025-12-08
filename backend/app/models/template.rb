class Template < ApplicationRecord
  belongs_to :user
  has_many :questoes, class_name: 'Questao', dependent: :destroy
  has_many :formularios
end