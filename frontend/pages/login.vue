<template>
  <div class="page-wrapper">
    <div class="login-container">
      <div class="left-side">
        <h2 class="title">LOGIN</h2>
        
        <div v-if="loginError" class="error-message">{{ loginError }}</div>

        <label>Email</label>
        <input type="email" placeholder="aluno@unb.br" v-model="email" />

<<<<<<< HEAD
        <label>Email</label>
        <input type="email" placeholder="admin@aluno.unb.br" />

        <label>Senha</label>
        <input type="password" placeholder="Password" />

        <button class="btn">Entrar</button>
=======
        <label>Senha</label>
        <input type="password" placeholder="Password" v-model="password" />

        <button class="btn" @click="handleLogin">Entrar</button>
>>>>>>> e40b84ccf14988b88f05656b37560c41d7adfea1

        <p class="link-text">
          Não tem uma conta? <NuxtLink to="/cadastro" class="router-link">Cadastre-se</NuxtLink>
        </p>
<<<<<<< HEAD
=======

>>>>>>> e40b84ccf14988b88f05656b37560c41d7adfea1
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

const router = useRouter();

const email = ref('');
const password = ref('');
const loginError = ref('');

const handleLogin = async () => {
    loginError.value = '';

    const users = JSON.parse(localStorage.getItem('users') || '[]');
    
    const foundUser = users.find(user => 
        user.email === email.value && user.password === password.value
    );

    if (foundUser) {
        
        localStorage.setItem('isAuthenticated', 'true');
        localStorage.setItem('userRole', foundUser.role);
        
        try {
            console.log('Login OK. Role:', foundUser.role);
            
            if (foundUser.role === 'admin') {
                // Redireciona o ADMIN
                router.push('/admin'); 
            } else {
                // Redireciona o USUÁRIO NORMAL
                router.push('/avaliacoes'); 
            }

        } catch (error) {
            console.error('Falha ao carregar dados do usuário:', error);
            // Em caso de falha na API simulada, ainda redireciona para não travar o fluxo
            if (foundUser.role === 'admin') {
                router.push('/admin'); 
            } else {
                router.push('/avaliacoes'); 
            }
        }

    } else {
        loginError.value = 'Email ou senha inválidos. Verifique suas credenciais ou cadastre-se.';
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