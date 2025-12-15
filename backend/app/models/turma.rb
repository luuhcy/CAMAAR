# Modelo que representa uma Turma (oferta de disciplina) no sistema.
# Agrupa os alunos e os formulários de avaliação aplicados em um determinado período letivo.
#
# == Schema Information:
# * Tabela: +turmas+
# * Colunas: +codigo_sigaa+, +semestre+, +ano+, +nome+, +disciplina+
#
# == Associations:
# * +students+ - Os alunos matriculados nesta turma.
# * +formularios+ - As avaliações aplicadas nesta turma.
class Turma < ApplicationRecord
  # Associação: Possui muitos alunos.
  # Configurado com +dependent: :destroy+: Ao excluir a turma, todos os alunos
  # vinculados a ela são removidos automaticamente.
  has_many :students, dependent: :destroy

  # Associação: Possui vários formulários de avaliação.
  has_many :formularios

  # Callback: Executa o método +set_ano_from_semestre+ antes de validar os dados.
  before_validation :set_ano_from_semestre

  # Validações:
  # * +codigo_sigaa+: Obrigatório.
  # * +semestre+: Obrigatório.
  validates :codigo_sigaa, presence: true
  validates :semestre, presence: true
  
  # Validação de Unicidade:
  # Garante que não existam duas turmas com o mesmo código SIGAA dentro do mesmo semestre.
  validates :codigo_sigaa, uniqueness: { scope: :semestre, message: "já existe neste semestre" }

  private

  # Método auxiliar (Callback) para preencher o campo +ano+ automaticamente.
  # Extrai o ano a partir da string do semestre (ex: '1/2025' -> 2025).
  #
  # == Side Effects:
  # * Altera o valor do atributo +self.ano+ antes de salvar no banco.
  def set_ano_from_semestre
    if self.semestre.present?
      self.ano = self.semestre.split('/').last.to_i
    end
  end
end