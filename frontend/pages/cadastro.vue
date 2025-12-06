<template>
  <div class="login-container">
    <div class="login-card">
      <form @submit.prevent="handleCadastro" class="login-form">
        <h2>Cadastro</h2>

        <div v-if="error" class="error-message">{{ error }}</div>

        <input type="text" v-model="nome" placeholder="Nome Completo" required />
        <input type="text" v-model="matricula" placeholder="Matrícula" required />
        <input type="email" v-model="email" placeholder="Email" required />
        <input type="password" v-model="password" placeholder="Senha (Mín. 8 caracteres)" required />
        <input type="password" v-model="confirmPassword" placeholder="Confirme a Senha" required />

        <button type="submit" class="btn-primary">Cadastrar</button>
        <p class="switch-link">
          Já tem conta? <NuxtLink to="/login">Faça Login</NuxtLink>
        </p>
      </form>
      <div class="welcome-section">
        <h1 class="welcome-title">Bem vindo ao Camaar</h1>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';

const router = useRouter();

const nome = ref('');
const matricula = ref('');
const email = ref('');
const password = ref('');
const confirmPassword = ref('');
const error = ref('');

const handleCadastro = async () => {
    error.value = '';

    if (password.value !== confirmPassword.value) {
        error.value = 'As senhas não coincidem.';
        return;
    }

    if (password.value.length < 8) {
        error.value = 'A senha deve ter no mínimo 8 caracteres.';
        return;
    }

    try {
        const response = await $fetch('/api/auth/register', {
            method: 'POST',
            body: {
                nome: nome.value,
                matricula: matricula.value,
                email: email.value,
                password: password.value,
            }
        });

        alert('Cadastro realizado com sucesso! Faça login.');
        router.push('/login');

    } catch (e) {
        error.value = e.statusMessage || 'Erro desconhecido ao tentar registrar.';
    }
};
</script>

<style scoped>
.login-container {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    background-color: #e0e0e0;
    font-family: sans-serif;
}
.login-card {
    display: flex;
    background: white;
    border-radius: 12px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
    overflow: hidden;
    max-width: 900px;
    width: 90%;
}
.login-form {
    padding: 3rem;
    flex: 1;
}
.login-form h2 {
    text-align: center;
    color: #333;
    margin-bottom: 2rem;
}
.login-form input {
    width: 100%;
    padding: 10px;
    margin-bottom: 15px;
    border: 1px solid #ccc;
    border-radius: 6px;
    box-sizing: border-box;
}
.error-message {
    background-color: #f8d7da;
    color: #721c24;
    border: 1px solid #f5c6cb;
    padding: 10px;
    border-radius: 4px;
    margin-bottom: 15px;
    text-align: center;
}
.btn-primary {
    width: 100%;
    padding: 10px;
    background-color: #6C2365;
    color: white;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-size: 1rem;
    margin-top: 10px;
    transition: background-color 0.3s;
}
.btn-primary:hover {
    background-color: #5a1e58;
}
.switch-link {
    text-align: center;
    margin-top: 15px;
    font-size: 0.9rem;
}
.switch-link a {
    color: #6C2365;
    text-decoration: none;
    font-weight: bold;
}
.welcome-section {
    flex: 1;
    background-color: #6C2365;
    color: white;
    display: flex;
    justify-content: center;
    align-items: center;
    text-align: center;
    padding: 3rem;
}
.welcome-title {
    margin: 0;
    font-size: 2rem;
}
</style>