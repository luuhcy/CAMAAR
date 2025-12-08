<template>
    <AdminLayout active-menu-id="gerenciamento">
        <div class="template-editor-container">
            <h1 class="page-header">Edição de Templates</h1>
            <p class="subtitle">Gerencie os modelos de perguntas utilizados nas avaliações.</p>
            
            <div class="editor-layout">
                
                <aside class="template-list-sidebar">
                    <h3 class="sidebar-header">Templates Existentes</h3>
                    
                    <div 
                        v-for="template in templates" 
                        :key="template.id" 
                        class="template-card"
                        :class="{ 'active': activeTemplate && activeTemplate.id === template.id }"
                        @click="selectTemplate(template)"
                    >
                        <div class="template-name">{{ template.nome }}</div>
                        <span class="template-semestre">{{ template.semestre }}</span>
                    </div>

                    <button @click="addNewTemplate" class="btn-add-template">
                        + Novo Template
                    </button>
                </aside>
                
                <main class="template-form-area">
                    <div v-if="loading" class="loading-state">
                        <p>Carregando templates...</p>
                    </div>
                    <div v-else-if="error" class="error-state">
                        <p>Erro: {{ error }}</p>
                        <p>Usando dados de exemplo...</p>
                    </div>
                    <div v-else-if="activeTemplate">
                        <div class="template-header-controls">
                            <input 
                                v-model="activeTemplate.nome" 
                                type="text" 
                                class="template-name-input"
                                placeholder="Nome do Template"
                            />
                            <button class="btn-delete-template" @click="deleteTemplate">Excluir Template</button>
                        </div>
                        
                        <div class="question-list">
                            
                            <QuestionCard 
                                v-for="(question, index) in activeTemplate.questions" 
                                :key="question.id" 
                                :index="index"
                                :question="question"
                            />

                            <button @click="addQuestionToActiveTemplate" class="btn-add-question">
                                + Adicionar Nova Questão
                            </button>
                        </div>

                        <div class="save-footer">
                            <button class="btn-save" @click="saveTemplate">Salvar Alterações</button>
                        </div>
                    </div>
                    <div v-else class="empty-selection">
                        Selecione um template para começar a edição.
                    </div>
                </main>

            </div>
        </div>
    </AdminLayout>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import AdminLayout from '~/components/AdminLayout.vue';
import QuestionCard from '~/components/QuestionCard.vue';
import { useAuth } from '~/composables/useAuth';

definePageMeta({
  middleware: ['admin'] 
});

const { user } = useAuth();

const templates = ref([]);
const activeTemplate = ref(null);
const loading = ref(true);
const error = ref(null);

const mockTemplates = [
    { id: 1, nome: "Template Padrão I", semestre: "2024.1", 
      questions: [
        { id: 11, tipo: 'radio', texto: 'Qualidade do ensino do professor?', opcoes: ['Excelente', 'Bom', 'Ruim'] },
        { id: 12, tipo: 'texto', texto: 'Sugestões de melhoria?', opcoes: [] },
      ]
    },
    { id: 2, nome: "Template de Extensão", semestre: "2023.2", 
      questions: [
        { id: 21, tipo: 'radio', texto: 'Relevância do Projeto?', opcoes: ['Alta', 'Média', 'Baixa'] },
      ]
    },
];


const loadTemplates = async () => {
    try {
        loading.value = true;
        error.value = null;
        
        const response = await fetch('http://localhost:3001/templates');
        
        if (!response.ok) {
            throw new Error(`Erro ao carregar templates: ${response.status}`);
        }
        
        const data = await response.json();
        
        // Transformar questões em formato compatível com o frontend
        templates.value = data.map(template => ({
            id: template.id,
            nome: template.nome,
            descricao: template.descricao,
            user_id: template.user_id,
            questions: (template.questoes || []).map(q => ({
                id: q.id,
                tipo: q.tipo,
                texto: q.texto,
                obrigatoria: q.obrigatoria,
                ordem: q.ordem,
                opcoes: typeof q.opcoes === 'string' ? JSON.parse(q.opcoes || '[]') : (q.opcoes || [])
            }))
        }));
        
        if (templates.value.length > 0) {
            activeTemplate.value = templates.value[0];
        }
    } catch (err) {
        console.error('Erro ao carregar templates:', err);
        error.value = err.message;
        // Fallback para mock data em caso de erro
        templates.value = mockTemplates;
        if (templates.value.length > 0) {
            activeTemplate.value = templates.value[0];
        }
    } finally {
        loading.value = false;
    }
};

