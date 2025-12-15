# Controlador responsável pelo gerenciamento das Turmas (disciplinas ofertadas em um semestre).
# Permite listar, criar, editar e remover turmas, além de visualizar os resultados (respostas) associados.
class TurmasController < ApplicationController
  before_action :set_turma, only: %i[ show update destroy ]

  # Lista todas as turmas cadastradas.
  #
  # == Returns:
  # * (JSON) Uma lista de todos os objetos Turma.
  def index
    @turmas = Turma.all

    render json: @turmas
  end

  # Exibe os detalhes de uma turma, incluindo seu último formulário e as respostas dos alunos.
  #
  # == Arguments:
  # * +id+ - (Integer) O ID da turma (via URL).
  #
  # == Returns:
  # * (JSON) Um objeto contendo três chaves:
  #   * +turma+: Os dados da turma.
  #   * +formulario+: O último formulário criado para esta turma.
  #   * +respostas+: Lista de respostas submetidas para este formulário.
  #
  # == Side Effects:
  # * Realiza consultas adicionais para buscar o último formulário e suas respostas.
  def show
    @formulario = @turma.formularios.last

    @respostas = @formulario ? @formulario.respostas : []

    
    render json: {
      turma: @turma,
      formulario: @formulario,
      respostas: @respostas
    }
  end

  # Cria uma nova turma no sistema.
  #
  # == Arguments:
  # * +turma_params+ - (Hash) Atributos da turma (codigo_sigaa, nome, disciplina, semestre, ano).
  #
  # == Returns:
  # * (JSON) A turma criada com status 201 (Created).
  # * (JSON) Erros de validação com status 422 (Unprocessable Content).
  #
  # == Side Effects:
  # * Insere um novo registro na tabela `turmas`.
  def create
    @turma = Turma.new(turma_params)

    if @turma.save
      render json: @turma, status: :created, location: @turma
    else
      render json: @turma.errors, status: :unprocessable_content
    end
  end

  # Atualiza os dados de uma turma existente.
  #
  # == Arguments:
  # * +id+ - (Integer) O ID da turma a ser atualizada.
  # * +turma_params+ - (Hash) Novos atributos da turma.
  #
  # == Returns:
  # * (JSON) A turma atualizada.
  # * (JSON) Erros de validação com status 422 se falhar.
  #
  # == Side Effects:
  # * Atualiza o registro no banco de dados.
  def update
    if @turma.update(turma_params)
      render json: @turma
    else
      render json: @turma.errors, status: :unprocessable_content
    end
  end

  # Remove uma turma do sistema.
  #
  # == Arguments:
  # * +id+ - (Integer) O ID da turma a ser excluída.
  #
  # == Side Effects:
  # * Remove permanentemente o registro da tabela `turmas`.
  def destroy
    @turma.destroy!
  end

  private
    
    # Callback para buscar a turma pelo ID antes de ações específicas.
    #
    # == Arguments:
    # * +params[:id]+ - O ID vindo da rota.
    #
    # == Side Effects:
    # * Define a variável de instância +@turma+.
    def set_turma
      @turma = Turma.find(params.expect(:id))
    end

    # Define os parâmetros permitidos para criação e atualização (Strong Parameters).
    #
    # == Returns:
    # * (ActionController::Parameters) Hash contendo:
    #   * +:codigo_sigaa+ - Código identificador da turma no sistema acadêmico.
    #   * +:nome+ - Nome da turma (ex: Turma A).
    #   * +:disciplina+ - Nome da disciplina.
    #   * +:semestre+ - Semestre letivo (ex: 1 ou 2).
    #   * +:ano+ - Ano letivo.
    def turma_params
      params.expect(turma: [ :codigo_sigaa, :nome, :disciplina, :semestre, :ano ])
    end
end