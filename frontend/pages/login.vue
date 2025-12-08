<template>
  <div class="page-wrapper">
    <div class="login-container">
      <div class="left-side">
        <h2 class="title">LOGIN</h2>
        
        <div v-if="loginError" class="error-message">{{ loginError }}</div>

        <form @submit.prevent="handleLogin">
          <label>Email</label>
          <input type="email" placeholder="aluno@unb.br" v-model="email" required />

          <label>Senha</label>
          <input type="password" placeholder="Password" v-model="password" required />

          <button class="btn" type="submit">Entrar</button>
        </form>

        <p class="link-text">
          Não tem uma conta? <NuxtLink to="/cadastro" class="router-link">Cadastre-se</NuxtLink>
        </p>

      </div>

      <div class="right-side">
        <h1>Bem vindo
ao
CAMAAR</h1>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { navigateTo } from '#app';

const router = useRouter();

const email = ref('');
const password = ref('');
const loginError = ref('');

const handleLogin = async () => {
  loginError.value = '';

  try {
    // Agora chamamos o RAILS na porta 3001
    const response = await $fetch('http://localhost:3001/login', {
      method: 'POST',
      body: {
        email: email.value,
        password: password.value
      }
    });

    // Se chegou aqui, o login deu certo!
    console.log('Login Sucesso:', response);

    // Salva os dados para o site saber que está logado
    localStorage.setItem('isAuthenticated', 'true');
    localStorage.setItem('userId', response.user.id);
    localStorage.setItem('userName', response.user.nome);
    localStorage.setItem('userEmail', response.user.email);
    localStorage.setItem('userRole', response.user.tipo); // 'admin' ou 'user'

    // Redireciona
    if (response.user.tipo === 'admin') {
      router.push('/admin');
    } else {
      router.push('/avaliacoes');
    }

  } catch (err) {
    console.error(err);
    loginError.value = 'Email ou senha incorretos.';
  }
};
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
  padding: 50px;
  display: flex; 
  flex-direction: column; 
}

.title {
  text-align: center;
  margin-bottom: 30px;
  font-weight: bold;
  font-size: 24px;
  align-self: center; 
}

.error-message {
  color: red;
  margin-bottom: 10px;
  font-size: 14px;
  text-align: center;
}

label {
  margin-top: 10px; 
  margin-bottom: 5px;
  font-size: 14px; 
}

input {
  width: 100%;
  padding: 12px;
  margin-bottom: 15px; 
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
  margin-top: 20px; 
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
  margin-top: 15px;
  font-size: 14px;
}

.router-link {
  color: #6C2365;
  text-decoration: none;
  font-weight: bold;
}
</style>