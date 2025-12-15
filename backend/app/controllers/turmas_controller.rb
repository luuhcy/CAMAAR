class TurmasController < ApplicationController
  before_action :set_turma, only: %i[ show update destroy ]

  
  def index
    @turmas = Turma.all

    render json: @turmas
  end

  def show
    @formulario = @turma.formularios.last

    @respostas = @formulario ? @formulario.respostas : []

    
    render json: {
      turma: @turma,
      formulario: @formulario,
      respostas: @respostas
    }
  end

  
  def create
    @turma = Turma.new(turma_params)

    if @turma.save
      render json: @turma, status: :created, location: @turma
    else
      render json: @turma.errors, status: :unprocessable_content
    end
  end

  
  def update
    if @turma.update(turma_params)
      render json: @turma
    else
      render json: @turma.errors, status: :unprocessable_content
    end
  end

  
  def destroy
    @turma.destroy!
  end

  private
    
    def set_turma
      @turma = Turma.find(params.expect(:id))
    end

    
    def turma_params
      params.expect(turma: [ :codigo_sigaa, :nome, :disciplina, :semestre, :ano ])
    end
end
