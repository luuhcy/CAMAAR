# Modelo que representa a submissão de respostas de um aluno.
# Armazena o conjunto de respostas dadas por um usuário específico para um formulário.
#
# Nota sobre o nome da classe: `Respostum` é a inflexão singular (latim/Rails) para a tabela `resposta` (ou `respostas`).
#
# == Schema Information:
# * Tabela: +resposta+ (geralmente)
# * Chaves Estrangeiras: +user_id+, +formulario_id+
# * Atributos: +data_resposta+ (JSON), +status+
class Respostum < ApplicationRecord
  # Associação: O usuário (aluno) que enviou esta resposta.
  belongs_to :user

  # Associação: O formulário ao qual esta resposta se refere.
  belongs_to :formulario

  # Configuração de Serialização:
  # O atributo +data_resposta+ é armazenado no banco de dados como texto (JSON String),
  # mas é convertido automaticamente para um Hash ou Array Ruby ao ser acessado no código.
  #
  # Exemplo de uso:
  #   resposta.data_resposta['1'] # Retorna o valor da pergunta 1
  serialize :data_resposta, coder: JSON
end