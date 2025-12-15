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
  min-height: 120px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s ease;
}
.card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
}
.card-content {
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 5px;
}
.subject-name { 
  margin: 0; 
  font-size: 1.1rem; 
  font-weight: bold; 
  color: #333;
  line-height: 1.3;
}
.semestre { 
  font-size: 0.85rem; 
  color: #666; 
  display: block;
}
.professor { 
  font-size: 0.85rem; 
  color: #666; 
  display: block;
  margin: 0;
}
</style>