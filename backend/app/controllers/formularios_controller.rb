# Controlador responsável pelo gerenciamento dos Formulários de avaliação.
# Permite listar formulários ativos, visualizar detalhes, criar, atualizar e remover formulários.
class FormulariosController < ApplicationController
  before_action :set_formulario, only: %i[ show update destroy ]

  # Retorna a lista de todos os formulários que estão atualmente ativos (vigentes).
  # A busca filtra formulários onde a data atual está entre a `data_inicio` e `data_termino`.
  #
  # == Returns:
  # * (JSON) Uma lista de objetos Formulario, incluindo dados aninhados da Turma e do Template (com o usuário criador).
  #
  # == Side Effects:
  # * Realiza uma consulta ao banco de dados com `includes` para evitar query N+1.
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

  # Exibe os detalhes de um formulário específico.
  #
  # == Arguments:
  # * +id+ - (Integer) O ID do formulário passado via URL (params).
  #
  # == Returns:
  # * (JSON) O objeto Formulario solicitado com suas associações carregadas.
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

  # Cria um novo formulário no sistema.
  #
  # == Arguments:
  # * +formulario_params+ - (Hash) Parâmetros contendo titulo, datas, template_id e turma_id.
  #
  # == Returns:
  # * (JSON) O formulário criado com status 201 (Created) se for válido.
  # * (JSON) Os erros de validação com status 422 (Unprocessable Entity) se falhar.
  #
  # == Side Effects:
  # * Insere um novo registro na tabela `formularios`.
  def create
    @formulario = Formulario.new(formulario_params)

    if @formulario.save
      render json: @formulario, status: :created, location: @formulario
    else
      render json: @formulario.errors, status: :unprocessable_content
    end
  end

  # Atualiza os dados de um formulário existente.
  #
  # == Arguments:
  # * +id+ - (Integer) O ID do formulário a ser atualizado.
  # * +formulario_params+ - (Hash) Os novos atributos do formulário.
  #
  # == Returns:
  # * (JSON) O formulário atualizado se a operação for bem-sucedida.
  # * (JSON) Erros de validação com status 422 se falhar.
  #
  # == Side Effects:
  # * Atualiza o registro correspondente no banco de dados.
  def update
    if @formulario.update(formulario_params)
      render json: @formulario
    else
      render json: @formulario.errors, status: :unprocessable_content
    end
  end

  # Remove um formulário do banco de dados.
  #
  # == Arguments:
  # * +id+ - (Integer) O ID do formulário a ser removido.
  #
  # == Side Effects:
  # * Remove permanentemente o registro da tabela `formularios`.
  # * Lança uma exceção se a remoção falhar (devido ao `destroy!`).
  def destroy
    @formulario.destroy!
  end

  private
    
    # Callback para buscar o formulário pelo ID antes de ações específicas.
    # Já carrega as associações (turma e template) para otimizar a resposta do JSON.
    #
    # == Arguments:
    # * +params[:id]+ - O ID vindo da rota.
    #
    # == Side Effects:
    # * Define a variável de instância +@formulario+.
    def set_formulario
      @formulario = Formulario.includes(turma: [], template: :user).find(params.expect(:id))
    end

    # Filtra os parâmetros permitidos para criação e atualização (Strong Parameters).
    #
    # == Returns:
    # * (ActionController::Parameters) Apenas os campos permitidos (:titulo, :data_inicio, :data_termino, :template_id, :turma_id).
    def formulario_params
      params.expect(formulario: [ :titulo, :data_inicio, :data_termino, :template_id, :turma_id ])
    end
end