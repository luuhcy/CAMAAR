<template>
  <div class="gerenciamento-container">
    <h1>Gerenciamento</h1>
    <p class="subtitle">Selecione uma das opções abaixo para gerenciar o sistema.</p>

    <div class="action-buttons-grid">
      <button class="btn-action green-dark" @click="handleAction('importar')">Importar dados</button>
      <button class="btn-action green-light" @click="handleAction('editar_templates')">Editar Templates</button>
      <button class="btn-action green-medium" @click="handleAction('enviar_formularios')">Enviar Formulários</button>
      <button class="btn-action green-soft" @click="handleAction('resultados')">Resultados</button>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router';

const router = useRouter();

const handleAction = (action) => {
  console.log('Ação selecionada:', action);
};
</script>

<style scoped>
.gerenciamento-container {
    background-color: white;
    padding: 40px;
    border-radius: 8px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
    width: 100%;
    max-width: 600px;
    text-align: center;
    margin-top: 50px;
}
h1 {
    color: #333;
    font-size: 1.8rem;
    margin-bottom: 5px;
}
.subtitle {
    color: #777;
    margin-bottom: 30px;
}
.action-buttons-grid {
    display: grid;
    grid-template-columns: 1fr; 
    gap: 15px;
}
.btn-action {
    width: 100%;
    padding: 15px 20px;
    color: white;
    border: none;
    border-radius: 8px;
    font-size: 1rem;
    font-weight: bold;
    cursor: pointer;
    transition: background-color 0.2s;
}

.green-dark {
    background-color: #28a745; 
}
.green-light {
    background-color: #5cb85c;
}
.green-medium {
    background-color: #82e996;
}
.green-soft {
    background-color: #b3f4c1;
    color: #333;
}

.btn-action:hover {
    opacity: 0.9;
}
</style>