<template>
  <div class="grid-container">
    <!-- Cards de formulários existentes -->
    <CardDeMateria 
      v-for="formulario in formularios" 
      :key="formulario.id" 
      :materia="formatFormularioToMateria(formulario)"
      @click="openAvaliacao(formulario.id)"
    />
    
    <!-- Card para criar novo formulário -->
    <div class="card-criar" @click="criarNovoFormulario">
      <span class="titulo-criar">Clique para criar um novo formulário</span>
    </div>
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

const criarNovoFormulario = () => {
    // TODO: Implementar navegação para página de criação de formulário
    console.log('Criar novo formulário');
    // router.push('/admin/formularios/novo');
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

.card-criar {
  background-color: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  min-height: 120px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  cursor: pointer;
  transition: all 0.3s ease;
}

.card-criar:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
}

.titulo-criar {
  font-size: 0.85rem;
  color: #333;
  text-align: center;
  font-weight: bold;
}
</style>