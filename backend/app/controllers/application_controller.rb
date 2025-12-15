# Classe base para todos os controladores da API do projeto CAMAAR.
# Herda de ActionController::API, sendo otimizada para responder JSON, mas
# customizada para suportar sessões e cookies.
#
# == Responsibilities:
# * Atuar como pai para todos os outros controladores da aplicação.
# * Habilitar o middleware de Cookies (necessário para autenticação/sessão).
# * Habilitar proteção contra CSRF (Cross-Site Request Forgery).
class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection
end