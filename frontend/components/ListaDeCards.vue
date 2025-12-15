<template>
  <div>
    <div class="grid-container">
      <!-- Cards de formulários existentes -->
      <CardDeMateria 
        v-for="formulario in formularios" 
        :key="formulario.id" 
        :materia="formatFormularioToMateria(formulario)"
        @click="openAvaliacao(formulario.id)"
      />
      
    <!-- Card para criar novo formulário (somente admin) -->
    <div v-if="isAdmin" class="card-criar" @click="criarNovoFormulario">
      <span class="titulo-criar">Clique para criar um novo formulário</span>
    </div>
  </div>    <!-- Modal de criação de formulário -->
    <div v-if="showModal" class="modal-overlay" @click.self="fecharModal">
      <div class="modal-content">
        <h2 class="modal-title">{{ modoEdicao ? 'Editar Formulário' : 'Criar Novo Formulário' }}</h2>
        
        <form @submit.prevent="submitFormulario" class="formulario-form">
          <div class="form-group">
            <label for="titulo">Título do Formulário *</label>
            <input 
              type="text" 
              id="titulo" 
              v-model="novoFormulario.titulo" 
              required
              :disabled="modoEdicao"
              placeholder="Ex: Avaliação do Professor - 1º Semestre"
            />
          </div>

          <div class="form-group">
            <label for="template">Template *</label>
            <select id="template" v-model="novoFormulario.template_id" required :disabled="modoEdicao">
              <option value="">Selecione um template</option>
              <option v-for="template in templates" :key="template.id" :value="template.id">
                {{ template.nome }}
              </option>
            </select>
          </div>

          <div class="form-group">
            <label for="semestre">Semestre *</label>
            <select id="semestre" v-model="novoFormulario.semestre" required :disabled="modoEdicao" @change="filtrarTurmasPorSemestre">
              <option value="">Selecione um semestre</option>
              <option v-for="semestre in semestresDisponiveis" :key="semestre" :value="semestre">
                {{ semestre }}
              </option>
            </select>
          </div>

          <div class="form-group">
            <label for="turma">Turma *</label>
            <select id="turma" v-model="novoFormulario.turma_id" required :disabled="modoEdicao || !novoFormulario.semestre">
              <option value="">Selecione uma turma</option>
              <option v-for="turma in turmasFiltradas" :key="turma.id" :value="turma.id">
                {{ turma.codigo_sigaa }} - {{ turma.disciplina }} - {{ turma.nome }}
              </option>
            </select>
          </div>

          <div class="form-group">
            <label for="data_inicio">Data de Início *</label>
            <input 
              type="datetime-local" 
              id="data_inicio" 
              v-model="novoFormulario.data_inicio" 
              required
            />
          </div>

          <div class="form-group">
            <label for="data_termino">Data de Término *</label>
            <input 
              type="datetime-local" 
              id="data_termino" 
              v-model="novoFormulario.data_termino" 
              required
            />
          </div>

          <div class="form-actions">
            <button type="button" class="btn-cancelar" @click="fecharModal">Cancelar</button>
            <button type="submit" class="btn-criar">{{ modoEdicao ? 'Atualizar' : 'Criar Formulário' }}</button>
          </div>

          <div v-if="modalError" class="error-message">{{ modalError }}</div>
          <div v-if="modalSuccess" class="success-message">{{ modalSuccess }}</div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import { useRouter } from 'vue-router';
import CardDeMateria from '~/components/CardDeMateria.vue';

const router = useRouter();
const formularios = ref([]);
const loading = ref(true);
const error = ref(null);
const showModal = ref(false);
const templates = ref([]);
const turmas = ref([]);
const turmasFiltradas = ref([]);
const semestresDisponiveis = ref([]);
const modalError = ref('');
const modalSuccess = ref('');
const modoEdicao = ref(false);
const formularioEditando = ref(null);

// Verificar tipo de usuário
const userRole = ref('');
const userId = ref(null);
const userMatricula = ref('');

onMounted(() => {
  if (process.client) {
    userRole.value = localStorage.getItem('userRole') || '';
    userId.value = localStorage.getItem('userId') || null;
    userMatricula.value = localStorage.getItem('userMatricula') || '';
  }
});

