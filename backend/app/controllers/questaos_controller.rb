class QuestaosController < ApplicationController
  before_action :set_questao, only: %i[ show update destroy ]

  
  def index
    @questaos = Questao.all

    render json: @questaos
  end

  
  def show
    render json: @questao
  end

  
  def create
    @questao = Questao.new(questao_params)

    if @questao.save
      render json: @questao, status: :created, location: @questao
    else
      render json: @questao.errors, status: :unprocessable_content
    end
  end

  
  def update
    if @questao.update(questao_params)
      render json: @questao
    else
      render json: @questao.errors, status: :unprocessable_content
    end
  end

  
  def destroy
    @questao.destroy!
  end

  private
    
    def set_questao
      @questao = Questao.find(params.expect(:id))
    end

    
    def questao_params
      params.expect(questao: [ :texto, :tipo, :obrigatoria, :ordem, :opcoes, :template_id ])
    end
end
