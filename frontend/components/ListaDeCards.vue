<template>
  <div class="grid-container">
    <CardDeMateria 
      v-for="materia in materias" 
      :key="materia.id" 
      :materia="materia"
      @click="openAvaliacao(materia.id)"
    />
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import CardDeMateria from '~/components/CardDeMateria.vue';

const router = useRouter();

const materias = ref([
  { id: 1, nome: "Nome da matéria A", semestre: "2023.2", professor: "Prof. Silva" },
  { id: 2, nome: "Nome da matéria B", semestre: "2024.1", professor: "Prof. Souza" },
  { id: 3, nome: "Nome da matéria C", semestre: "2024.1", professor: "Prof. Santos" },
  { id: 4, nome: "Nome da matéria D", semestre: "2023.2", professor: "Prof. Oliveira" },
  { id: 5, nome: "Nome da matéria E", semestre: "2024.1", professor: "Prof. Costa" }
]);

const openAvaliacao = (id) => {
    router.push(`/admin/avaliacoes/${id}`); 
};
</script>

<style scoped>
.grid-container {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); 
  gap: 25px;
  width: 100%;
}
</style>