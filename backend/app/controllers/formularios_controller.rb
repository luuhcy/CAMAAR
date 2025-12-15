class FormulariosController < ApplicationController
  before_action :set_formulario, only: %i[ show update destroy ]

  # GET /formularios
  def index
    # Busca apenas formulários ativos (data atual entre data_inicio e data_termino)
    @formularios = Formulario.includes(:turma, :template)
                              .where("data_inicio <= ? AND data_termino >= ?", DateTime.now, DateTime.now)
    
    render json: @formularios.as_json(
      include: {
        turma: { only: [:id, :codigo_sigaa, :nome, :disciplina, :semestre, :ano] },
        template: { only: [:id, :nome, :descricao] }
      }
    )
  end

  # GET /formularios/1
  def show
    render json: @formulario
  end

  # POST /formularios
  def create
    @formulario = Formulario.new(formulario_params)

    if @formulario.save
      render json: @formulario, status: :created, location: @formulario
    else
      render json: @formulario.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /formularios/1
  def update
    if @formulario.update(formulario_params)
      render json: @formulario
    else
      render json: @formulario.errors, status: :unprocessable_content
    end
  end

  # DELETE /formularios/1
  def destroy
    @formulario.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_formulario
      @formulario = Formulario.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def formulario_params
      params.expect(formulario: [ :titulo, :data_inicio, :data_termino, :template_id, :turma_id ])
    end
end
