class RespostaController < ApplicationController
  before_action :set_respostum, only: %i[ show update destroy ]

  # GET /resposta
  def index
    @resposta = Respostum.all

    render json: @resposta
  end

  # GET /resposta/1
  def show
    render json: @respostum
  end

  # POST /resposta
  def create
    @respostum = Respostum.new(respostum_params)

    if @respostum.save
      render json: @respostum, status: :created, location: @respostum
    else
      render json: @respostum.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /resposta/1
  def update
    if @respostum.update(respostum_params)
      render json: @respostum
    else
      render json: @respostum.errors, status: :unprocessable_content
    end
  end

  # DELETE /resposta/1
  def destroy
    @respostum.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_respostum
      @respostum = Respostum.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def respostum_params
      params.expect(respostum: [ :data_resposta, :status, :user_id, :formulario_id ])
    end
end
