# Controlador responsável pelo gerenciamento das submissões de respostas (Respostum).
# Lida com o recebimento, visualização e atualização das respostas dadas pelos usuários aos formulários.
class RespostasController < ApplicationController
  before_action :set_resposta, only: %i[show update destroy]

  # Lista todas as respostas registradas no sistema.
  #
  # == Returns:
  # * (JSON) Uma lista de todos os objetos Respostum.
  def index
    render json: Respostum.all
  end

  # Exibe os detalhes de uma resposta específica.
  #
  # == Arguments:
  # * +id+ - (Integer) O ID da resposta (via URL).
  #
  # == Returns:
  # * (JSON) O objeto Respostum solicitado.
  def show
    render json: @resposta
  end

  # Cria uma nova resposta (submissão de formulário).
  # Diferente do padrão, constrói o objeto manualmente usando parâmetros específicos e define status padrão.
  #
  # == Arguments:
  # * +params[:resposta]+ - (JSON/Hash) O conteúdo das respostas dadas (campo data_resposta).
  # * +params[:user_id]+ - (Integer) O ID do usuário que está respondendo.
  # * +params[:formulario_id]+ - (Integer) O ID do formulário sendo respondido.
  #
  # == Returns:
  # * (JSON) A resposta criada com status 201 (Created).
  # * (JSON) Erros de validação com status 422 (Unprocessable Entity).
  #
  # == Side Effects:
  # * Cria um novo registro na tabela de respostas.
  # * Define automaticamente o status como 'enviado'.
  def create
    @resposta = Respostum.new(
      data_resposta: params[:resposta],
      status: 'enviado',
      user: User.find(params[:user_id]),
      formulario_id: params[:formulario_id]
    )

    if @resposta.save
      render json: @resposta, status: :created
    else
      render json: @resposta.errors, status: :unprocessable_entity
    end
  end

  # Atualiza uma resposta existente.
  #
  # == Arguments:
  # * +id+ - (Integer) O ID da resposta a ser atualizada.
  # * +resposta_params+ - (Hash) Parâmetros permitidos para atualização.
  #
  # == Returns:
  # * (JSON) O objeto atualizado.
  # * (JSON) Erros de validação com status 422.
  #
  # == Side Effects:
  # * Atualiza os dados no banco de dados.
  def update
    if @resposta.update(resposta_params)
      render json: @resposta
    else
      render json: @resposta.errors, status: :unprocessable_entity
    end
  end

  # Exclui uma resposta do sistema.
  #
  # == Arguments:
  # * +id+ - (Integer) O ID da resposta a ser excluída.
  #
  # == Returns:
  # * Retorna status 204 No Content (sem corpo de resposta).
  #
  # == Side Effects:
  # * Remove o registro permanentemente do banco de dados.
  def destroy
    @resposta.destroy
    head :no_content
  end

  private

  # Callback para localizar a resposta pelo ID.
  #
  # == Arguments:
  # * +params[:id]+ - O ID vindo da rota.
  #
  # == Side Effects:
  # * Define a variável de instância +@resposta+.
  def set_resposta
    @resposta = Respostum.find(params[:id])
  end

  # Define os parâmetros permitidos (Strong Parameters) para o model Respostum.
  #
  # == Returns:
  # * (ActionController::Parameters) Hash filtrado com :data_resposta, :status, :user_id, :formulario_id.
  def resposta_params
    params.require(:respostum).permit(
      :data_resposta,
      :status,
      :user_id,
      :formulario_id
    )
  end
end