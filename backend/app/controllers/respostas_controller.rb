class RespostasController < ApplicationController
  before_action :set_resposta, only: %i[show update destroy]

  
  def index
    render json: Respostum.all
  end

  
  def show
    render json: @resposta
  end

  
  def create
    @resposta = Respostum.new(
      data_resposta: params[:resposta],
      status: 'enviado',
      user: User.find(params[:user_id]),
      formulario_id: params[:formulario_id]
    )

    if @resposta.save
      render json: @resposta, status: :created
    else
      render json: @resposta.errors, status: :unprocessable_entity
    end
  end

  
  def update
    if @resposta.update(resposta_params)
      render json: @resposta
    else
      render json: @resposta.errors, status: :unprocessable_entity
    end
  end

  
  def destroy
    @resposta.destroy
    head :no_content
  end

  private

  def set_resposta
    @resposta = Respostum.find(params[:id])
  end

  def resposta_params
    params.require(:respostum).permit(
      :data_resposta,
      :status,
      :user_id,
      :formulario_id
    )
  end
end
