<template>
  <div class="page-container">
    
    <header class="navbar">
      <div class="left-section">
        <div class="hamburger-icon" @click="goBack">☰</div>
        <h2 class="page-title">Avaliação - {{ materiaNome }} - {{ materiaSemestre }}</h2>
      </div>
      <div class="user-avatar">U</div>
    </header>

    <main class="content-area">
      
      <div class="form-paper">
        
        <div v-for="(pergunta, index) in perguntas" :key="index" class="question-block">
          
          <h3 class="question-title">{{ pergunta.titulo }}</h3>

          <div v-if="pergunta.tipo === 'multipla_escolha'" class="options-list">
            <label v-for="opcao in pergunta.opcoes" :key="opcao" class="radio-option">
              <input type="radio" :name="'pergunta-' + index" v-model="respostas[index]" :value="opcao" />
              <span class="radio-label">{{ opcao }}</span>
            </label>
          </div>

          <div v-if="pergunta.tipo === 'texto'" class="text-input-area">
            <input type="text" placeholder="Escreva aqui..." class="line-input" v-model="respostas[index]" />
          </div>

        </div>
        
        <p v-if="submitError" class="error-message">{{ submitError }}</p>

      </div>

    </main>

    <button class="fab-button" @click="submitForm">
      <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M2.01 21L23 12L2.01 3L2 10L17 12L2 14L2.01 21Z" fill="white"/>
      </svg>
    </button>

  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';

definePageMeta({
  middleware: ['auth'] 
});

const route = useRoute();
const router = useRouter();

const materiaNome = ref('...');
const materiaSemestre = ref('...');
const submitError = ref('');
const respostas = ref({});

const perguntas = ref([
  {
    titulo: '1. O professor entregou o plano de ensino da disciplina?',
    tipo: 'multipla_escolha',
    opcoes: ['Muito bom', 'Bom', 'Satisfatório', 'Ruim', 'Péssimo']
  },
  {
    titulo: '2. Deixe um comentário geral sobre a matéria:',
    tipo: 'texto'
  },
  {
    titulo: '3. Qual a principal sugestão de melhoria?',
    tipo: 'texto'
  },
  {
    titulo: '4. Qualidade do material de apoio oferecido?',
    tipo: 'multipla_escolha',
    opcoes: ['Muito bom', 'Bom', 'Satisfatório', 'Ruim', 'Péssimo']
  }
]);


const loadMateriaData = (id) => {
    materiaNome.value = `Matéria ID ${id}`;
    materiaSemestre.value = `2024.1`;
};

const submitForm = () => {
    const totalQuestions = perguntas.value.length;
    const answeredCount = Object.keys(respostas.value).length;
    
    if (answeredCount < totalQuestions) {
        submitError.value = `Você precisa responder a todas as ${totalQuestions} perguntas antes de enviar.`;
        return;
    }

    console.log('Formulário Enviado:', {
        materiaId: route.params.id,
        respostas: respostas.value
    });

    alert('Avaliação enviada com sucesso!');
    router.push('/avaliacoes');
};

const goBack = () => {
    router.push('/avaliacoes');
};

onMounted(() => {
    loadMateriaData(route.params.id);
});
</script>

<style scoped>
.page-container {
  display: flex;
  flex-direction: column;
  height: 100vh;
  font-family: 'Segoe UI', sans-serif;
  background-color: #D9D9D9;
}

.navbar {
  background-color: white;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
  border-bottom: 1px solid #ccc;
  flex-shrink: 0;
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
  background-color: #4A148C;
  color: white;
  border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  font-weight: bold;
}

.content-area {
  flex: 1;
  display: flex;
  justify-content: center;
  overflow-y: auto;
  padding: 40px 20px;
}

.form-paper {
  background-color: white;
  width: 100%;
  max-width: 800px;
  padding: 30px;
  border-radius: 4px;
  height: fit-content;
}

.question-block {
  background-color: #E0E0E0;
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

.text-input-area {
  padding-bottom: 5px;
}

.line-input {
  width: 50%;
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

.error-message {
    color: #dc3545;
    text-align: center;
    padding: 10px;
    border: 1px solid #dc3545;
    border-radius: 4px;
    margin-top: 20px;
    background-color: #f8d7da;
}

.fab-button {
  position: fixed;
  bottom: 30px;
  right: 40px;
  width: 60px;
  height: 60px;
  background-color: #8E24AA;
  border: none;
  border-radius: 50%;
  box-shadow: 0 4px 10px rgba(0,0,0,0.3);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: transform 0.2s;
  z-index: 100;
}

.fab-button:hover {
  transform: scale(1.1);
  background-color: #7B1FA2;
}
</style>