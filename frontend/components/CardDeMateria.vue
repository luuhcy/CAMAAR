<template>
  <div class="card">
    <div class="card-content">
      <h3 class="subject-name">{{ materia.nome }}</h3>
      <span class="semestre">{{ materia.semestre }}</span>
      <p class="professor">{{ materia.professor }}</p>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  materia: {
    type: Object,
    required: true,
  }
});
</script>

<style scoped>
.card {
  background-color: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  height: 100px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  cursor: pointer;
}
.card-content {
  display: flex;
  flex-direction: column;
  justify-content: center;
  height: 100%;
}
.subject-name { 
  margin: 0 0 5px 0; 
  font-size: 1.1rem; 
  font-weight: bold; 
  color: #333; 
}
.semestre { 
  font-size: 0.8rem; 
  color: #666; 
  display: block; 
  margin-bottom: 5px; 
}
.professor { 
  font-weight: bold; 
  margin: 0; 
  font-size: 1rem; 
  color: #333; 
}
</style>