#!/bin/bash

# Script para criar e popular o banco de dados CAMAAR

DB_NAME="camaar.db"

echo "Criando banco de dados CAMAAR..."

# Remove banco existente se houver
if [ -f "$DB_NAME" ]; then
    rm "$DB_NAME"
    echo "Banco existente removido."
fi

# Cria as tabelas
echo "Criando estrutura do banco..."
sqlite3 "$DB_NAME" < create_database.sql

# Insere os dados
echo "Inserindo dados..."
sqlite3 "$DB_NAME" < insert_data.sql

echo "Banco de dados '$DB_NAME' criado com sucesso!"
echo ""
echo "Para acessar o banco:"
echo "sqlite3 $DB_NAME"
echo ""
echo "Consultas úteis:"
echo "- Listar tabelas: .tables"
echo "- Ver estrutura: .schema"
echo "- Contar discentes: SELECT COUNT(*) FROM discentes;"