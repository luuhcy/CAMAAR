# Cria um usuário de teste se não existir
if User.count == 0
  User.create!(
    nome: "Admin",
    email: "admin@aluno.unb.br",
    matricula: "123456789",
    password: "12345678", # O Rails vai criptografar isso sozinho!
    tipo: "admin"
  )
  puts "Usuário Admin criado: admin@aluno.unb.br / 12345678"
end