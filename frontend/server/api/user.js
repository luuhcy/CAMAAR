// frontend/server/api/user.js
export default defineEventHandler(async (event) => {
  // Simula a busca de dados do usuário no banco de dados.

  return {
    id: 101,
    nomeCompleto: 'Maria Silva',
    email: 'aluno@unb.br',
    matricula: '231003489',
    role: 'user',
    ultimoAcesso: new Date().toISOString()
  };
});