const selectTemplate = (template) => {
    activeTemplate.value = template;
};

const addNewTemplate = async () => {
    try {
        const userId = user.value?.id;
        
        if (!userId) {
            alert('Erro: Usuário não identificado. Faça login novamente.');
            return;
        }

        const response = await fetch('http://localhost:3001/templates', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                template: {
                    nome: 'Novo Template Sem Nome',
                    descricao: '',
                    user_id: userId
                }
            })
        });

        if (!response.ok) {
            throw new Error(`Erro ao criar template: ${response.status}`);
        }

        const newTemplate = await response.json();
        newTemplate.questions = [];
        templates.value.push(newTemplate);
        activeTemplate.value = newTemplate;
        alert('Template criado com sucesso!');
    } catch (err) {
        console.error('Erro ao criar template:', err);
        alert('Erro ao criar template: ' + err.message);
    }
};

const addQuestionToActiveTemplate = async () => {
    if (!activeTemplate.value) return;

    try {
        const response = await fetch('http://localhost:3001/questaos', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                questao: {
                    texto: 'Nova pergunta...',
                    tipo: 'radio',
                    obrigatoria: false,
                    ordem: (activeTemplate.value.questions?.length || 0) + 1,
                    opcoes: JSON.stringify(['Opção 1', 'Opção 2']),
                    template_id: activeTemplate.value.id
                }
            })
        });

        if (!response.ok) {
            throw new Error(`Erro ao criar questão: ${response.status}`);
        }

        const newQuestion = await response.json();
        newQuestion.opcoes = typeof newQuestion.opcoes === 'string' ? JSON.parse(newQuestion.opcoes) : newQuestion.opcoes;
        activeTemplate.value.questions.push(newQuestion);
    } catch (err) {
        console.error('Erro ao adicionar questão:', err);
        alert('Erro ao adicionar questão: ' + err.message);
    }
};

const saveTemplate = async () => {
    if (!activeTemplate.value.nome || activeTemplate.value.nome.trim() === '') {
        alert('Por favor, insira um nome para o template antes de salvar.');
        return;
    }

    try {
        const response = await fetch(`http://localhost:3001/templates/${activeTemplate.value.id}`, {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                template: {
                    nome: activeTemplate.value.nome,
                    descricao: activeTemplate.value.descricao || ''
                }
            })
        });

        if (!response.ok) {
            throw new Error(`Erro ao salvar template: ${response.status}`);
        }

        const updatedTemplate = await response.json();
        const index = templates.value.findIndex(t => t.id === updatedTemplate.id);
        if (index !== -1) {
            templates.value[index] = { ...templates.value[index], ...updatedTemplate };
        }
        alert('Template de Avaliação salvo com sucesso!');
    } catch (err) {
        console.error('Erro ao salvar template:', err);
        alert('Erro ao salvar template: ' + err.message);
    }
};

const deleteTemplate = async () => {
    if (!activeTemplate.value) return;
    
    const confirmed = confirm(`Tem certeza que deseja excluir o template "${activeTemplate.value.nome}"?`);
    
    if (confirmed) {
        try {
            const response = await fetch(`http://localhost:3001/templates/${activeTemplate.value.id}`, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json'
                }
            });

            if (!response.ok) {
                throw new Error(`Erro ao deletar template: ${response.status}`);
            }

            const index = templates.value.findIndex(t => t.id === activeTemplate.value.id);
            if (index !== -1) {
                templates.value.splice(index, 1);
                activeTemplate.value = templates.value.length > 0 ? templates.value[0] : null;
                alert('Template excluído com sucesso!');
            }
        } catch (err) {
            console.error('Erro ao deletar template:', err);
            alert('Erro ao deletar template: ' + err.message);
        }
    }
};

