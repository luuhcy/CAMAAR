<template>
  <div class="editor-container">
    <QuestionCard 
      v-for="(q, index) in listaDeQuestoes" 
      :key="q.id" 
      :index="index"
      :question="q"
    />
  </div>
</template>

<script setup>
// Simulando os dados da sua imagem para mostrar os 3 estados
const listaDeQuestoes = ref([
  // Estado 1: Vazio/Padrão
  { id: 1, tipo: '', texto: '', opcoes: [] },
  
  // Estado 2: Radio (com Opções e Botão +)
  { id: 2, tipo: 'radio', texto: '', opcoes: [''] },
  
  // Estado 3: Texto (Sem opções)
  { id: 3, tipo: 'texto', texto: '', opcoes: [] }
])
</script>

<style scoped>
.editor-container {
  background-color: #F5F5F5; /* Fundo cinza da tela */
  min-height: 100vh;
  padding: 40px;
  display: flex;
  flex-direction: column;
  align-items: center;
}

/* Ajuste para que os cards não fiquem largos demais na tela */
.editor-container > * {
  width: 100%;
  max-width: 600px;
}
</style>