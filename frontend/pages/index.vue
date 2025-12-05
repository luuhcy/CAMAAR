<template>
  <div class="login-container">
    <div class="login-card">
      <div class="login-form">
        <h2>LOGIN</h2>
        <form @submit.prevent="handleLogin">
          <div class="form-group">
            <label>Senha</label>
            <input
              v-model="email"
              type="email"
              placeholder="admin@aluno.unb.br"
            >
          </div>
          <div class="form-group">
            <label>Confirme a senha</label>
            <input
              v-model="password"
              type="password"
              placeholder="Password"
            >
          </div>
          <button type="submit" class="login-btn">Alterar senha</button>
        </form>
      </div>
      <div class="welcome-panel">
        <h1>Bem vindo<br>ao<br>Camaar</h1>
      </div>
    </div>
  </div>
</template>

<script setup>
const email = ref('')
const password = ref('')

const handleLogin = () => {
  navigateTo('/dashboard')
}
</script>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background-color: #e5e5e5;
}

.login-card {
  display: flex;
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  max-width: 900px;
  width: 100%;
}

.login-form {
  padding: 3rem;
  flex: 1;
}

.login-form h2 {
  text-align: center;
  margin-bottom: 2rem;
  color: #333;
  font-size: 1.5rem;
  font-weight: normal;
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  color: #333;
  font-weight: normal;
}

.form-group input {
  width: 100%;
  padding: 1rem;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 1rem;
  background: #f8f9fa;
}

.form-group input:focus {
  outline: none;
  border-color: #28a745;
}

.login-btn {
  width: 100%;
  padding: 1rem;
  background-color: #28a745;
  color: white;
  border: none;
  border-radius: 6px;
  font-size: 1rem;
  cursor: pointer;
  font-weight: 500;
}

.login-btn:hover {
  background-color: #218838;
}

.welcome-panel {
  background: linear-gradient(135deg, #8e44ad, #9b59b6);
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  padding: 3rem;
}

.welcome-panel h1 {
  font-size: 3rem;
  font-weight: 300;
  text-align: center;
  line-height: 1.2;
}
</style>