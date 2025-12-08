class Turma < ApplicationRecord
  has_many :students
  has_many :formularios

  before_validation :set_ano_from_semestre

  validates :codigo_sigaa, presence: true
  validates :semestre, presence: true

  private

  def set_ano_from_semestre
    if self.semestre.present?
      self.ano = self.semestre.split('/').last.to_i
    end
  end
end