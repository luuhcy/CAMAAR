// server/api/admin/importar.post.js

import { prisma } from '../../utils/db'; 
import csv from 'csv-parser';
import { Readable } from 'stream';

function parseCsv(csvString) {
    return new Promise((resolve, reject) => {
        const results = [];
        const readable = Readable.from([csvString]);

        readable
            .pipe(csv({
                mapHeaders: ({ header }) => header.trim().toLowerCase().replace(/[^a-z0-9]+/g, '')
            }))
            .on('data', (data) => results.push(data))
            .on('end', () => resolve(results))
            .on('error', (error) => reject(error));
    });
}

export default defineEventHandler(async (event) => {
    if (!event.node.req.headers['content-type']?.includes('multipart/form-data')) {
        throw createError({ statusCode: 400, message: 'Requisição inválida.' });
    }

    const files = await readMultipartFormData(event);
    const csvFile = files.find(f => f.name === 'csvFile');

    if (!csvFile) {
        throw createError({ statusCode: 400, message: 'Arquivo CSV não encontrado no formulário.' });
    }

    const dataBuffer = csvFile.data;
    const csvString = dataBuffer.toString('utf8');
    
    try {
        const data = await parseCsv(csvString);
        
        if (data.length === 0) {
            return { success: true, message: 'Sucesso! O arquivo CSV está vazio.' };
        }

        const firstRow = data[0];
        
        const semestre = firstRow.semestre;
        const disciplina = firstRow.nomedisciplina;
        const codigoTurma = firstRow.codigoturma;
        
        const ano = parseInt(semestre.split('.')[0]); 

        // 1. CRIA OU ATUALIZA A TURMA
        const turma = await prisma.turma.upsert({
            where: {
                disciplina_semestre_ano_nome: {
                    disciplina: disciplina,
                    semestre: semestre,
                    ano: ano,
                    nome: codigoTurma 
                }
            },
            update: {
                codigoSigaa: codigoTurma,
                nome: codigoTurma,
                disciplina: disciplina,
                semestre: semestre,
                ano: ano,
            },
            create: {
                codigoSigaa: codigoTurma,
                nome: codigoTurma,
                disciplina: disciplina,
                semestre: semestre,
                ano: ano,
            },
        });
        
        for (const row of data) {
            await prisma.student.upsert({
                where: { matricula: row.matriculaaluno },
                update: {
                    name: row.nomealuno,
                    email: row.email || '',
                    turmaId: turma.id,
                },
                create: {
                    name: row.nomealuno,
                    matricula: row.matriculaaluno,
                    email: row.email || '',
                    turmaId: turma.id,
                },
            });
        }
        
        return {
            success: true,
            message: `Sucesso! Turma ${turma.nome} (${turma.disciplina}) e ${data.length} dicentes importados.`,
        };

    } catch (error) {
        console.error('Erro no processamento do CSV:', error); 
        throw createError({ statusCode: 500, message: 'Falha na leitura ou salvamento dos dados CSV. Verifique o log do servidor.' });
    }
});