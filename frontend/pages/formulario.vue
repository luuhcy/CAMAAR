<template>
  <div class="page-container">
    
    <header class="navbar">
      <div class="left-section">
        <div class="hamburger-icon">☰</div>
        <h2 class="page-title">Avaliação - Nome da matéria - Semestre</h2>
      </div>
      <div class="user-avatar">U</div>
    </header>

    <main class="content-area">
      
      <div class="form-paper">
        
        <div v-for="(pergunta, index) in perguntas" :key="index" class="question-block">
          
          <h3 class="question-title">Pergunta</h3>

          <div v-if="pergunta.tipo === 'multipla_escolha'" class="options-list">
            <label v-for="opcao in pergunta.opcoes" :key="opcao" class="radio-option">
              <input type="radio" :name="'pergunta-' + index" />
              <span class="radio-label">{{ opcao }}</span>
            </label>
          </div>

          <div v-if="pergunta.tipo === 'texto'" class="text-input-area">
            <input type="text" placeholder="Placeholder" class="line-input" />
          </div>

        </div>

      </div>

    </main>

    <button class="fab-button">
      <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M2.01 21L23 12L2.01 3L2 10L17 12L2 14L2.01 21Z" fill="white"/>
      </svg>
    </button>

  </div>
</template>

<script setup>
// Mock dos dados para reproduzir a imagem
const perguntas = [
  {
    tipo: 'multipla_escolha',
    opcoes: ['Muito bom', 'Bom', 'Satisfatório', 'Ruim', 'Péssimo']
  },
  {
    tipo: 'texto'
  },
  {
    tipo: 'texto'
  },
  {
    tipo: 'multipla_escolha',
    opcoes: ['Muito bom', 'Bom', 'Satisfatório', 'Ruim', 'Péssimo']
  }
]
</script>

<style scoped>
/* --- Layout Geral --- */
.page-container {
  display: flex;
  flex-direction: column;
  height: 100vh;
  font-family: 'Segoe UI', sans-serif;
  background-color: #D9D9D9; /* Fundo cinza da tela inteira */
}

/* --- Cabeçalho --- */
.navbar {
  background-color: white;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
  border-bottom: 1px solid #ccc;
  flex-shrink: 0; /* Garante que o header não encolha */
}

.left-section {
  display: flex;
  align-items: center;
  gap: 15px;
}

.hamburger-icon {
  font-size: 1.8rem;
  cursor: pointer;
}

.page-title {
  font-size: 1.1rem;
  margin: 0;
  font-weight: 500;
  color: #000;
}

.user-avatar {
  width: 40px; height: 40px;
  background-color: #4A148C; /* Roxo */
  color: white;
  border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  font-weight: bold;
}

/* --- Área de Conteúdo --- */
.content-area {
  flex: 1;
  display: flex;
  justify-content: center; /* Centraliza o papel horizontalmente */
  overflow-y: auto; /* Scroll na página */
  padding: 40px 20px; /* Espaço em volta do papel */
}

/* O "Papel" Branco */
.form-paper {
  background-color: white;
  width: 100%;
  max-width: 800px; /* Largura máxima para não ficar muito esticado */
  padding: 30px;
  border-radius: 4px; /* Leve arredondamento */
  height: fit-content; /* Altura ajusta ao conteúdo */
}

/* --- Blocos de Perguntas --- */
.question-block {
  background-color: #E0E0E0; /* Fundo cinza de cada pergunta */
  padding: 15px 20px;
  margin-bottom: 20px;
  border-radius: 2px;
}

.question-title {
  margin: 0 0 15px 0;
  font-size: 1rem;
  font-weight: normal;
  color: #000;
}

/* Estilo Radio Buttons */
.options-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.radio-option {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 0.9rem;
  cursor: pointer;
}

/* Estilo Input Texto (Linha) */
.text-input-area {
  padding-bottom: 5px;
}

.line-input {
  width: 50%; /* Ocupa metade da largura como na imagem */
  background: transparent;
  border: none;
  border-bottom: 1px solid #666;
  padding: 5px 0;
  font-size: 0.9rem;
  outline: none;
}

.line-input::placeholder {
  color: #999;
}

/* --- Botão Flutuante (FAB) --- */
.fab-button {
  position: fixed;
  bottom: 30px;
  right: 40px;
  width: 60px;
  height: 60px;
  background-color: #8E24AA; /* Roxo vibrante */
  border: none;
  border-radius: 50%;
  box-shadow: 0 4px 10px rgba(0,0,0,0.3);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: transform 0.2s;
}

.fab-button:hover {
  transform: scale(1.1);
  background-color: #7B1FA2;
}
</style>