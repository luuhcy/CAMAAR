# Controlador responsável pelo gerenciamento de Alunos (Students).
# Permite a listagem, visualização, cadastro, atualização e remoção de alunos no sistema.
class StudentsController < ApplicationController
  before_action :set_student, only: %i[ show update destroy ]

  # Lista todos os alunos cadastrados no sistema.
  #
  # == Returns:
  # * (JSON) Uma lista contendo todos os objetos Student.
  def index
    @students = Student.all

    render json: @students
  end

  # Exibe os detalhes de um aluno específico.
  #
  # == Arguments:
  # * +id+ - (Integer) O ID do aluno (via URL).
  #
  # == Returns:
  # * (JSON) O objeto Student solicitado.
  def show
    render json: @student
  end

  # Cadastra um novo aluno no sistema.
  #
  # == Arguments:
  # * +student_params+ - (Hash) Atributos do aluno (:name, :matricula, :email, :turma_id).
  #
  # == Returns:
  # * (JSON) O aluno criado com status 201 (Created) se for válido.
  # * (JSON) Erros de validação com status 422 (Unprocessable Content) se falhar.
  #
  # == Side Effects:
  # * Insere um novo registro na tabela `students`.
  def create
    @student = Student.new(student_params)

    if @student.save
      render json: @student, status: :created, location: @student
    else
      render json: @student.errors, status: :unprocessable_content
    end
  end

  # Atualiza os dados de um aluno existente.
  #
  # == Arguments:
  # * +id+ - (Integer) O ID do aluno a ser atualizado.
  # * +student_params+ - (Hash) Novos atributos do aluno.
  #
  # == Returns:
  # * (JSON) O aluno atualizado se a operação for bem-sucedida.
  # * (JSON) Erros de validação com status 422 se falhar.
  #
  # == Side Effects:
  # * Atualiza o registro correspondente no banco de dados.
  def update
    if @student.update(student_params)
      render json: @student
    else
      render json: @student.errors, status: :unprocessable_content
    end
  end

  # Remove um aluno do banco de dados.
  #
  # == Arguments:
  # * +id+ - (Integer) O ID do aluno a ser excluído.
  #
  # == Side Effects:
  # * Remove permanentemente o registro da tabela `students`.
  # * Lança uma exceção se a remoção falhar (devido ao `destroy!`).
  def destroy
    @student.destroy!
  end

  private
    
    # Callback para buscar o aluno pelo ID antes de ações específicas (show, update, destroy).
    #
    # == Arguments:
    # * +params[:id]+ - O ID vindo da rota.
    #
    # == Side Effects:
    # * Define a variável de instância +@student+.
    def set_student
      @student = Student.find(params.expect(:id))
    end

    # Filtra os parâmetros permitidos para criação e atualização (Strong Parameters).
    #
    # == Returns:
    # * (ActionController::Parameters) Hash contendo apenas:
    #   * +:name+ - Nome do aluno.
    #   * +:matricula+ - Número de matrícula.
    #   * +:email+ - E-mail de contato.
    #   * +:turma_id+ - ID da turma à qual o aluno pertence.
    def student_params
      params.expect(student: [ :name, :matricula, :email, :turma_id ])
    end
end