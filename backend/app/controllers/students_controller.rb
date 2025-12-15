class StudentsController < ApplicationController
  before_action :set_student, only: %i[ show update destroy ]

  
  def index
    @students = Student.all

    render json: @students
  end

  
  def show
    render json: @student
  end

  
  def create
    @student = Student.new(student_params)

    if @student.save
      render json: @student, status: :created, location: @student
    else
      render json: @student.errors, status: :unprocessable_content
    end
  end

  
  def update
    if @student.update(student_params)
      render json: @student
    else
      render json: @student.errors, status: :unprocessable_content
    end
  end

  
  def destroy
    @student.destroy!
  end

  private
    
    def set_student
      @student = Student.find(params.expect(:id))
    end

    
    def student_params
      params.expect(student: [ :name, :matricula, :email, :turma_id ])
    end
end
