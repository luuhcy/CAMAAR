# Controlador responsável pelo gerenciamento das Questões que compõem os Templates de avaliação.
# Permite listar, visualizar, criar, editar e excluir questões.
class QuestaosController < ApplicationController
  before_action :set_questao, only: %i[ show update destroy ]

  # Lista todas as questões cadastradas no banco de dados.
  #
  # == Returns:
  # * (JSON) Uma lista contendo todas as instâncias de Questao.
  def index
    @questaos = Questao.all

    render json: @questaos
  end

  # Exibe os detalhes de uma questão específica.
  #
  # == Arguments:
  # * +id+ - (Integer) O ID da questão (via URL).
  #
  # == Returns:
  # * (JSON) O objeto Questao solicitado.
  def show
    render json: @questao
  end

  # Cria uma nova questão e a associa a um template.
  #
  # == Arguments:
  # * +questao_params+ - (Hash) Atributos da questão (texto, tipo, obrigatoria, ordem, opcoes, template_id).
  #
  # == Returns:
  # * (JSON) A questão criada com status 201 (Created) se válido.
  # * (JSON) Lista de erros com status 422 (Unprocessable Entity) se inválido.
  #
  # == Side Effects:
  # * Insere um novo registro na tabela `questaos`.
  def create
    @questao = Questao.new(questao_params)

    if @questao.save
      render json: @questao, status: :created, location: @questao
    else
      render json: @questao.errors, status: :unprocessable_content
    end
  end

  # Atualiza os dados de uma questão existente.
  #
  # == Arguments:
  # * +id+ - (Integer) O ID da questão a ser atualizada.
  # * +questao_params+ - (Hash) Novos atributos da questão.
  #
  # == Returns:
  # * (JSON) A questão atualizada.
  # * (JSON) Erros de validação com status 422 se falhar.
  #
  # == Side Effects:
  # * Atualiza o registro no banco de dados.
  def update
    if @questao.update(questao_params)
      render json: @questao
    else
      render json: @questao.errors, status: :unprocessable_content
    end
  end

  # Remove uma questão do banco de dados.
  #
  # == Arguments:
  # * +id+ - (Integer) O ID da questão a ser excluída.
  #
  # == Side Effects:
  # * Remove permanentemente o registro da tabela `questaos`.
  def destroy
    @questao.destroy!
  end

  private
    
    # Callback para buscar a questão pelo ID antes de ações de show, update e destroy.
    #
    # == Arguments:
    # * +params[:id]+ - O ID vindo da rota.
    #
    # == Side Effects:
    # * Define a variável de instância +@questao+.
    def set_questao
      @questao = Questao.find(params.expect(:id))
    end

    # Define os parâmetros permitidos para criação e atualização (Strong Parameters).
    #
    # == Returns:
    # * (ActionController::Parameters) Hash filtrado contendo:
    #   * +:texto+ - Enunciado da questão.
    #   * +:tipo+ - Tipo da pergunta (ex: 'multipla_escolha', 'texto').
    #   * +:obrigatoria+ - Booleano indicando se é obrigatória.
    #   * +:ordem+ - Posição da questão no formulário.
    #   * +:opcoes+ - JSON ou texto com as opções de resposta.
    #   * +:template_id+ - ID do template pai.
    def questao_params
      params.expect(questao: [ :texto, :tipo, :obrigatoria, :ordem, :opcoes, :template_id ])
    end
end