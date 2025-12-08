class Template < ApplicationRecord
  belongs_to :user
  has_many :questoes, dependent: :destroy # Se apagar template, apaga as questões
  has_many :formularios
end