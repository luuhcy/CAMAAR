// server/api/auth/login.post.js

import { prisma } from '../../utils/db';
import * as bcrypt from 'bcryptjs';

export default defineEventHandler(async (event) => {
    try {
        const body = await readBody(event);
        const { email, password } = body;

        if (!email || !password) {
            throw createError({ statusCode: 400, statusMessage: 'Email e senha são obrigatórios.' });
        }

        const user = await prisma.user.findUnique({ 
            where: { email: email } 
        });

        if (!user) {
            throw createError({ statusCode: 401, statusMessage: 'Email ou senha inválidos. Verifique suas credenciais ou cadastre-se.' });
        }

        const isMatch = await bcrypt.compare(password, user.password);

        if (!isMatch) {
            throw createError({ statusCode: 401, statusMessage: 'Email ou senha inválidos. Verifique suas credenciais ou cadastre-se.' });
        }
        
        return { 
            success: true, 
            user: { 
                id: user.id, 
                email: user.email, 
                tipo: user.tipo,
                nome: user.nome
            },
            message: 'Login bem-sucedido.'
        };

    } catch (e) {
        if (e.statusCode) {
            throw e;
        }
        console.error('Erro interno do login:', e);
        throw createError({ statusCode: 500, statusMessage: 'Erro interno durante a tentativa de login.' });
    }
});