require 'csv'

module Admin
  class ImportsController < ApplicationController
    
    def create
      uploaded_file = params[:csvFile]
      
      if uploaded_file.present?
        csv_text = uploaded_file.read.force_encoding('ISO-8859-1').encode('UTF-8')
        
        turmas_count = 0
        students_count = 0

        CSV.parse(csv_text, headers: true, col_sep: ',').each do |row|
          
          turma_params = {
            codigo_sigaa: row['Turma - Cod'].to_s,
            nome: row['Turma - Nome'].to_s,
            disciplina: row['Disciplina - Nome'].to_s,
            semestre: row['Semestre'].to_s
          }
          
          turma = Turma.find_or_create_by!(
            codigo_sigaa: turma_params[:codigo_sigaa],
            semestre: turma_params[:semestre]
          ) do |t|
            t.nome = turma_params[:nome]
            t.disciplina = turma_params[:disciplina]
          end
          
          turmas_count += 1
          
          student_params = {
            matricula: row['Aluno - Matricula'].to_s,
            name: row['Aluno - Nome'].to_s,
            email: row['Aluno - Email'].to_s
          }
          
          student = Student.find_or_initialize_by(matricula: student_params[:matricula])
          
          student.name = student_params[:name]
          student.email = student_params[:email]
          
          student.turma_id = turma.id 
          
          if student.save
            students_count += 1
          else
            Rails.logger.error "Erro ao salvar estudante #{student.matricula}: #{student.errors.full_messages.to_sentence}"
          end

        end
        
        render json: { message: "Importação concluída! #{turmas_count} Turmas e #{students_count} Alunos processados." }, status: :ok
      else
        render json: { message: "Nenhum arquivo CSV encontrado." }, status: :bad_request
      end
    
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: "Erro de validação na linha: #{e.record.errors.full_messages.to_sentence}" }, status: :unprocessable_entity
   
    rescue => e
      render json: { message: "Erro interno no servidor: #{e.message}" }, status: :internal_server_error
    end
    
  end
end