# Modelo que representa um Template de avaliação.
# Serve como um modelo base (blueprint) contendo um conjunto de questões que poderão
# ser reutilizadas na criação de múltiplos Formulários para diferentes turmas.
#
# == Schema Information:
# * Tabela: +templates+
# * Chaves Estrangeiras: +user_id+
#
# == Associations:
# * +user+ - O usuário (Professor ou Admin) criador deste template.
# * +questoes+ - As perguntas cadastradas neste modelo.
# * +formularios+ - As aplicações práticas deste template em turmas específicas.
class Template < ApplicationRecord
  # Associação: Pertence ao usuário que o criou.
  belongs_to :user

  # Associação: Possui muitas questões.
  # Configurado com +dependent: :destroy+: Ao apagar o template, todas as questões
  # associadas a ele são apagadas automaticamente.
  # * +class_name+: 'Questao' (Define explicitamente o nome da classe do model).
  has_many :questoes, class_name: 'Questao', dependent: :destroy
  has_many :questaos, class_name: 'Questao', dependent: :destroy

  # Associação: Pode ter gerado vários formulários de aplicação.
  has_many :formularios
  
  validates :nome, presence: true
end
