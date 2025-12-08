class User < ApplicationRecord
  has_secure_password # Isso ativa a criptografia da senha!
  
  has_many :templates
  has_many :respostas
end