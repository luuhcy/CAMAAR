class Student < ApplicationRecord
  belongs_to :turma, optional: true 

  validates :matricula, presence: true, uniqueness: true
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  
  # Validar que o aluno não está em outra turma com o mesmo codigo_sigaa no mesmo semestre
  validate :unique_turma_per_semester, if: proc { turma.present? }

  private

  def unique_turma_per_semester
    # Verificar se existe alguma outra turma com o mesmo codigo_sigaa e semestre para este aluno
    turma_duplicada = Student
      .joins(:turma)
      .where(matricula: matricula)
      .where.not(id: id) # Excluir o próprio registro (em caso de update)
      .where(turmas: { codigo_sigaa: turma.codigo_sigaa, semestre: turma.semestre })
      .exists?

    if turma_duplicada
      errors.add(:turma, "O aluno já está matriculado em outra turma com o mesmo código SIGAA neste semestre")
    end
  end
end