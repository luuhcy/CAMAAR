<template>
    <AdminLayout active-menu-id="gerenciamento">
        <div class="import-container">
            <h1 class="page-header">Importar Dados</h1>
            <p class="subtitle">Faça o upload do arquivo CSV com as informações das turmas e alunos.</p>
            
            <div class="import-card">
                <h2>Selecione o Arquivo</h2>
                
                <div class="file-upload-area" 
                    @dragover.prevent="isDragging = true"
                    @dragleave.prevent="isDragging = false"
                    @drop.prevent="handleDrop"
                    :class="{ 'dragging': isDragging }"
                >
                    <p v-if="fileName">{{ fileName }} ({{ fileSize }})</p>
                    <p v-else>Arraste e solte o arquivo CSV aqui, ou clique para selecionar.</p>
                    
                    <input 
                        type="file" 
                        ref="fileInput" 
                        accept=".csv" 
                        @change="handleFileChange" 
                        style="display: none;"
                    />
                    <button class="btn-select-file" @click="openFilePicker">Selecionar Arquivo</button>
                </div>
                
                <button class="btn-submit" @click="submitImport" :disabled="!selectedFile">
                    Importar Dados
                </button>
                
                <div v-if="statusMessage" :class="['status-message', statusType]">
                    {{ statusMessage }}
                </div>
            </div>
            
            <button class="btn-back" @click="goBack">Voltar ao Gerenciamento</button>
        </div>
    </AdminLayout>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import AdminLayout from '~/components/AdminLayout.vue'; 

definePageMeta({
  middleware: ['admin'] 
});

const router = useRouter();
const fileInput = ref(null);
const selectedFile = ref(null);
const fileName = ref('');
const fileSize = ref('');
const isDragging = ref(false);
const statusMessage = ref('');
const statusType = ref('');

const openFilePicker = () => {
    fileInput.value.click();
};

const handleFileChange = (event) => {
    const file = event.target.files[0];
    processFile(file);
};

const handleDrop = (event) => {
    isDragging.value = false;
    const file = event.dataTransfer.files[0];
    processFile(file);
};

const processFile = (file) => {
    if (file && file.name.endsWith('.csv')) {
        selectedFile.value = file;
        fileName.value = file.name;
        fileSize.value = (file.size / 1024).toFixed(2) + ' KB';
        statusMessage.value = '';
        statusType.value = '';
    } else {
        selectedFile.value = null;
        fileName.value = '';
        fileSize.value = '';
        statusMessage.value = 'Formato inválido. Por favor, selecione um arquivo CSV.';
        statusType.value = 'error';
    }
};

const submitImport = async () => {
    if (!selectedFile.value) {
        statusMessage.value = 'Nenhum arquivo selecionado.';
        statusType.value = 'error';
        return;
    }
    
    statusMessage.value = 'Enviando e processando arquivo no servidor...';
    statusType.value = 'info';

    try {
        const formData = new FormData();
        formData.append('csvFile', selectedFile.value);

        const response = await $fetch('http://localhost:3001/admin/importar', {
            method: 'POST',
            body: formData,
        });
        
        statusMessage.value = response.message || `Sucesso! Importação concluída.`;
        statusType.value = 'success';
        selectedFile.value = null;
        fileName.value = '';
        fileSize.value = '';
        
    } catch (e) {
        statusMessage.value = e.data?.message || e.message || 'Erro interno ao processar o arquivo CSV.';
        statusType.value = 'error';
    }
};

const goBack = () => {
    router.push('/admin');
};
</script>

<style scoped>
.import-container {
    max-width: 700px;
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
.import-card {
    background-color: white;
    padding: 30px;
    border-radius: 8px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
    text-align: center;
}
h2 {
    font-size: 1.2rem;
    color: #333;
    margin-bottom: 20px;
}
.file-upload-area {
    border: 3px dashed #ccc;
    padding: 30px;
    border-radius: 6px;
    margin-bottom: 20px;
    cursor: pointer;
    transition: border-color 0.2s, background-color 0.2s;
    min-height: 100px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
}
.file-upload-area.dragging {
    border-color: #6C2365;
    background-color: #f0f0f0;
}
.btn-select-file {
    background-color: #6C2365;
    color: white;
    padding: 10px 15px;
    border: none;
    border-radius: 4px;
    margin-top: 15px;
    cursor: pointer;
    font-weight: bold;
}
.btn-select-file:hover {
    background-color: #5a1e58;
}
.btn-submit {
    background-color: #28a745;
    color: white;
    padding: 12px 25px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-weight: bold;
    transition: background-color 0.2s;
    width: 100%;
    margin-top: 10px;
}
.btn-submit:disabled {
    background-color: #ccc;
    cursor: not-allowed;
}
.btn-submit:hover:not(:disabled) {
    background-color: #218838;
}

.status-message {
    margin-top: 20px;
    padding: 10px;
    border-radius: 4px;
    font-weight: bold;
}
.status-message.error {
    background-color: #f8d7da;
    color: #721c24;
    border: 1px solid #f5c6cb;
}
.status-message.success {
    background-color: #d4edda;
    color: #155724;
    border: 1px solid #c3e6cb;
}
.status-message.info {
    background-color: #cce5ff;
    color: #004085;
    border: 1px solid #b8daff;
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
