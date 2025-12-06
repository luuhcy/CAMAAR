import { prisma } from '../../utils/db';
import bcrypt from 'bcryptjs';

export default defineEventHandler(async (event) => {
    const body = await readBody(event);
    const { email, password } = body;

    if (!email || !password) {
        throw createError({ statusCode: 400, statusMessage: 'E-mail e senha são obrigatórios.' });
    }

    const user = await prisma.user.findUnique({ where: { email } });

    if (!user) {
        throw createError({ statusCode: 401, statusMessage: 'Credenciais inválidas.' });
    }

    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
        throw createError({ statusCode: 401, statusMessage: 'Credenciais inválidas.' });
    }

    return { 
      tipo: user.tipo,
      nome: user.nome,
      email: user.email 
    };
});