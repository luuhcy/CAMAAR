class RespostasController < ApplicationController
  before_action :set_resposta, only: %i[show update destroy]

  # GET /respostas
  def index
    render json: Respostum.all
  end

  # GET /respostas/:id
  def show
    render json: @resposta
  end

  # POST /respostas
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

  # PATCH/PUT /respostas/:id
  def update
    if @resposta.update(resposta_params)
      render json: @resposta
    else
      render json: @resposta.errors, status: :unprocessable_entity
    end
  end

  # DELETE /respostas/:id
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