onMounted(() => {
    // Verificar se usuário está autenticado
    const isAuthenticated = localStorage.getItem('isAuthenticated') === 'true';
    const userRole = localStorage.getItem('userRole');
    
    if (!isAuthenticated || userRole !== 'admin') {
        navigateTo('/login');
        return;
    }
    
    loadTemplates();
});
</script>

<style scoped>
.template-editor-container {
    max-width: 1200px;
    width: 100%;
    margin: 0 auto;
}

.page-header {
    font-size: 1.8rem;
    color: #6C2365;
    margin-bottom: 5px;
}
.subtitle {
    color: #555;
    margin-bottom: 25px;
}

.editor-layout {
    display: flex;
    gap: 30px;
}

.template-list-sidebar {
    width: 300px;
    flex-shrink: 0;
    background-color: white;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
    height: fit-content;
}

.sidebar-header {
    font-size: 1.2rem;
    color: #333;
    margin-top: 0;
    margin-bottom: 15px;
    border-bottom: 1px solid #eee;
    padding-bottom: 10px;
}

.template-card {
    padding: 15px;
    margin-bottom: 10px;
    border-radius: 4px;
    cursor: pointer;
    background-color: #f9f9f9;
    transition: background-color 0.2s, border-left 0.2s;
    border-left: 5px solid transparent;
}
.template-card:hover {
    background-color: #f0f0f0;
}
.template-card.active {
    background-color: #6C2365;
    color: white;
    border-left-color: #4A148C;
}
.template-card.active .template-semestre {
    color: #f0f0f0; 
}
.template-name {
    font-weight: bold;
    font-size: 1rem;
}
.template-semestre {
    font-size: 0.8rem;
    color: #777;
}

.btn-add-template {
    width: 100%;
    padding: 10px;
    margin-top: 15px;
    border: 2px dashed #6C2365;
    background-color: transparent;
    color: #6C2365;
    border-radius: 4px;
    cursor: pointer;
    font-weight: bold;
}
.btn-add-template:hover {
    background-color: #f0f0f0;
}

.template-form-area {
    flex-grow: 1;
    background-color: white;
    padding: 30px;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.empty-selection {
    text-align: center;
    padding: 50px 20px;
    color: #999;
}

.loading-state {
    text-align: center;
    padding: 50px 20px;
    color: #666;
    font-size: 1.1rem;
}

.error-state {
    text-align: center;
    padding: 20px;
    background-color: #f8d7da;
    border: 1px solid #f5c6cb;
    border-radius: 4px;
    color: #721c24;
}

.error-state p {
    margin: 10px 0;
}

.template-header-controls {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 25px;
    border-bottom: 1px solid #eee;
    padding-bottom: 15px;
}

.template-header-controls h2 {
    margin: 0;
    font-size: 1.5rem;
    color: #333;
}

.template-name-input {
    flex-grow: 1;
    font-size: 1.8rem;
    font-weight: bold;
    color: #535353ff;
    border: none;
    background-color: transparent;
    padding: 0;
    margin: 0;
    transition: all 0.2s;
}

.template-name-input::placeholder {
    color: #ccc;
}

.template-name-input:hover,
.template-name-input:focus {
    outline: none;
    background-color: transparent;
}

.btn-delete-template {
    background: none;
    border: 1px solid #dc3545;
    color: #dc3545;
    padding: 5px 10px;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.2s;
}
.btn-delete-template:hover {
    background-color: #dc3545;
    color: white;
}

.question-list {
    margin-bottom: 20px;
}

.btn-add-question {
    width: 100%;
    padding: 10px;
    border: 2px dashed #ccc;
    background-color: transparent;
    color: #666;
    border-radius: 4px;
    cursor: pointer;
    font-weight: bold;
    transition: background-color 0.2s;
    margin-top: 10px;
}

.btn-add-question:hover {
    background-color: #e0e0e0;
}

.save-footer {
    display: flex;
    justify-content: flex-end;
    padding-top: 20px;
    border-top: 1px solid #eee;
}

.btn-save {
    background-color: #28a745;
    color: white;
    padding: 10px 20px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-weight: bold;
    transition: background-color 0.2s;
}

.btn-save:hover {
    background-color: #218838;
}
</style>