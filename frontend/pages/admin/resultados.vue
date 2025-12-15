<template>
    <AdminLayout active-menu-id="gerenciamento">
        <div class="resultados-container">
            <h1 class="page-header">Resultados das Avaliações</h1>
            <p class="subtitle">Selecione uma turma para visualizar as notas e comentários consolidados.</p>

            <div v-if="loading" class="loading-state">
                Carregando turmas...
            </div>

            <div v-else class="results-list">
                <div 
                    v-for="turma in turmasComRespostas" 
                    :key="turma.id" 
                    class="turma-card"
                    @click="openTurmaDetails(turma.id)"
                >
                    <div class="code">({{ turma.codigo_sigaa }}) {{ turma.disciplina }}</div>
                    <div class="name">Turma: {{ turma.nome }}</div>
                    <div class="name">Semestre: {{ turma.semestre }}</div>
                    <div class="stats">
                        <span v-if="turma.total_respostas !== undefined">
                            {{ turma.total_respostas }} {{ turma.total_respostas === 1 ? 'resposta' : 'respostas' }}
                        </span>
                        <span v-else class="ver-detalhes">Clique para ver detalhes</span>
                    </div>
                </div>

                <div v-if="turmasComRespostas.length === 0" class="empty-message">
                    Nenhum formulário com respostas encontrado.
                </div>
            </div>

            <div v-if="selectedTurma" class="modal-overlay" @click.self="closeModal">
                <div class="modal-content">
                    <button class="close-btn" @click="closeModal">×</button>
                    
                    <h2 class="modal-title">Resultados: {{ selectedTurma.disciplina }}</h2>
                    <p class="modal-subtitle">{{ selectedTurma.semestre }}</p>

                    <div v-if="loadingDetails" class="loading-details">
                        Carregando respostas...
                    </div>

                    <div v-else-if="processedResults.length === 0" class="no-data">
                        Ainda não há respostas para esta turma.
                    </div>

                    <div v-else class="questions-container">
                        <div v-for="(resultado, index) in processedResults" :key="index" class="result-block">
                            <h3 class="question-header">{{ resultado.titulo }}</h3>

                            <div v-if="resultado.tipo === 'multipla_escolha'" class="bars-chart">
                                <div v-for="(count, label) in resultado.contagem" :key="label" class="bar-row">
                                    <span class="bar-label">{{ label }}</span>
                                    <div class="bar-track">
                                        <div class="bar-fill" :style="{ width: calculatePercentage(count, resultado.total) + '%' }"></div>
                                    </div>
                                    <span class="bar-value">{{ count }} ({{ calculatePercentage(count, resultado.total) }}%)</span>
                                </div>
                            </div>

                            <div v-if="resultado.tipo === 'texto'" class="comments-list">
                                <div v-for="(comentario, i) in resultado.respostas" :key="i" class="comment-item">
                                    "{{ comentario }}"
                                </div>
                                <div v-if="resultado.respostas.length === 0" class="no-comment">Sem comentários.</div>
                            </div>
                        </div>

                        <button class="export-btn" @click="exportarCSV">
                            Exportar .csv
                        </button>
                    </div>
                </div>
            </div>

        </div>
    </AdminLayout>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import AdminLayout from '~/components/AdminLayout.vue'; 

definePageMeta({
    middleware: ['admin'] 
});

const turmas = ref([]);
const turmasComRespostas = ref([]);
const loading = ref(true);
const loadingDetails = ref(false);
const selectedTurma = ref(null);
const processedResults = ref([]); // Onde guardaremos os dados consolidados
const respostasRaw = ref([]); // Armazenar respostas brutas para exportação

// ESQUEMA DAS PERGUNTAS (Deve bater com a ordem do formulário/[id].vue)
// Precisamos disso para saber que o índice "0" é a pergunta do Plano de Ensino, etc.
const SCHEMA_PERGUNTAS = [
  { index: '0', titulo: '1. O professor entregou o plano de ensino?', tipo: 'multipla_escolha' },
  { index: '1', titulo: '2. Comentários Gerais', tipo: 'texto' },
  { index: '2', titulo: '3. Sugestão de Melhoria', tipo: 'texto' },
  { index: '3', titulo: '4. Qualidade do Material', tipo: 'multipla_escolha' }
];

