require 'csv'

module Admin
  class ImportarController < ApplicationController
    # TODO: Implementar autenticação baseada em token ou session
    # before_action :authenticate_admin!, only: [:create]

    # POST /admin/importar
    def create
      unless params[:csvFile].present?
        return render json: { message: 'Nenhum arquivo enviado.' }, status: :bad_request
      end

      begin
        file = params[:csvFile]
        csv_data = file.read.force_encoding('UTF-8')
        
        turmas_criadas = 0
        alunos_criados = 0
        erros = []

        CSV.parse(csv_data, headers: true) do |row|
          begin
            # Extrair dados da linha
            codigo_sigaa = row['codigo_sigaa']&.strip
            nome_turma = row['nome_turma']&.strip
            disciplina = row['disciplina']&.strip
            semestre = row['semestre']&.strip
            matricula_aluno = row['matricula_aluno']&.strip
            nome_aluno = row['nome_aluno']&.strip
            email_aluno = row['email_aluno']&.strip

            # Se tem dados de turma, criar/atualizar turma
            turma = nil
            if codigo_sigaa.present? && nome_turma.present?
              turma_existe = Turma.exists?(codigo_sigaa: codigo_sigaa, semestre: semestre || 'Não informado')
              turma = Turma.find_or_create_by(codigo_sigaa: codigo_sigaa, semestre: semestre || 'Não informado') do |t|
                t.nome = nome_turma
                t.disciplina = disciplina || 'Não informada'
                # O ano é extraído automaticamente do semestre por set_ano_from_semestre
              end
              
              # Salvar a turma se for nova ou se houve mudanças
              unless turma_existe
                if turma.save
                  turmas_criadas += 1
                else
                  erros << "Turma #{codigo_sigaa} (#{semestre}): #{turma.errors.full_messages.join(', ')}"
                  turma = nil
                end
              end
            end

            # Se tem dados de aluno, criar aluno
            if turma.present? && matricula_aluno.present? && nome_aluno.present? && email_aluno.present?
              aluno_existe = Student.exists?(matricula: matricula_aluno)
              student = Student.find_or_create_by(matricula: matricula_aluno) do |s|
                s.name = nome_aluno
                s.email = email_aluno
                s.turma_id = turma.id
              end
              
              # Se o aluno foi encontrado mas não tem a turma correta, atualizar
              if aluno_existe && student.turma_id != turma.id
                student.turma_id = turma.id
              end
              
              # Salvar o aluno se for novo ou se houve mudanças
              if !aluno_existe || (aluno_existe && student.turma_id != turma.id)
                if student.save
                  alunos_criados += 1 unless aluno_existe
                else
                  erros << "Matrícula #{matricula_aluno} (#{nome_aluno}): #{student.errors.full_messages.join(', ')}"
                end
              end
            end

          rescue StandardError => e
            erros << "Erro na linha: #{row.to_h} - #{e.message}"
          end
        end

        message = "Importação concluída! Turmas criadas: #{turmas_criadas}, Alunos criados: #{alunos_criados}."
        message += " Erros: #{erros.join('; ')}" if erros.any?

        render json: { 
          message: message,
          turmas_criadas: turmas_criadas,
          alunos_criados: alunos_criados,
          erros: erros
        }, status: :ok

      rescue CSV::ParserError => e
        render json: { message: "Erro ao parsear CSV: #{e.message}" }, status: :bad_request
      rescue StandardError => e
        render json: { message: "Erro ao processar importação: #{e.message}" }, status: :internal_server_error
      end
    end

    private

    # TODO: Implementar autenticação real via token ou session
    # def authenticate_admin!
    #   # Verificar se está autenticado e é admin
    #   head :unauthorized unless current_user&.admin?
    # end

    # def current_user
    #   # Implementar conforme seu sistema de autenticação
    #   nil
    # end
  end
end
