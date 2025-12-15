# Controlador responsável pelo gerenciamento de Usuários (Users).
# Permite o cadastro, listagem, atualização e remoção de usuários do sistema (Alunos, Professores, Admins).
class UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]

  # Lista todos os usuários cadastrados.
  #
  # == Returns:
  # * (JSON) Uma lista contendo todos os objetos User.
  def index
    @users = User.all

    render json: @users
  end

  # Exibe os detalhes de um usuário específico.
  #
  # == Arguments:
  # * +id+ - (Integer) O ID do usuário (via URL).
  #
  # == Returns:
  # * (JSON) O objeto User solicitado.
  def show
    render json: @user
  end

  # Cria um novo usuário no sistema.
  # Lida com a criação de senha segura (password/password_confirmation) se o model estiver configurado.
  #
  # == Arguments:
  # * +user_params+ - (Hash) Atributos do usuário incluindo credenciais.
  #
  # == Returns:
  # * (JSON) O usuário criado com status 201 (Created).
  # * (JSON) Erros de validação com status 422 (Unprocessable Content).
  #
  # == Side Effects:
  # * Insere um novo registro na tabela `users`.
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_content
    end
  end

  # Atualiza os dados de um usuário existente.
  #
  # == Arguments:
  # * +id+ - (Integer) O ID do usuário a ser atualizado.
  # * +user_params+ - (Hash) Novos atributos do usuário.
  #
  # == Returns:
  # * (JSON) O usuário atualizado.
  # * (JSON) Erros de validação com status 422 se falhar.
  #
  # == Side Effects:
  # * Atualiza o registro no banco de dados.
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_content
    end
  end

  # Remove um usuário do sistema.
  #
  # == Arguments:
  # * +id+ - (Integer) O ID do usuário a ser excluído.
  #
  # == Side Effects:
  # * Remove permanentemente o registro da tabela `users`.
  def destroy
    @user.destroy!
  end

  private
    
    # Callback para buscar o usuário pelo ID antes de ações específicas.
    #
    # == Arguments:
    # * +params[:id]+ - O ID vindo da rota.
    #
    # == Side Effects:
    # * Define a variável de instância +@user+.
    def set_user
      @user = User.find(params.expect(:id))
    end

    # Define os parâmetros permitidos para criação e atualização (Strong Parameters).
    #
    # == Returns:
    # * (ActionController::Parameters) Hash contendo:
    #   * +:email+ - Endereço de e-mail (usado para login).
    #   * +:matricula+ - Identificação acadêmica.
    #   * +:nome+ - Nome completo.
    #   * +:password+ - Senha para cadastro.
    #   * +:password_confirmation+ - Confirmação da senha.
    #   * +:tipo+ - Role do usuário (ex: 'admin', 'aluno', 'professor').
    def user_params
      params.expect(user: [ :email, :matricula, :nome, :password, :password_confirmation, :tipo ])
    end
end