const isAdmin = computed(() => userRole.value === 'admin');

const novoFormulario = ref({
  titulo: '',
  template_id: '',
  turma_id: '',
  semestre: '',
  data_inicio: '',
  data_termino: ''
});

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
    
    let todosFormularios = await response.json();
    
    // Se for aluno, filtrar apenas formulários não respondidos da turma dele
    if (!isAdmin.value && userMatricula.value) {
      // Buscar aluno pela matrícula
      const studentsResponse = await fetch(`http://localhost:3001/students`);
      const students = studentsResponse.ok ? await studentsResponse.json() : [];
      const alunoLogado = students.find(s => s.matricula === userMatricula.value);
      
      if (alunoLogado) {
        // Buscar respostas do aluno
        const respostasResponse = await fetch(`http://localhost:3001/respostas`);
        const todasRespostas = respostasResponse.ok ? await respostasResponse.json() : [];
        
        // Filtrar respostas pelo user_id
        const respostasDoAluno = todasRespostas.filter(r => r.user_id === parseInt(userId.value));
        const formulariosRespondidos = [...new Set(respostasDoAluno.map(r => r.formulario_id))];
        
        // Filtrar: apenas formulários da turma do aluno que ele não respondeu
        todosFormularios = todosFormularios.filter(f => 
          f.turma_id === alunoLogado.turma_id && !formulariosRespondidos.includes(f.id)
        );
      } else {
        todosFormularios = [];
      }
    }
    
    formularios.value = todosFormularios;
  } catch (err) {
    error.value = err.message;
    console.error('Erro:', err);
  } finally {
    loading.value = false;
  }
};

const fetchTemplates = async () => {
  try {
    const response = await fetch('http://localhost:3001/templates');
    if (!response.ok) throw new Error('Erro ao buscar templates');
    templates.value = await response.json();
  } catch (err) {
    console.error('Erro ao buscar templates:', err);
  }
};

const fetchTurmas = async () => {
  try {
    const response = await fetch('http://localhost:3001/turmas');
    if (!response.ok) throw new Error('Erro ao buscar turmas');
    turmas.value = await response.json();
    
    // Extrair semestres únicos
    const semestres = [...new Set(turmas.value.map(t => t.semestre))];
    semestresDisponiveis.value = semestres.sort().reverse();
  } catch (err) {
    console.error('Erro ao buscar turmas:', err);
  }
};

const filtrarTurmasPorSemestre = () => {
  if (novoFormulario.value.semestre) {
    turmasFiltradas.value = turmas.value.filter(t => t.semestre === novoFormulario.value.semestre);
  } else {
    turmasFiltradas.value = [];
  }
  novoFormulario.value.turma_id = '';
};

const openAvaliacao = (id) => {
    if (isAdmin.value) {
      // Admin: abre modal de edição
      const formulario = formularios.value.find(f => f.id === id);
      if (formulario) {
        editarFormulario(formulario);
      }
    } else {
      // Aluno: redireciona para página de responder formulário
      router.push(`/formulario/${id}`);
    }
};

const editarFormulario = (formulario) => {
    modoEdicao.value = true;
    formularioEditando.value = formulario;
    
    // Formatar datas para datetime-local (formato: YYYY-MM-DDTHH:mm)
    const formatarDataParaInput = (dataString) => {
      if (!dataString) return '';
      const data = new Date(dataString);
      const ano = data.getFullYear();
      const mes = String(data.getMonth() + 1).padStart(2, '0');
      const dia = String(data.getDate()).padStart(2, '0');
      const hora = String(data.getHours()).padStart(2, '0');
      const minuto = String(data.getMinutes()).padStart(2, '0');
      return `${ano}-${mes}-${dia}T${hora}:${minuto}`;
    };
    
    novoFormulario.value = {
      titulo: formulario.titulo,
      template_id: formulario.template_id,
      turma_id: formulario.turma_id,
      semestre: formulario.turma?.semestre || '',
      data_inicio: formatarDataParaInput(formulario.data_inicio),
      data_termino: formatarDataParaInput(formulario.data_termino)
    };
    
    // Filtrar turmas pelo semestre
    if (formulario.turma?.semestre) {
      turmasFiltradas.value = turmas.value.filter(t => t.semestre === formulario.turma.semestre);
    }
    
    showModal.value = true;
    modalError.value = '';
    modalSuccess.value = '';
};

