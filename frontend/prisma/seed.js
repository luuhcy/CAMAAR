// prisma/seed.js

import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

const ADMIN_EMAIL = 'admin@camaar.unb.br';
const ADMIN_MATRICULA = '000000'; 
const ADMIN_PASSWORD = process.env.ADMIN_SEED_PASSWORD; 

async function main() {
  
  if (!ADMIN_PASSWORD) {
      process.exit(1);
  }

  const salt = await bcrypt.genSalt(10);
  const hashedPassword = await bcrypt.hash(ADMIN_PASSWORD, salt);

  let adminUser = await prisma.user.findUnique({
    where: { email: ADMIN_EMAIL },
  });

  if (adminUser) {
    adminUser = await prisma.user.update({
        where: { email: ADMIN_EMAIL },
        data: { password: hashedPassword, tipo: 'admin' },
    });
    
  } else {
    adminUser = await prisma.user.create({
      data: {
        email: ADMIN_EMAIL,
        matricula: ADMIN_MATRICULA,
        nome: 'Administrador Principal',
        password: hashedPassword,
        tipo: 'admin',
      },
    });
  }
}

main()
  .catch((e) => {
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });