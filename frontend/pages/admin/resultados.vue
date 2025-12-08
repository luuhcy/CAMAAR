<template>
    <AdminLayout active-menu-id="gerenciamento">
        <div class="resultados-container">
            <h1 class="page-header">📊 Resultados das Avaliações</h1>
            <p class="subtitle">Selecione uma turma para visualizar as notas e comentários consolidados.</p>

            <div class="results-list">
                <div 
                    v-for="turma in turmas" 
                    :key="turma.code + turma.classCode" 
                    class="turma-card"
                    @click="viewResults(turma)"
                >
                    <div class="code">{{ turma.code }} - {{ turma.classCode }}</div>
                    <div class="name">Semestre: {{ turma.semester }}</div>
                    <div class="docente">Prof.: {{ turma.docente.nome }}</div>
                </div>

                <div v-if="turmas.length === 0" class="empty-message">
                    Nenhuma turma importada ainda. Por favor, importe dados.
                </div>
            </div>

            <button class="btn-back" @click="goBack">Voltar ao Gerenciamento</button>
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

const router = useRouter();
const turmas = ref([]);

const loadTurmas = () => {
    const savedTurmas = JSON.parse(localStorage.getItem('turmas') || '[]');
    turmas.value = savedTurmas;
};

const viewResults = (turma) => {
    alert(`Visualizando resultados para a turma ${turma.code} (${turma.semester})`);
};

const goBack = () => {
    router.push('/admin');
};

onMounted(() => {
    loadTurmas();
});
</script>

<style scoped>
.resultados-container {
    max-width: 900px;
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
.results-list {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
    gap: 20px;
}
.turma-card {
    background-color: white;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    cursor: pointer;
    border-left: 5px solid #6C2365;
    transition: transform 0.2s;
}
.turma-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
}
.code {
    font-size: 1.1rem;
    font-weight: bold;
    color: #333;
}
.name, .docente {
    font-size: 0.9rem;
    color: #666;
    margin-top: 5px;
}
.empty-message {
    grid-column: 1 / -1;
    text-align: center;
    padding: 30px;
    background-color: #f0f0f0;
    border-radius: 8px;
    color: #999;
}
.btn-back {
    margin-top: 20px;
    background: none;
    border: none;
    color: #6C2365;
    cursor: pointer;
    text-decoration: underline;
}
</style>