// 1. Carrega a lista de turmas da API e filtra apenas as que têm respostas
const loadTurmas = async () => {
    loading.value = true;
    try {
        // Buscar formulários
        const formulariosResponse = await fetch('http://localhost:3001/formularios');
        if (!formulariosResponse.ok) throw new Error('Falha ao buscar formulários');
        const formularios = await formulariosResponse.json();

        // Buscar respostas
        const respostasResponse = await fetch('http://localhost:3001/respostas');
        if (!respostasResponse.ok) throw new Error('Falha ao buscar respostas');
        const respostas = await respostasResponse.json();

        // Filtrar apenas formulários com respostas
        const formulariosComRespostas = formularios.filter(f => 
            respostas.some(r => r.formulario_id === f.id)
        );

        // Mapear para extrair turmas únicas
        const turmasMap = new Map();
        formulariosComRespostas.forEach(f => {
            if (f.turma && !turmasMap.has(f.turma.id)) {
                turmasMap.set(f.turma.id, {
                    ...f.turma,
                    total_respostas: respostas.filter(r => 
                        formulariosComRespostas.some(form => 
                            form.turma_id === f.turma.id && form.id === r.formulario_id
                        )
                    ).length
                });
            }
        });

        turmasComRespostas.value = Array.from(turmasMap.values());
    } catch (error) {
        console.error("Erro ao carregar turmas:", error);
        alert("Erro ao conectar com o servidor.");
    } finally {
        loading.value = false;
    }
};

// 2. Abre o modal e carrega as respostas daquela turma específica
const openTurmaDetails = async (turmaId) => {
    loadingDetails.value = true;
    processedResults.value = [];
    
    try {
        // Busca os detalhes da turma (esperando que o Rails retorne o formulário e as respostas aninhadas)
        // Se o seu endpoint /turmas/:id não retornar as respostas, precisaremos ajustar o Rails
        const response = await fetch(`http://localhost:3001/turmas/${turmaId}`);
        const data = await response.json();
        
        selectedTurma.value = data;
        
        // Verifica se existem respostas no objeto retornado
        // Estrutura esperada: data.formulario.respostas (array)
        respostasRaw.value = data.respostas || [];

        
        processedResults.value = consolidarDados(respostasRaw.value);


    } catch (error) {
        console.error(error);
        alert('Erro ao carregar detalhes da avaliação.');
        selectedTurma.value = null;
    } finally {
        loadingDetails.value = false;
    }
};

const closeModal = () => {
    selectedTurma.value = null;
};

// 3. Lógica para transformar o JSON cru em dados visuais
const consolidarDados = (listaRespostas) => {
  // Inicializa a estrutura baseada no schema
  const consolidadas = SCHEMA_PERGUNTAS.map(p => ({
    ...p,
    respostas: [],     // Para perguntas de texto
    contagem: {},      // Para múltipla escolha (ex: { "Bom": 5 })
    total: 0
  }));

  // Percorre cada resposta (um registro por aluno)
  listaRespostas.forEach(registro => {
    let respostasAluno;

    try {
      respostasAluno =
        typeof registro.data_resposta === 'string'
          ? JSON.parse(registro.data_resposta)
          : registro.data_resposta;
    } catch (error) {
      console.error('Erro ao parsear data_resposta:', registro.data_resposta);
      return;
    }

    if (!respostasAluno) return;

    // Consolida cada pergunta
    consolidadas.forEach(pergunta => {
      const valorResposta = respostasAluno[pergunta.index];

      // Ignora respostas vazias
      if (
        valorResposta === undefined ||
        valorResposta === null ||
        valorResposta === ''
      ) {
        return;
      }

      pergunta.total++;

      if (pergunta.tipo === 'texto') {
        pergunta.respostas.push(valorResposta);
      } else {
        if (!pergunta.contagem[valorResposta]) {
          pergunta.contagem[valorResposta] = 0;
        }
        pergunta.contagem[valorResposta]++;
      }
    });
  });

  return consolidadas;
};



const calculatePercentage = (count, total) => {
    if (!total) return 0;
    return Math.round((count / total) * 100);
};

// Função para escapar valores CSV (trata vírgulas, aspas e ponto-e-vírgulas)
const escaparCSV = (valor) => {
    if (valor === null || valor === undefined) return '';
    
    const valorString = String(valor);
    
    // Se contém vírgula, ponto-e-vírgula, aspas ou quebra de linha, deve ser envolvido em aspas
    if (valorString.includes(',') || valorString.includes(';') || valorString.includes('"') || valorString.includes('\n')) {
        // Duplica aspas internas (padrão CSV)
        return `"${valorString.replace(/"/g, '""')}"`;
    }
    
    return valorString;
};

