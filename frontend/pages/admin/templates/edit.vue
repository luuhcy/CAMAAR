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
                    <div v-if="activeTemplate">
                        <div class="template-header-controls">
                            <h2>{{ activeTemplate.nome }}</h2>
                            <button class="btn-delete-template">Excluir Template</button>
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

definePageMeta({
  middleware: ['admin'] 
});

const templates = ref([]);
const activeTemplate = ref(null);

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


const loadTemplates = () => {
    templates.value = mockTemplates;
    if (templates.value.length > 0) {
        activeTemplate.value = templates.value[0];
    }
};

const selectTemplate = (template) => {
    activeTemplate.value = template;
};

const addNewTemplate = () => {
    const newTemplate = {
        id: Date.now(),
        nome: 'Novo Template Sem Nome',
        semestre: '2025.1',
        questions: []
    };
    templates.value.push(newTemplate);
    activeTemplate.value = newTemplate;
};

const addQuestionToActiveTemplate = () => {
    if (activeTemplate.value) {
        activeTemplate.value.questions.push({
            id: Date.now(),
            tipo: 'radio', 
            texto: 'Nova pergunta...',
            opcoes: ['Opção 1', 'Opção 2']
        });
    }
};

const saveTemplate = () => {
    console.log('Template Salvo:', activeTemplate.value);
    alert('Template de Avaliação salvo com sucesso!');
};

onMounted(() => {
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