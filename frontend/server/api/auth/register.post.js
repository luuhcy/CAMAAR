import { prisma } from '../../utils/db';
import bcrypt from 'bcryptjs';

export default defineEventHandler(async (event) => {
    const body = await readBody(event);
    const { nome, matricula, email, password } = body;

    if (!nome || !matricula || !email || !password || password.length < 8) {
        throw createError({ statusCode: 400, statusMessage: 'Dados incompletos ou senha muito curta.' });
    }

    const existingUser = await prisma.user.findFirst({ 
        where: { 
            OR: [
                { email: email },
                { matricula: matricula }
            ]
        }
    });

    if (existingUser) {
        throw createError({ statusCode: 409, statusMessage: 'E-mail ou matrícula já cadastrados.' });
    }

    //Hashing da Senha (Bcrypt)
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);
    
    const tipo = email.endsWith('@unb.br') ? 'admin' : 'user'; 

    try {
        const user = await prisma.user.create({
            data: {
                nome,
                matricula,
                email,
                password: hashedPassword,
                tipo,
            },
        });
        
        return { success: true, user: { id: user.id, email: user.email, tipo: user.tipo } };
    } catch (e) {
        console.error('Erro ao criar usuário:', e);
        throw createError({ statusCode: 500, statusMessage: 'Erro interno ao registrar usuário.' });
    }
});