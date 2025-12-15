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
  const disciplina = formulario.turma?.disciplina || 'Sem disciplina';
  const nomeTurma = formulario.turma?.nome || '';
  
  // Formato: (código da disciplina) Nome da disciplina - turma
  let nomeCompleto = '';
  if (codigoTurma && disciplina && nomeTurma) {
    nomeCompleto = `(${codigoTurma}) ${disciplina} - ${nomeTurma}`;
  } else if (codigoTurma && disciplina) {
    nomeCompleto = `(${codigoTurma}) ${disciplina}`;
  } else {
    nomeCompleto = disciplina;
  }
  
  // Nome do professor criador do template
  const professorNome = formulario.template?.user?.nome || 'Professor não especificado';
  
  return {
    id: formulario.id,
    nome: nomeCompleto,
    semestre: formulario.turma?.semestre || 'Semestre não especificado',
    professor: professorNome
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