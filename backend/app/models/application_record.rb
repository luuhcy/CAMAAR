# Classe base para todos os modelos (Models) da aplicação.
# Herda de ActiveRecord::Base e serve como ponto central para configurações
# compartilhadas entre todos os modelos do sistema.
#
# == Responsibilities:
# * Atuar como classe abstrata primária (`primary_abstract_class`).
# * Impedir que o Rails busque uma tabela chamada `application_records` no banco de dados.
# * Permitir a criação de métodos ou configurações globais para todos os models.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end