// Função para exportar CSV
const exportarCSV = () => {
    if (!selectedTurma.value || respostasRaw.value.length === 0) {
        alert('Nenhuma resposta disponível para exportar');
        return;
    }

    // Cabeçalho do CSV
    const headers = ['Aluno ID', 'Data Resposta', 'Status'];
    
    // Adicionar os títulos reais das perguntas
    SCHEMA_PERGUNTAS.forEach((pergunta) => {
        // Remove a numeração do início (ex: "1. " ou "2. ")
        const tituloLimpo = pergunta.titulo.replace(/^\d+\.\s*/, '');
        headers.push(tituloLimpo);
    });

    let csvContent = headers.map(h => escaparCSV(h)).join(',') + '\n';

    // Processar cada resposta
    respostasRaw.value.forEach(resposta => {
        let respostasAluno;
        
        try {
            respostasAluno = typeof resposta.data_resposta === 'string' 
                ? JSON.parse(resposta.data_resposta) 
                : resposta.data_resposta;
        } catch (error) {
            console.error('Erro ao parsear resposta:', error);
            return;
        }

        const linha = [
            escaparCSV(resposta.user_id),
            escaparCSV(resposta.created_at || new Date().toISOString()),
            escaparCSV(resposta.status || 'enviado')
        ];

        // Adicionar respostas de cada pergunta
        SCHEMA_PERGUNTAS.forEach(pergunta => {
            const valorResposta = respostasAluno?.[pergunta.index] || '';
            linha.push(escaparCSV(valorResposta));
        });

        csvContent += linha.join(',') + '\n';
    });

    // Criar blob e fazer download
    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    const url = URL.createObjectURL(blob);
    
    link.setAttribute('href', url);
    link.setAttribute('download', `respostas_${selectedTurma.value.disciplina}_${selectedTurma.value.semestre}.csv`);
    link.style.visibility = 'hidden';
    
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
};

onMounted(() => {
    loadTurmas();
});
</script>

<style scoped>
/* Layout Base */
.resultados-container { max-width: 1000px; width: 100%; margin: 0 auto; padding: 20px; }
.page-header { font-size: 1.8rem; color: #6C2365; margin-bottom: 5px; }
.subtitle { color: #555; margin-bottom: 25px; }

/* Grid de Turmas */
.results-list { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; }
.turma-card {
    background-color: white;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    cursor: pointer;
    border-left: 5px solid #6C2365;
    transition: all 0.2s ease;
}
.turma-card:hover { transform: translateY(-3px); box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1); }
.code { font-size: 1.1rem; font-weight: bold; color: #333; margin-bottom: 8px; }
.name { font-size: 0.9rem; color: #666; margin-top: 3px; }
.stats { margin-top: 15px; font-size: 0.85rem; color: #8E24AA; font-weight: 600; }
.ver-detalhes { text-decoration: underline; }

/* Modal Overlay */
.modal-overlay {
    position: fixed; top: 0; left: 0; right: 0; bottom: 0;
    background-color: rgba(0,0,0,0.5);
    display: flex; justify-content: center; align-items: center;
    z-index: 1000;
}
.modal-content {
    background: white; width: 90%; max-width: 800px; max-height: 90vh;
    border-radius: 8px; padding: 30px; position: relative;
    overflow-y: auto; box-shadow: 0 10px 25px rgba(0,0,0,0.2);
}
.close-btn {
    position: absolute; top: 15px; right: 20px;
    background: none; border: none; font-size: 2rem; cursor: pointer; color: #666;
}
.modal-title { margin: 0; color: #6C2365; }
.modal-subtitle { margin-top: 5px; color: #666; font-size: 0.9rem; margin-bottom: 20px; border-bottom: 1px solid #eee; padding-bottom: 15px;}

/* Resultados dentro do Modal */
.questions-container { display: flex; flex-direction: column; gap: 30px; }
.result-block { background-color: #f9f9f9; padding: 15px; border-radius: 6px; border: 1px solid #eee; }
.question-header { margin-top: 0; font-size: 1rem; color: #333; margin-bottom: 15px; }

/* Gráficos de Barra (CSS Puro) */
.bar-row { display: flex; align-items: center; margin-bottom: 8px; font-size: 0.9rem; }
.bar-label { width: 120px; text-align: right; padding-right: 10px; color: #555; }
.bar-track { flex: 1; height: 20px; background-color: #e0e0e0; border-radius: 10px; overflow: hidden; margin-right: 10px; }
.bar-fill { height: 100%; background-color: #8E24AA; transition: width 0.5s ease; }
.bar-value { width: 60px; font-weight: bold; color: #333; }

/* Lista de Comentários */
.comments-list { display: flex; flex-direction: column; gap: 10px; max-height: 200px; overflow-y: auto; }
.comment-item { background: white; padding: 10px; border-left: 3px solid #ccc; font-style: italic; color: #555; font-size: 0.9rem; }
.no-comment { color: #999; font-style: italic; }

/* Botão Exportar */
.export-btn {
    width: 100%;
    margin-top: 20px;
    padding: 12px 24px;
    background-color: #6C2365;
    color: white;
    border: none;
    border-radius: 6px;
    font-size: 1rem;
    font-weight: 600;
    cursor: pointer;
    transition: background-color 0.2s ease;
}
.export-btn:hover {
    background-color: #8E24AA;
}
</style>