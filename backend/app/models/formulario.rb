# Modelo que representa um Formulário de avaliação ativo.
# Serve como a instância aplicada de um Template para uma determinada Turma, gerenciando
# o período de disponibilidade e agrupando as respostas recebidas.
#
# == Schema Information:
# * Tabela: +formularios+
# * Chaves Estrangeiras: +turma_id+, +template_id+
#
# == Associations:
# * +turma+ - A turma onde o formulário está sendo aplicado.
# * +template+ - O modelo que define as questões deste formulário.
# * +respostas+ - As submissões feitas pelos alunos.
class Formulario < ApplicationRecord
  # Associação: Pertence a uma Turma.
  belongs_to :turma

  # Associação: Baseado em um Template.
  belongs_to :template

  # Associação: Possui várias respostas (Respostum).
  # Configurado com +dependent: :destroy+: Ao apagar este formulário, todas as respostas
  # vinculadas a ele serão apagadas automaticamente do banco de dados (cascade).
  #
  # * +class_name+: 'Respostum' (Força o uso da classe singularizada/latinizada).
  # * +foreign_key+: 'formulario_id' (Chave explícita na tabela de respostas).
  has_many :respostas,
           class_name: 'Respostum',
           foreign_key: 'formulario_id',
           dependent: :destroy
end