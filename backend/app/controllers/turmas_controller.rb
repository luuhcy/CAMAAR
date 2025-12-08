class TurmasController < ApplicationController
  before_action :set_turma, only: %i[ show update destroy ]

  # GET /turmas
  def index
    @turmas = Turma.all

    render json: @turmas
  end

  # GET /turmas/1
  def show
    render json: @turma, include: :students
  end

  # POST /turmas
  def create
    @turma = Turma.new(turma_params)

    if @turma.save
      render json: @turma, status: :created, location: @turma
    else
      render json: @turma.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /turmas/1
  def update
    if @turma.update(turma_params)
      render json: @turma
    else
      render json: @turma.errors, status: :unprocessable_content
    end
  end

  # DELETE /turmas/1
  def destroy
    @turma.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_turma
      @turma = Turma.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def turma_params
      params.expect(turma: [ :codigo_sigaa, :nome, :disciplina, :semestre, :ano ])
    end
end
