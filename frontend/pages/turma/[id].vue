<template>
  <div class="turma-page">
    <div class="header">
      <button @click="$router.back()" class="back-btn">← Voltar</button>
      <h1>{{ turma?.disciplina }}</h1>
      <p class="semestre">{{ turma?.semestre }}</p>
    </div>

    <div class="content">
      <div class="info-card">
        <h3>Informações da Turma</h3>
        <div class="info-grid">
          <div class="info-item">
            <label>Código SIGAA:</label>
            <span>{{ turma?.cod_sigaa }}</span>
          </div>
          <div class="info-item">
            <label>Professor:</label>
            <span>{{ turma?.professor }}</span>
          </div>
          <div class="info-item">
            <label>Ano:</label>
            <span>{{ turma?.ano }}</span>
          </div>
          <div class="info-item">
            <label>Turma:</label>
            <span>{{ turma?.nome }}</span>
          </div>
        </div>
      </div>

      <div class="actions-card">
        <h3>Ações</h3>
        <div class="actions-grid">
          <button class="action-btn">
            <span class="icon">📝</span>
            Criar Formulário
          </button>
          <button class="action-btn">
            <span class="icon">📊</span>
            Ver Avaliações
          </button>
          <button class="action-btn">
            <span class="icon">👥</span>
            Gerenciar Alunos
          </button>
          <button class="action-btn">
            <span class="icon">📈</span>
            Relatórios
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const route = useRoute()
const { getTurmaById } = useDatabase()

const turmaId = parseInt(route.params.id)
const turma = getTurmaById(turmaId)

if (!turma) {
  throw createError({
    statusCode: 404,
    statusMessage: 'Turma não encontrada'
  })
}
</script>

<style scoped>
.turma-page {
  min-height: 100vh;
  background: #e5e5e5;
  padding: 2rem;
}

.header {
  text-align: center;
  margin-bottom: 2rem;
}

.back-btn {
  position: absolute;
  left: 2rem;
  top: 2rem;
  background: white;
  border: 1px solid #ddd;
  padding: 0.5rem 1rem;
  border-radius: 6px;
  cursor: pointer;
}

.header h1 {
  font-size: 2rem;
  color: #333;
  margin-bottom: 0.5rem;
}

.semestre {
  color: #666;
  font-size: 1.1rem;
}

.content {
  max-width: 800px;
  margin: 0 auto;
  display: grid;
  gap: 2rem;
}

.info-card, .actions-card {
  background: white;
  padding: 2rem;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.info-card h3, .actions-card h3 {
  margin-bottom: 1.5rem;
  color: #333;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1rem;
}

.info-item {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.info-item label {
  font-weight: 600;
  color: #555;
  font-size: 0.9rem;
}

.info-item span {
  color: #333;
}

.actions-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1rem;
}

.action-btn {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  padding: 1.5rem;
  background: #f8f9fa;
  border: 1px solid #ddd;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s;
}

.action-btn:hover {
  background: #e9ecef;
  transform: translateY(-2px);
}

.action-btn .icon {
  font-size: 2rem;
}
</style>