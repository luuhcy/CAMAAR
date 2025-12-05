<template>
  <div class="page-wrapper">
    <div class="login-container">
      <div class="left-side">
        <h2 class="title">CADASTRO</h2>

        <label>Nome Completo</label>
        <input type="text" placeholder="Nome" />

        <label>Email</label>
        <input type="email" placeholder="aluno@aluno.unb.br" />

        <label>Senha</label>
        <input type="password" placeholder="Password" />

        <label>Confirmar Senha</label>
        <input type="password" placeholder="Password" />

        <button class="btn">Finalizar Cadastro</button>
        
        <p class="link-text">
          Já tem uma conta? <NuxtLink to="/login" class="router-link">Fazer Login</NuxtLink>
        </p>
      </div>

      <div class="right-side">
        <h1>Bem vindo ao CAMAAR</h1>
      </div>
    </div>
  </div>
</template>

<script setup>
</script>

<style scoped>
.page-wrapper {
  width: 100%;
  min-height: 100vh;
  background: #f0f0f0; 
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 40px 0;
}

.login-container {
  width: 780px;
  height: 520px;
  background: white;
  display: flex;
  border-radius: 15px; 
  overflow: hidden;
  box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1); 
}

.left-side {
  flex: 1.2; 
  padding: 35px 50px; 
  display: flex; 
  flex-direction: column; 
}

.title {
  text-align: center;
  margin-bottom: 20px; 
  font-weight: bold;
  font-size: 24px;
  align-self: center; 
}

label {
  margin-top: 5px; 
  margin-bottom: 3px; 
  font-size: 14px; 
}

input {
  width: 100%;
  padding: 10px; 
  margin-bottom: 8px; 
  border: 1px solid #ccc;
  border-radius: 6px;
  font-size: 15px;
}

.btn {
  width: 100%;
  background: #28a745;
  padding: 14px;
  color: white;
  border: none;
  border-radius: 6px;
  font-size: 17px;
  cursor: pointer;
  margin-top: 15px; 
}

.btn:hover {
  background: #218838;
}

.right-side {
  flex: 1.8; 
  background: #6C2365;
  color: white;
  display: flex;
  flex-direction: column; 
  justify-content: center;
  align-items: center;
  text-align: center;
  padding: 20px;
}

.right-side h1 {
  font-size: 44px; 
  font-weight: bold;
  line-height: 1.3; 
  white-space: pre-wrap;
}

.link-text {
  text-align: center;
  margin-top: 5px; 
  font-size: 14px;
}

.router-link {
  color: #6C2365;
  text-decoration: none;
  font-weight: bold;
}
</style>