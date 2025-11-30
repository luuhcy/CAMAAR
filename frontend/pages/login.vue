<template>
  <div class="container">
    
    <div class="left">
      <h2 class="title">LOGIN</h2>

      <div class="input-group">
        <label>Email</label>
        <input
          type="email"
          v-model="email"
          placeholder="aluno@aluno.unb.br"
        />
      </div>

      <div class="input-group">
        <label>Senha</label>
        <input
          type="password"
          v-model="senha"
        />
      </div>

      <button class="btn" @click="login">Entrar</button>
    </div>

    <div class="right">
      <h1 class="welcome">
        Bem vindo<br />
        ao<br />
        Camaar
      </h1>
    </div>

  </div>
</template>

<script setup>
const email = ref("")
const senha = ref("")

const login = () => {
  navigateTo("/avaliacoes")
}
</script>

<style scoped>
.container {
  display: flex;
  height: 100vh;
  background: #e5e5e5;
  font-family: 'Inter', sans-serif;
}

.left {
  width: 40%;
  background: #fff;
  padding: 60px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 25px;
  box-shadow: 2px 0 8px #00000015;
}

.title {
  text-align: center;
  font-size: 20px;
  margin-bottom: 20px;
  font-weight: 600;
  color: #333;
}

.input-group {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

label {
  font-size: 14px;
  font-weight: 500;
  color: #444;
}

input {
  border: 1px solid #ddd;
  padding: 10px 12px;
  border-radius: 6px;
  font-size: 14px;
}

.btn {
  background-color: #24b161; 
  color: white;
  padding: 12px;
  border: none;
  border-radius: 6px;
  font-size: 15px;
  cursor: pointer;
  margin-top: 10px;
}

.btn:hover {
  background-color: #1e9a56;
}

.right {
  width: 60%;
  background: #5c1a61; 
  color: white;
  display: flex;
  justify-content: center;
  align-items: center;
}

.welcome {
  font-size: 48px;
  text-align: center;
  line-height: 1.2;
  font-weight: 600;
}
</style>
