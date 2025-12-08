class Student < ApplicationRecord
  belongs_to :turma, optional: true 

  validates :matricula, presence: true, uniqueness: true
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end