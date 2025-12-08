class QuestaosController < ApplicationController
  before_action :set_questao, only: %i[ show update destroy ]

  # GET /questaos
  def index
    @questaos = Questao.all

    render json: @questaos
  end

  # GET /questaos/1
  def show
    render json: @questao
  end

  # POST /questaos
  def create
    @questao = Questao.new(questao_params)

    if @questao.save
      render json: @questao, status: :created, location: @questao
    else
      render json: @questao.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /questaos/1
  def update
    if @questao.update(questao_params)
      render json: @questao
    else
      render json: @questao.errors, status: :unprocessable_content
    end
  end

  # DELETE /questaos/1
  def destroy
    @questao.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_questao
      @questao = Questao.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def questao_params
      params.expect(questao: [ :texto, :tipo, :obrigatoria, :ordem, :opcoes, :template_id ])
    end
end
