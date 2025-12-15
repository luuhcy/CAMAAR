class SessionsController < ApplicationController
  
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