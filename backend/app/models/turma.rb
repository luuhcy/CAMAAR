class Turma < ApplicationRecord
  has_many :students
  has_many :formularios
end