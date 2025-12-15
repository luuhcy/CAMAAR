# Modelo que representa um Aluno (Student) no sistema.
# Armazena os dados pessoais e acadêmicos, além de gerenciar a vinculação com as turmas.
#
# == Schema Information:
# * Tabela: +students+
# * Colunas: +name+, +matricula+, +email+, +turma_id+
#
# == Associations:
# * +turma+ - A turma atual em que o aluno está matriculado (pode ser nulo/opcional).
class Student < ApplicationRecord
  # Associação: Pertence a uma Turma, mas é opcional (o aluno pode existir sem estar em uma turma).
  belongs_to :turma, optional: true 

  # Validações Básicas:
  # * +matricula+: Obrigatória e única no sistema.
  # * +name+: Obrigatório.
  # * +email+: Obrigatório e único.
  validates :matricula, presence: true, uniqueness: true
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  
  # Validação Customizada:
  # Garante que o aluno não seja matriculado em duas turmas da mesma disciplina (mesmo código SIGAA)
  # no mesmo semestre letivo. Só é executada se o aluno já estiver associado a uma turma.
  validate :unique_turma_per_semester, if: proc { turma.present? }

  private

  # Método auxiliar para a validação customizada.
  # Verifica no banco de dados se existe outro registro de Student com a mesma matrícula,
  # associado a uma turma que tenha o mesmo código SIGAA e semestre da turma atual.
  #
  # == Side Effects:
  # * Adiciona um erro ao atributo +:turma+ se a duplicidade for encontrada.
  def unique_turma_per_semester
    # Verifica se existe alguma outra turma com o mesmo codigo_sigaa e semestre para este aluno
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