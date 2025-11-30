<template>
  <div class="question-card">
    <h3 class="card-title">Questão {{ index + 1 }}</h3>

    <div class="field-row">
      <label class="field-label">Tipo:</label>
      <div class="select-wrapper">
        <select v-model="localQuestion.tipo" class="custom-select">
          <option value="" disabled selected>Tipo</option>
          <option value="radio">Radio</option>
          <option value="texto">Texto</option>
          <option value="checkbox">Checkbox</option>
        </select>
      </div>
    </div>

    <div class="field-row">
      <label class="field-label">Texto:</label>
      <input 
        type="text" 
        v-model="localQuestion.texto" 
        placeholder="Placeholder" 
        class="line-input"
      />
    </div>

    <div v-if="localQuestion.tipo === 'radio' || localQuestion.tipo === 'checkbox'" class="options-section">
      <div v-for="(opcao, i) in localQuestion.opcoes" :key="i" class="field-row">
        <label class="field-label">Opções:</label>
        <input 
          type="text" 
          v-model="localQuestion.opcoes[i]" 
          placeholder="Placeholder" 
          class="line-input"
        />
      </div>

      <div class="add-button-container">
        <button @click="addOption" class="plus-btn">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M12 5V19" stroke="white" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
            <path d="M5 12H19" stroke="white" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </button>
      </div>
    </div>

  </div>
</template>

<script setup>
const props = defineProps({
  index: Number,
  question: Object
})

// Usamos um ref local para manipular os dados sem mutar a prop diretamente (boa prática)
const localQuestion = ref(props.question)

const addOption = () => {
  if (!localQuestion.value.opcoes) localQuestion.value.opcoes = []
  localQuestion.value.opcoes.push('')
}
</script>

<style scoped>
.question-card {
  background-color: white;
  padding: 20px 25px;
  border-radius: 4px; /* Cantos levemente arredondados */
  margin-bottom: 20px;
  /* Sombra sutil igual à imagem */
  box-shadow: 0 1px 3px rgba(0,0,0,0.05); 
  font-family: 'Segoe UI', sans-serif;
}

.card-title {
  margin: 0 0 20px 0;
  font-size: 1rem;
  font-weight: 600;
  color: #000;
}

.field-row {
  display: flex;
  align-items: center;
  margin-bottom: 20px;
}

.field-label {
  font-weight: 500;
  color: #000;
  width: 70px; /* Largura fixa para alinhar os inputs */
  font-size: 0.9rem;
}

/* Estilo do Select (Arredondado) */
.custom-select {
  border: 1px solid #E0E0E0;
  border-radius: 20px;
  padding: 5px 15px;
  width: 200px;
  color: #666;
  outline: none;
  background-color: white;
  appearance: none; /* Remove estilo padrão do browser */
  background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23666' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
  background-repeat: no-repeat;
  background-position: right 10px center;
  background-size: 16px;
  cursor: pointer;
}

/* Estilo do Input (Linha) */
.line-input {
  flex: 1; /* Ocupa o resto da linha */
  border: none;
  border-bottom: 2px solid #999; /* Linha cinza escura */
  outline: none;
  padding: 5px 0;
  font-size: 0.9rem;
  color: #333;
}

.line-input::placeholder {
  color: #999;
}

/* Botão Mais (+) */
.add-button-container {
  display: flex;
  justify-content: center;
  margin-top: -10px;
}

.plus-btn {
  width: 24px;
  height: 24px;
  background-color: #666; /* Cinza escuro */
  border-radius: 50%;
  border: none;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: background 0.2s;
}

.plus-btn:hover {
  background-color: #444;
}
</style>