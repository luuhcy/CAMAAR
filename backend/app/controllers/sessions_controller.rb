class SessionsController < ApplicationController
  # POST /login
  def create
    # Busca o usuário pelo email
    user = User.find_by(email: params[:email])

    # O método .authenticate verifica se a senha bate com a criptografia
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