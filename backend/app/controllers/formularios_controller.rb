class FormulariosController < ApplicationController
  before_action :set_formulario, only: %i[ show update destroy ]

  
  def index
    # Busca apenas formulários ativos
    @formularios = Formulario.includes(turma: [], template: :user)
                              .where("data_inicio <= ? AND data_termino >= ?", DateTime.now, DateTime.now)
    
    render json: @formularios.as_json(
      include: {
        turma: { only: [:id, :codigo_sigaa, :nome, :disciplina, :semestre, :ano] },
        template: { 
          only: [:id, :nome, :descricao],
          include: {
            user: { only: [:id, :nome, :email] }
          }
        }
      }
    )
  end

  
  def show
    render json: @formulario.as_json(
      include: {
        turma: { only: [:id, :codigo_sigaa, :nome, :disciplina, :semestre, :ano] },
        template: { 
          only: [:id, :nome, :descricao],
          include: {
            user: { only: [:id, :nome, :email] }
          }
        }
      }
    )
  end

  
  def create
    @formulario = Formulario.new(formulario_params)

    if @formulario.save
      render json: @formulario, status: :created, location: @formulario
    else
      render json: @formulario.errors, status: :unprocessable_content
    end
  end

  
  def update
    if @formulario.update(formulario_params)
      render json: @formulario
    else
      render json: @formulario.errors, status: :unprocessable_content
    end
  end

  
  def destroy
    @formulario.destroy!
  end

  private
    
    def set_formulario
      @formulario = Formulario.includes(turma: [], template: :user).find(params.expect(:id))
    end

    
    def formulario_params
      params.expect(formulario: [ :titulo, :data_inicio, :data_termino, :template_id, :turma_id ])
    end
end
