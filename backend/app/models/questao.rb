# Modelo que representa uma Questão individual de avaliação.
# É o bloco básico de construção de um Template, armazenando o enunciado,
# o tipo da pergunta (ex: múltipla escolha) e as opções disponíveis.
#
# == Schema Information:
# * Tabela: +questaos+
# * Chaves Estrangeiras: +template_id+
#
# == Associations:
# * +template+ - O modelo de avaliação (pai) ao qual esta questão pertence.
class Questao < ApplicationRecord
  # Associação: Cada questão pertence obrigatoriamente a um Template.
  belongs_to :template
end