# Controlador responsável pelo gerenciamento dos Templates de avaliação.
# Um template serve como modelo (agrupador de questões) para criar formulários futuros.
class TemplatesController < ApplicationController
  before_action :set_template, only: %i[ show update destroy ]

  # Lista todos os templates cadastrados no sistema.
  # Utiliza `includes(:questoes)` para carregar as questões associadas de forma eficiente e as inclui no JSON.
  #
  # == Returns:
  # * (JSON) Uma lista de templates, onde cada objeto contém também a lista de suas questões (:questoes).
  def index
    @templates = Template.includes(:questoes).all

    render json: @templates.map { |template|
      template.as_json(include: :questoes)
    }
  end

  # Exibe os detalhes de um template específico.
  # Retorna o template carregado juntamente com todas as suas questões vinculadas.
  #
  # == Arguments:
  # * +id+ - (Integer) O ID do template (via URL).
  #
  # == Returns:
  # * (JSON) O objeto Template solicitado, incluindo a chave aninhada :questoes.
  def show
    render json: @template.as_json(include: :questoes)
  end

  # Cria um novo template no sistema.
  #
  # == Arguments:
  # * +template_params+ - (Hash) Atributos do template (nome, descricao, user_id).
  #
  # == Returns:
  # * (JSON) O template criado com status 201 (Created) se válido.
  # * (JSON) Erros de validação com status 422 (Unprocessable Content) se inválido.
  #
  # == Side Effects:
  # * Insere um novo registro na tabela `templates`.
  def create
    @template = Template.new(template_params)

    if @template.save
      render json: @template, status: :created, location: @template
    else
      render json: @template.errors, status: :unprocessable_content
    end
  end

  # Atualiza as informações de um template existente.
  #
  # == Arguments:
  # * +id+ - (Integer) O ID do template a ser atualizado.
  # * +template_params+ - (Hash) Novos atributos do template.
  #
  # == Returns:
  # * (JSON) O template atualizado.
  # * (JSON) Erros de validação com status 422 se falhar.
  #
  # == Side Effects:
  # * Atualiza o registro no banco de dados.
  def update
    if @template.update(template_params)
      render json: @template
    else
      render json: @template.errors, status: :unprocessable_content
    end
  end

  # Remove um template do sistema.
  #
  # == Arguments:
  # * +id+ - (Integer) O ID do template a ser removido.
  #
  # == Side Effects:
  # * Remove permanentemente o registro da tabela `templates`.
  # * Dependendo da configuração do Model, pode remover questões associadas (dependent: :destroy).
  def destroy
    @template.destroy!
  end

  private
    
    # Callback para buscar o template pelo ID antes de ações específicas.
    #
    # == Arguments:
    # * +params[:id]+ - O ID vindo da rota.
    #
    # == Side Effects:
    # * Define a variável de instância +@template+.
    def set_template
      @template = Template.find(params.expect(:id))
    end

    # Define os parâmetros permitidos para criação e atualização (Strong Parameters).
    #
    # == Returns:
    # * (ActionController::Parameters) Hash contendo:
    #   * +:nome+ - Nome do template.
    #   * +:descricao+ - Descrição textual do objetivo do template.
    #   * +:user_id+ - ID do usuário (professor/admin) criador do template.
    def template_params
      params.expect(template: [ :nome, :descricao, :user_id ])
    end
end