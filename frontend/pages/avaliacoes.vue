<template>
  <div class="layout-container">
    <header class="navbar">
      <div class="left-section">
        <div class="hamburger-icon" @click="toggleSidebar">☰</div>
        <h2 class="page-title">Avaliações Disponíveis</h2>
      </div>
      <div class="right-section">
        <div class="profile-area">
          <div class="user-avatar" @click="toggleDropdown">U</div>
          <div class="dropdown-menu" v-if="isDropdownOpen">
            <a href="#" class="logout-btn" @click.prevent="handleLogout">Logout</a>
          </div>
        </div>
      </div>
    </header>

    <div class="body-content">
      <aside class="sidebar" :class="{ 'sidebar-closed': !isSidebarOpen }">
        <nav>
          <ul>
            <li class="active">Avaliações</li>
          </ul>
        </nav>
      </aside>
    
      <main class="main-content-area">
        <div v-if="pending">Carregando turmas...</div>
        <div v-else-if="error">Erro ao carregar turmas.</div>
        
        <div v-else class="grid-container">
          <div 
            v-for="turma in turmas" 
            :key="turma.id" 
            class="card"
          >
            <NuxtLink :to="`/formulario/${turma.id}`" class="card-link">
              <div class="card-content">
                <h3 class="subject-name">{{ turma.disciplina }}</h3>
                <p class="turma-nome">Turma: {{ turma.nome }}</p>
                <span class="semestre">{{ turma.semestre }} / {{ turma.ano }}</span>
                </div>
            </NuxtLink>
          </div>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';

definePageMeta({
  middleware: ['auth'] 
});

const router = useRouter();
const isSidebarOpen = ref(false);
const isDropdownOpen = ref(false);

// BUSCA OS DADOS DO BANCO DE DADOS
const { data: turmas, pending, error } = await useFetch('http://localhost:3001/turmas', {
    default: () => [] 
});

const toggleSidebar = () => {
  isSidebarOpen.value = !isSidebarOpen.value;
};

const toggleDropdown = () => {
    isDropdownOpen.value = !isDropdownOpen.value;
};

const handleLogout = () => {
    localStorage.removeItem('isAuthenticated');
    localStorage.removeItem('userRole');
    router.push('/login');
};
</script>

<style scoped>
/* ... Mantenha seus estilos anteriores ... */
* { box-sizing: border-box; }
body { margin: 0; }
.layout-container { display: flex; flex-direction: column; height: 100vh; font-family: sans-serif; background-color: #e0e0e0; }
.navbar { height: 60px; background-color: white; display: flex; align-items: center; justify-content: space-between; padding: 0 20px; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05); z-index: 10; }
.left-section, .right-section { display: flex; align-items: center; gap: 20px; }
.hamburger-icon { font-size: 1.8rem; cursor: pointer; color: #333; }
.page-title { margin: 0; font-size: 1.5rem; color: #333; font-weight: 600; }
.user-avatar { width: 36px; height: 36px; background-color: #6C2365; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; cursor: pointer; }
.dropdown-menu { position: absolute; top: 45px; right: 0; background: white; border: 1px solid #ddd; border-radius: 4px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); min-width: 100px; z-index: 10; }
.logout-btn { display: block; padding: 10px 15px; text-decoration: none; color: #333; font-size: 15px; }
.body-content { display: flex; flex: 1; overflow: hidden; }
.sidebar { width: 180px; background-color: white; transition: width 0.3s ease; overflow: hidden; }
.sidebar-closed { width: 0 !important; padding: 0 !important; }
nav ul { list-style: none; padding: 0; margin: 0; }
nav li { padding: 15px 20px; cursor: pointer; color: #333; font-weight: 500; font-size: 16px; }
nav li.active { background-color: #6C2365; color: white; font-weight: bold; }
.main-content-area { flex: 1; background-color: #e0e0e0; padding: 30px 40px; overflow-y: auto; display: flex; justify-content: center; align-items: flex-start; }
.grid-container { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 25px; width: 100%; max-width: 1200px; }
.card { background-color: white; border-radius: 8px; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05); height: 120px; display: flex; flex-direction: column; justify-content: center; transition: transform 0.2s; }
.card:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.1); }

/* ESTILOS NOVOS PARA O LINK */
.card-link { text-decoration: none; color: inherit; display: flex; flex-direction: column; justify-content: center; height: 100%; width: 100%; padding: 20px; }
.subject-name { margin: 0 0 5px 0; font-size: 1.2rem; font-weight: bold; color: #333; }
.turma-nome { margin: 0 0 5px 0; font-size: 0.9rem; color: #666; font-weight: 600; }
.semestre { font-size: 0.8rem; color: #888; }
</style>