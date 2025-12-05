<template>
  <div class="dashboard">
    <div class="grid">
      <div v-for="turma in turmas" :key="turma.id" class="card" @click="$router.push(`/turma/${turma.id}`)">
        <h3>{{ turma.disciplina }}</h3>
        <p class="semestre">{{ turma.semestre }}</p>
        <p class="professor">{{ turma.professor }}</p>
      </div>
    </div>
  </div>
</template>

<script setup>
const { getTurmas } = useDatabase()
const turmas = getTurmas()
</script>

<style scoped>
.dashboard {
  padding: 3rem;
  background: #e5e5e5;
  min-height: 100vh;
}

.grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 2rem;
  max-width: 1200px;
  margin: 0 auto;
}

.card {
  background: white;
  padding: 2rem;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  min-height: 150px;
  cursor: pointer;
  transition: transform 0.2s, box-shadow 0.2s;
}

.card:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 16px rgba(0,0,0,0.15);
}

.card h3 {
  font-size: 1.2rem;
  font-weight: bold;
  margin-bottom: 0.5rem;
  color: #333;
  line-height: 1.3;
}

.semestre {
  color: #666;
  margin-bottom: 1.5rem;
  font-size: 0.9rem;
}

.professor {
  font-weight: bold;
  color: #333;
  font-size: 1rem;
}
</style>