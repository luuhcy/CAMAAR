<template>
  <div class="grid-container">
    <CardDeMateria 
      v-for="formulario in formularios" 
      :key="formulario.id" 
      :materia="formatFormularioToMateria(formulario)"
      @click="openAvaliacao(formulario.id)"
    />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import CardDeMateria from '~/components/CardDeMateria.vue';

const router = useRouter();
const formularios = ref([]);
const loading = ref(true);
const error = ref(null);

const formatFormularioToMateria = (formulario) => {
  const codigoTurma = formulario.turma?.codigo_sigaa || '';
  const titulo = formulario.titulo || 'Sem título';
  const nomeComCodigo = codigoTurma ? `(${codigoTurma}) ${titulo}` : titulo;
  
  return {
    id: formulario.id,
    nome: nomeComCodigo,
    semestre: formulario.turma?.semestre || 'Semestre não especificado',
    professor: formulario.template?.nome || 'Template não especificado'
  };
};

const fetchFormularios = async () => {
  try {
    loading.value = true;
    const response = await fetch('http://localhost:3001/formularios');
    if (!response.ok) throw new Error('Erro ao buscar formulários');
    formularios.value = await response.json();
  } catch (err) {
    error.value = err.message;
    console.error('Erro:', err);
  } finally {
    loading.value = false;
  }
};

const openAvaliacao = (id) => {
    router.push(`/formulario/${id}`); 
};

onMounted(() => {
  fetchFormularios();
});
</script>

<style scoped>
.grid-container {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); 
  gap: 25px;
  width: 100%;
}
</style>