const criarNovoFormulario = () => {
    modoEdicao.value = false;
    formularioEditando.value = null;
    showModal.value = true;
    modalError.value = '';
    modalSuccess.value = '';
};

const fecharModal = () => {
    showModal.value = false;
    modoEdicao.value = false;
    formularioEditando.value = null;
    novoFormulario.value = {
      titulo: '',
      template_id: '',
      turma_id: '',
      semestre: '',
      data_inicio: '',
      data_termino: ''
    };
    turmasFiltradas.value = [];
    modalError.value = '';
    modalSuccess.value = '';
};

const submitFormulario = async () => {
  try {
    modalError.value = '';
    modalSuccess.value = '';

    if (modoEdicao.value && formularioEditando.value) {
      // Atualizar formulário existente (apenas datas)
      const response = await fetch(`http://localhost:3001/formularios/${formularioEditando.value.id}`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          formulario: {
            data_inicio: novoFormulario.value.data_inicio,
            data_termino: novoFormulario.value.data_termino
          }
        })
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.message || 'Erro ao atualizar formulário');
      }

      modalSuccess.value = 'Formulário atualizado com sucesso!';
    } else {
      // Criar novo formulário
      const response = await fetch('http://localhost:3001/formularios', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          formulario: novoFormulario.value
        })
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.message || 'Erro ao criar formulário');
      }

      modalSuccess.value = 'Formulário criado com sucesso!';
    }
    
    setTimeout(() => {
      fecharModal();
      fetchFormularios();
    }, 1500);

  } catch (err) {
    modalError.value = err.message;
    console.error('Erro ao processar formulário:', err);
  }
};

onMounted(() => {
  fetchFormularios();
  if (isAdmin.value) {
    fetchTemplates();
    fetchTurmas();
  }
});
</script>

<style scoped>
.grid-container {
  display: flex;
  flex-wrap: wrap;
  gap: 25px;
  width: 100%;
}

.grid-container > * {
  flex: 0 0 calc(33.333% - 17px);
  min-width: 300px;
}

@media (max-width: 1200px) {
  .grid-container > * {
    flex: 0 0 calc(50% - 12.5px);
  }
}

@media (max-width: 768px) {
  .grid-container > * {
    flex: 0 0 100%;
  }
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

.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.6);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background-color: white;
  border-radius: 12px;
  padding: 30px;
  width: 90%;
  max-width: 500px;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
}

.modal-title {
  font-size: 1.5rem;
  color: #333;
  margin-bottom: 25px;
  text-align: center;
}

.formulario-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-group label {
  font-size: 0.9rem;
  font-weight: 600;
  color: #333;
}

.form-group input,
.form-group select {
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 0.95rem;
  transition: border-color 0.2s;
}

.form-group input:disabled,
.form-group select:disabled {
  background-color: #f5f5f5;
  cursor: not-allowed;
  color: #666;
}

.form-group input:focus,
.form-group select:focus {
  outline: none;
  border-color: #6C2365;
}

.form-actions {
  display: flex;
  gap: 15px;
  margin-top: 10px;
}

.btn-cancelar,
.btn-criar {
  flex: 1;
  padding: 12px;
  border: none;
  border-radius: 6px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-cancelar {
  background-color: #f0f0f0;
  color: #333;
}

.btn-cancelar:hover {
  background-color: #e0e0e0;
}

.btn-criar {
  background-color: #6C2365;
  color: white;
}

.btn-criar:hover {
  background-color: #5a1e58;
}

.error-message {
  background-color: #f8d7da;
  color: #721c24;
  padding: 10px;
  border-radius: 6px;
  font-size: 0.9rem;
  text-align: center;
}

.success-message {
  background-color: #d4edda;
  color: #155724;
  padding: 10px;
  border-radius: 6px;
  font-size: 0.9rem;
  text-align: center;
}
</style>