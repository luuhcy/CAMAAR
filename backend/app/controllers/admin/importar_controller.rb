require 'csv'
require 'json'

module Admin
  class ImportarController < ApplicationController
    # TODO: Implementar autenticação baseada em token ou session
    # before_action :authenticate_admin!, only: [:create, :create_json]

    # POST /admin/importar
    def create
      unless params[:csvFile].present?
        return render json: { message: 'Nenhum arquivo enviado.' }, status: :bad_request
      end

      file = params[:csvFile]
      
      # Detectar se é JSON ou CSV pelo nome do arquivo
      if file.original_filename.end_with?('.json')
        import_json(file)
      elsif file.original_filename.end_with?('.csv')
        import_csv(file)
      else
        render json: { message: 'Formato de arquivo não suportado. Use .csv ou .json' }, status: :bad_request
      end
    end

    private

    def import_csv(file)

      begin
        # Tentar ler com diferentes encodings
        csv_data = file.read
        
        # Tentar UTF-8 primeiro, se falhar, tenta ISO-8859-1
        begin
          csv_data = csv_data.force_encoding('UTF-8').encode('UTF-8')
        rescue Encoding::InvalidByteSequenceError
          csv_data = csv_data.force_encoding('ISO-8859-1').encode('UTF-8')
        end
        
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

      rescue CSV::InvalidEncodingError, Encoding::InvalidByteSequenceError => e
      rescue CSV::InvalidEncodingError, Encoding::InvalidByteSequenceError => e
        render json: { message: "Erro de encoding no arquivo CSV: #{e.message}. Certifique-se de que o arquivo está em UTF-8 ou Latin1." }, status: :bad_request
      rescue CSV::ParserError, StandardError => e
        render json: { message: "Erro ao processar importação CSV: #{e.message}" }, status: :internal_server_error
      end
    end

    def import_json(file)
      begin
        json_data = file.read
        
        # Tentar parsear o JSON
        data = JSON.parse(json_data)
        
        # Detectar formato: classes.json ou class_members.json
        if data.is_a?(Array) && data.first&.key?('dicente')
          # Formato class_members.json
          import_class_members_json(data)
        elsif data.is_a?(Array) && data.first&.key?('class')
          # Formato classes.json
          import_classes_json(data)
        else
          render json: { message: 'Formato JSON não reconhecido. Use o formato classes.json ou class_members.json' }, status: :bad_request
        end
        
      rescue JSON::ParserError => e
        render json: { message: "Erro ao parsear JSON: #{e.message}" }, status: :bad_request
      rescue StandardError => e
        render json: { message: "Erro ao processar importação JSON: #{e.message}" }, status: :internal_server_error
      end
    end

    def import_classes_json(data)
      turmas_criadas = 0
      erros = []

      data.each do |item|
        begin
          codigo_sigaa = item['code']
          disciplina = item['name']
          nome_turma = item.dig('class', 'classCode')
          semestre = item.dig('class', 'semester')
          
          turma_existe = Turma.exists?(codigo_sigaa: codigo_sigaa, semestre: semestre)
          turma = Turma.find_or_create_by(codigo_sigaa: codigo_sigaa, semestre: semestre) do |t|
            t.nome = nome_turma
            t.disciplina = disciplina
          end
          
          unless turma_existe
            if turma.save
              turmas_criadas += 1
            else
              erros << "Turma #{codigo_sigaa} (#{semestre}): #{turma.errors.full_messages.join(', ')}"
            end
          end
          
        rescue StandardError => e
          erros << "Erro ao processar turma #{item['code']}: #{e.message}"
        end
      end

      message = "Importação de classes concluída! Turmas criadas: #{turmas_criadas}."
      message += " Erros: #{erros.join('; ')}" if erros.any?

      render json: { 
        message: message,
        turmas_criadas: turmas_criadas,
        erros: erros
      }, status: :ok
    end

    def import_class_members_json(data)
      turmas_criadas = 0
      alunos_criados = 0
      erros = []

      data.each do |item|
        begin
          codigo_sigaa = item['code']
          nome_turma = item['classCode']
          semestre = item['semester']
          
          # Criar/buscar turma (sem disciplina pois não está no class_members.json)
          turma_existe = Turma.exists?(codigo_sigaa: codigo_sigaa, semestre: semestre)
          turma = Turma.find_or_create_by(codigo_sigaa: codigo_sigaa, semestre: semestre) do |t|
            t.nome = nome_turma
            t.disciplina = "Não informada"
          end
          
          unless turma_existe
            if turma.save
              turmas_criadas += 1
            else
              erros << "Turma #{codigo_sigaa} (#{semestre}): #{turma.errors.full_messages.join(', ')}"
              next
            end
          end
          
          # Processar alunos (dicentes)
          item['dicente']&.each do |aluno|
            begin
              matricula = aluno['matricula']
              nome = aluno['nome']
              email = aluno['email']
              
              next unless matricula.present? && nome.present? && email.present?
              
              aluno_existe = Student.exists?(matricula: matricula)
              student = Student.find_or_create_by(matricula: matricula) do |s|
                s.name = nome
                s.email = email
                s.turma_id = turma.id
              end
              
              if aluno_existe && student.turma_id != turma.id
                student.turma_id = turma.id
              end
              
              if !aluno_existe || (aluno_existe && student.changed?)
                if student.save
                  alunos_criados += 1 unless aluno_existe
                else
                  erros << "Aluno #{matricula} (#{nome}): #{student.errors.full_messages.join(', ')}"
                end
              end
              
            rescue StandardError => e
              erros << "Erro ao processar aluno #{aluno['matricula']}: #{e.message}"
            end
          end
          
        rescue StandardError => e
          erros << "Erro ao processar turma #{item['code']}: #{e.message}"
        end
      end

      message = "Importação de membros concluída! Turmas criadas: #{turmas_criadas}, Alunos criados: #{alunos_criados}."
      message += " Erros: #{erros.join('; ')}" if erros.any?

      render json: { 
        message: message,
        turmas_criadas: turmas_criadas,
        alunos_criados: alunos_criados,
        erros: erros
      }, status: :ok
    end

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