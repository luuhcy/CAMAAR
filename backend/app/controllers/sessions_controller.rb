# Controlador responsável pelo gerenciamento de sessões de usuário (Login).
# Gerencia a autenticação verificando credenciais e retornando os dados do usuário logado.
class SessionsController < ApplicationController
  
  # Realiza a autenticação do usuário no sistema.
  # Busca o usuário pelo e-mail e verifica se a senha confere (usando bcrypt via `has_secure_password`).
  #
  # == Arguments:
  # * +params[:email]+ - (String) O e-mail cadastrado do usuário.
  # * +params[:password]+ - (String) A senha em texto plano para verificação.
  #
  # == Returns:
  # * (JSON) Status 200 (OK) e objeto do usuário (id, nome, email, tipo, matrícula) em caso de sucesso.
  # * (JSON) Status 401 (Unauthorized) e mensagem de erro se as credenciais forem inválidas.
  #
  # == Side Effects:
  # * Realiza consulta segura ao banco de dados (`find_by`).
  # * Invoca o método de criptografia para comparar o hash da senha.
  def create
    
    user = User.find_by(email: params[:email])

    
    if user && user.authenticate(params[:password])
      render json: { 
        message: "Login realizado!",
        user: { 
          id: user.id, 
          nome: user.nome, 
          email: user.email, 
          tipo: user.tipo,
          matricula: user.matricula
        }
      }, status: :ok
    else
      render json: { error: "Email ou senha inválidos" }, status: :unauthorized
    end
  end
end