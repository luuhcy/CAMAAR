# Modelo que representa um Usuário do sistema.
# Pode assumir diferentes papéis (Admin, Professor, Aluno) dependendo do atributo `tipo`.
# Responsável por armazenar as credenciais de acesso e relacionar-se com as criações (templates) ou submissões (respostas).
#
# == Schema Information:
# * Tabela: +users+
# * Colunas: +nome+, +email+, +matricula+, +tipo+, +password_digest+
#
# == Security:
# * Utiliza +has_secure_password+ para criptografar senhas usando o algoritmo BCrypt.
# * Requer a coluna +password_digest+ no banco de dados.
# * Adiciona automaticamente validações de presença para +password+ na criação.
class User < ApplicationRecord
  # Macro do Rails que gerencia a segurança de senhas.
  # * Criptografa a senha salva no banco.
  # * Disponibiliza os métodos +authenticate+ e os atributos virtuais +password+ e +password_confirmation+.
  has_secure_password 

  # Associação: Templates criados por este usuário (geralmente Professores/Admins).
  has_many :templates

  # Associação: Respostas submetidas por este usuário (geralmente Alunos).
  has_many :respostas
  
  validates :nome, presence: true
  validates :email, presence: true, uniqueness: true
  validates :matricula, presence: true, uniqueness: true
end
