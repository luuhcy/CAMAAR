<template>
  <div class="layout-container">
    
    <header class="navbar">
      <div class="left-section">
        <div class="hamburger-icon">☰</div>
        <h2 class="page-title">Avaliações</h2>
      </div>

      <div class="right-section">
        <div class="search-bar">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="search-icon">
            <path d="M11 19C15.4183 19 19 15.4183 19 11C19 6.58172 15.4183 3 11 3C6.58172 3 3 6.58172 3 11C3 15.4183 6.58172 19 11 19Z" stroke="#000000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            <path d="M21 21L16.65 16.65" stroke="#000000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          <input type="text" placeholder="" />
        </div>
        <div class="user-avatar">U</div>
      </div>
    </header>

    <div class="body-content">
      
      <aside class="sidebar">
        <nav>
          <ul>
            <li class="active">Avaliações</li>
            <li>Gerenciamento</li>
          </ul>
        </nav>
      </aside>

      <main class="main-grid-area">
        <div class="grid-container">
          <div v-for="materia in materias" :key="materia.id" class="card">
            <div class="card-content">
              <h3>{{ materia.nome }}</h3>
              <span class="semestre">{{ materia.semestre }}</span>
              <p class="professor">{{ materia.professor }}</p>
            </div>
          </div>
        </div>
      </main>

    </div>
  </div>
</template>

<script setup>
const materias = [
  { id: 1, nome: "Nome da matéria", semestre: "semestre", professor: "Professor" },
  { id: 2, nome: "Nome da matéria", semestre: "semestre", professor: "Professor" },
  { id: 3, nome: "Nome da matéria", semestre: "semestre", professor: "Professor" },
  { id: 4, nome: "Nome da matéria", semestre: "semestre", professor: "Professor" },
  { id: 5, nome: "Nome da matéria", semestre: "semestre", professor: "Professor" }
];
</script>

<style scoped>
/* --- CONFIGURAÇÃO GERAL --- */
* { box-sizing: border-box; }
body { margin: 0; }

.layout-container {
  display: flex;
  flex-direction: column; /* Importante: Empilha Barra em cima do Corpo */
  height: 100vh;
  font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
}

/* --- BARRA SUPERIOR (NAVBAR) --- */
.navbar {
  height: 60px;
  background-color: white;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
  /* Cria a linha divisória horizontal abaixo do cabeçalho */
  border-bottom: 1px solid #ccc; 
  z-index: 10;
}

.left-section {
  display: flex;
  align-items: center;
  gap: 20px; /* Espaço entre o hambúrguer e o título */
}

.hamburger-icon {
  font-size: 1.8rem;
  cursor: pointer;
  color: #000;
  width: 30px; /* Tamanho fixo para alinhar */
  text-align: center;
}

.page-title {
  margin: 0;
  font-size: 1.5rem;
  color: #07000f; /* Roxo */
  font-weight: 600;
}

.right-section {
  display: flex;
  align-items: center;
  gap: 20px;
}

/* Search Bar */
.search-bar {
  display: flex;
  align-items: center;
  border: 1px solid #ccc;
  border-radius: 20px;
  padding: 5px 15px;
  background: white;
  width: 300px;
  height: 40px;
}
.search-bar input { border: none; outline: none; width: 100%; font-size: 1rem; }
.search-icon { margin-right: 8px; min-width: 20px; }

/* Avatar */
.user-avatar {
  width: 40px; height: 40px;
  background-color: #4a148c;
  color: white;
  border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  font-weight: bold; font-size: 1.2rem;
}

/* --- CORPO (DIVISÃO ABAIXO DA BARRA) --- */
.body-content {
  display: flex;
  flex: 1; /* Ocupa o resto da altura */
  overflow: hidden;
}

/* Sidebar */
.sidebar {
  width: 250px;
  background-color: white;
  border-right: 1px solid #ccc; /* Linha divisória vertical apenas na parte de baixo */
  padding-top: 20px;
}

nav ul { list-style: none; padding: 0; margin: 0; }
nav li {
  padding: 15px 20px;
  cursor: pointer;
  color: #333;
  font-weight: 500;
  border-left: 5px solid transparent; /* Reserva espaço para a borda */
}
nav li.active {
  background-color: #4a148c;
  color: white;
  border-left: 5px solid #2e0e56; /* Borda roxa escura */
}

/* Conteúdo Principal */
.main-grid-area {
  flex: 1;
  background-color: #e0e0e0;
  padding: 30px;
  overflow-y: auto;
}

.grid-container {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 25px;
}

.card {
  background-color: white;
  border-radius: 12px;
  padding: 25px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
.card h3 { margin: 0 0 5px 0; font-size: 1.2rem; color: #000; }
.semestre { font-size: 0.85rem; color: #666; display: block; margin-bottom: 20px; }
.professor { font-weight: bold; margin: 0; font-size: 1rem; color: #333; }
</style>